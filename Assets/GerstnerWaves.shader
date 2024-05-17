
Shader "Custom/GerstnerWaves" {
	Properties {
		//Watercolors
		_ColorWater("Colorshallow", Color) = (0,0.2,1,1)
		_ColorWaterDeep("",Color) = (0,0.1,0.3,1)		
		//Main textures
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_HeightMap ("Heights", 2D) = "white" {}
		_HeightMap2 ("Heights", 2D) = "white" {}
		//octaves and amount of iterations
		_octaves("Octaves for brownian motion",int) = 8
		_Amountofwaves("amount of waves to add after the first 4",int) = 8
		//Glossiness
		_Glossiness ("Smoothness", Range(0,1)) = 0.1
		//Each wave
		_Wave1 ("Wave (direction[x,y], steepness Q[z], wavelength[w])", Vector) = (1,0,0.01,60)
		_Wave2 ("Wave (direction[x,y], steepness Q[z], wavelength[w])", Vector) = (0,1,0.01,20)
		_Wave3 ("Wave (direction[x,y], steepness Q[z], wavelength[w])", Vector) = (1,1,0.01,10)
		_Wave4 ("Wave (direction[x,y], steepness Q[z], wavelength[w])", Vector) = (1,1,0.01,1)
		//Subsurface scattering
		_SubsurfPower("Strength of subsurface scattering",float) = 10
		_Subsurfscale("Scale of subsurface scattering",float) = 10
		_Subsurf_attenuation("transmission loss of subsurface",float) = 0.1
	}	
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha


		CGPROGRAM
		//To indicate that the surface shader should use the vertex vert function
		#pragma surface surf StandardSpecular fullforwardshadows vertex:vert addshadow
		#pragma target 4.5
		#include "UnityPBSLighting.cginc"


		sampler2D _MainTex;
		sampler2D _HeightMap;
		sampler2D _HeightMap2;
		fixed4 _ColorWater,_ColorWaterDeep;
		float4 _FMBresolution;
		float _Speed,_Sharpness;
		int _WaveCount;
		float4 _Wave1,_Wave2,_Wave3,_Wave4;
		float3 viewDir;
		half _Glossiness;
		int _octaves;
		int _Amountofwaves;
		float _NSnell;
		float _KDiffuse;
		float4 _SunDir;
		float _Foamdistance;
		float thickness;
		float _SubsurfPower;
		float _Subsurfscale;
		float _Subsurf_attenuation;

		struct Input {
            float2 uv_MainTex;
			float3 normal : NORMAL;
			float3 worldRefl;
			float3 pos: POSITION;
			float3 worldNormal; 
			float3 viewDir;

			INTERNAL_DATA
		};

		//From bookof shaders: https://thebookofshaders.com/13/
		//return random number
	float random (float2 N) {
    	return frac(sin(dot(N,float2(12.9898,78.233)))*43758.5453123);
	}
	//Create perlin noise 
	float perlinnoise(float2 pos){
		float2 i = floor(pos);
		float2 f = frac(pos);
		//each corner of a 2d tile:
		float c1 = random(i+float2(0,0));
		float c2 = random(i+float2(1,0));
		float c3 = random(i+float2(0,1));
		float c4 = random(i+float2(1,1));
		float2 u = f*f * (3.0-2.0*f);
		return lerp(c1,c2,u.x)+(c3-c1)*u.y*(1.0-u.x) +(c4-c2)*u.x*u.y;
	}

	//Create perlin noise for waves
	float perlinnoise_wave(float4 pos){
		float4 i = floor(pos);
		float4 f = frac(pos);
		//each corner of a 2d tile:
		float c1 = random(i+float2(0,0));
		float c2 = random(i+float2(1,0));
		float c3 = random(i+float2(0,1));
		float c4 = random(i+float2(1,1));
		float4 u = f*f * (3.0-2.0*f);
		return lerp(c1,c2,u.x)+(c3-c1)*u.y*(1.0-u.x) +(c4-c2)*u.x*u.y;
	}
	//Create a FBM noise
	float FBM(float2 pos, int octaves){
		float value = 0.0;
		float amp = 0.82;
		float freq = 1.18;

		for (int i = 0; i < octaves; i++) {
			value += amp * perlinnoise(pos);
			pos *= 2.;
			amp *= .5;
		}
		return value;
	}
	//FBM for a wave
	float4 FBM_wave(inout float4 wave, int octaves){
		wave.z *=0.58;
		float2 newdir = random(wave.xy);
		wave.xy = newdir;
		return wave;

	}
	

	// Subsurface scattering based on  https://www.alanzucconi.com/2017/08/30/fast-subsurface-scattering-2/
	inline fixed4 LightingStandardTranslucent(SurfaceOutputStandardSpecular s,
		fixed3 viewDir, UnityGI gi){

			fixed4 basemat = LightingStandardSpecular(s,viewDir,gi);
			float3 light = gi.light.dir+s.Normal;
			float3 viewdir = viewDir;
			float3 normal = s.Normal;
			//halfway vector and distortion factor
			float3 H = normalize(light+normal*0.2);
			//Intensity 
			float intensity = pow(saturate(dot(normalize(viewDir), -H)),_SubsurfPower) * _Subsurfscale;
			basemat.rgb = basemat.rgb+lerp(_ColorWaterDeep,_ColorWater,1)*intensity;
			return basemat;
		}

	void LightingStandardTranslucent_GI(SurfaceOutputStandardSpecular s,
		UnityGIInput data, inout UnityGI gi){
            UNITY_GI(gi, s, data);

		}


		//The creation of a wave displacement and normals
		float3 GW(float4 wave, float3 pos, inout float3 tangent, inout float3 binormal) {
			//get the direction of the wave and normalize it
			float2 dir = normalize(wave.xy);
			//wavelength 
			float wavelength = wave.w;
			//frequency
			float w = (1.0 /wavelength) ;
			//Wavenumber
			float wavenumber = 2.0*UNITY_PI / wavelength;
			//speed of wave
			float C = sqrt(9.8/wavenumber);
			//Crest, pointiness or sharpness of wave
			float sharpness = (wave.z);
			//aplitude is controlled by wavenumber:
			float Amp = sharpness/(wavenumber);
			//term inside a sin or cosine function
			float trig_term = wavenumber*(dot(dir,pos.xz) - C*_Time.y);
			//Tangent of a point
			tangent +=float3(
				-dir.x*dir.x*sharpness*sin(trig_term),
				dir.x *sharpness*cos(trig_term),
				-dir.x*dir.y * sharpness*sin(trig_term)
			);
			//Binormal of a point

			binormal +=float3(
			-dir.x*dir.y * sharpness*sin(trig_term)
			,dir.y *sharpness*cos(trig_term)
			,-dir.y*dir.y*sharpness*sin(trig_term)

			);
			//Return displacement as a vector3
			return float3(
				Amp*dir.x*cos(trig_term),
				Amp*sin(trig_term),
				Amp*dir.y*cos(trig_term)
			);
		}

		//Performs displacement and 
		void vert(inout appdata_full vertexData) {
			float3 V = vertexData.vertex.xyz;
			float3 p = V;
			//Create an FBM based on texture coordinates, add an additional one to randomize it more
			float fbm = FBM(vertexData.texcoord+FBM(vertexData.texcoord -_Time.y*0.01, _octaves), _octaves);
			//the 1 from the equations is place here due to avoiding incorrect accumulation
			
			float3 tangent = float3(1, 0, 0);
			float3 binormal = float3(0, 0, 1);
			//Add displacement to the mesh
			p += GW(_Wave1,V,tangent, binormal);
			p += GW(_Wave2 ,V,tangent, binormal);
			p += GW(_Wave3,V,tangent, binormal);
			p += GW(_Wave4,V,tangent, binormal);
			//Add random waves for more variation
			for(int i =0; i <=_Amountofwaves; i++){
		
				p+= GW(FBM_wave(_Wave1,_octaves),V,tangent,binormal);
				p+= GW(FBM_wave(_Wave2,_octaves),V,tangent,binormal);
				p+= GW(FBM_wave(_Wave3,_octaves),V,tangent,binormal);
				p+= GW(FBM_wave(_Wave4,_octaves),V,tangent,binormal);


			}
			vertexData.texcoord +=fbm;

			//Normal is the cross product of tangent and binormal:
			float3 normal = (cross(binormal, tangent));
			//Pass normal and vertex data
			vertexData.vertex.xyz = p;
			vertexData.normal = UnityObjectToWorldNormal(normal);
		
		}
		
		//handles rendering
		void surf (Input IN, inout SurfaceOutputStandardSpecular o) {			
			//Sample the skybox and decode so that the values are in RGB
			half4 skybox = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0,IN.worldRefl);
			half3 skyboxrgb = DecodeHDR(skybox,unity_SpecCube0_HDR);
			//Reflection factor R, a simplified version from : https://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter07.html
			float R = dot(IN.viewDir,tex2D(_HeightMap,IN.uv_MainTex));
			//Interpolate between two colors
			float4 Watercolor = lerp(_ColorWater,_ColorWaterDeep,R);
			//Base color
			fixed4 c = tex2D(_MainTex,IN.uv_MainTex)*Watercolor;
			//Apply reflections to color
			c.rgb = lerp(c.rgb,skybox,R);
			//Apply ALbedo,normals, specularity and smoothness
			o.Albedo = c.rgb+Watercolor.rgb;
			o.Normal = normalize((UnpackNormal(tex2D(_HeightMap, IN.uv_MainTex)) + UnpackNormal(tex2D(_HeightMap2, IN.uv_MainTex)) )+IN.normal);
			//To reduce the stylized nature, remove R from both specular and smoothness
			//also reduce the smoothness in the inspector
			o.Specular = R*Watercolor;
			o.Smoothness = _Glossiness+R;
		}
		ENDCG
	}
}


