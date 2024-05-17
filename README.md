# DH2323_Ocean_simulation
The repository for my DH2323 real-time ocean simulation using Unity and ShaderLab. Use of this repository is allowed to be shown and used for future students as long as the repository is referenced clearly. 


## Week 20 

During the final week most of my focus was spent writing and reflecting on the project as a whole while also adjusting the appearance of the shader. It was turbulent and little bit chaotic but nonetheless it was still fun and I learned a great deal. To view more image and video examples of the shader I recommend checking this Google Drive link: https://drive.google.com/drive/folders/1ZzEJeMdkp2FbshOS-DLsnykrvT7sTRme?usp=sharing. Below is one of the final images: 

![image](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/7b9e140a-d471-4ab1-8ff0-055a5cc8e0c5)




## Week 19 Rendering and fine tweaking

Start of this week the focus was largely spent on adding some more complex rendering to my surface shader such as reflection, refraction and Fresnel. Wheter or not I plan to use tessendorfs lighting model or use a more common model is yet to be decided. Alot of experimentation was done but I settled for using skybox reflections in combination with a simple Fresnel approximation. Overall the appearance become quite stylized but I was satisified with the results. I also tried to implement some subsurface scattering but the change was barely noticable for this type of mesh. Below are some images with varying parameters and angles: 

![baseshader](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/a866e1c5-1462-42e2-9287-94dc035b5b06)

![baseshader2](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/bd2c2eb1-010c-4418-8cdd-84a445341246)


![Maxsmoothness](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/60d1fbcc-661b-46e5-8893-95673fcf9579)

![withoutsmoothness](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/35da26fa-2a11-4e02-be61-1abc62011676)


## Week 18 Gerstner waves

During this week I focused on implementing the gerstner wave algorithm using unitys standard surface shader. The shader contains two major parts, a vertex and a surface shader component. The vertex shader is responsible for the displacement of the mesh (I.e the animation) while the surface shader handles all coloring of the surface. 
The motion of the mesh is based on both tessendorfs dissatisfied description of Gerstner waves which uses the sum of sines method. This was done in the vertex shader.** I plan to make use of both Gerstner Waves and Fractal Brownian motion


### Gerstner waves: 

Gerstner waves are a common way to simulate ocean motion where the discplacement occurs in a circular motion: 

![image](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/e697292a-19d2-419c-ba29-ccd0baacaac6)

Figure 1.2 Motion of Gerstner wave from Wikipedia

in short instead of purely displacing vertices up and down the points move horizontally as well and a point P can be described as: 

P (x,y,t) = ( x+ W1(),y+ W2(), W3(),)

where 
W1() =  QiAiDi.x cos(wiDi(x,y) +ti)
W2() =  QiAiDi.y cos(wiDi(x,y) +ti)
W3() =  Aisin(wiDi(x,y) +ti)

### Fractal Brownian Motion: 

Fractal Brownian Motion is the process of creating values that tend to similar to previous values but still appear random to us humans. It is essential created through multiple layers of perlin noise and is a common application within procedural generation. In short it is used to create random values without being completely random. I higly recommend to read this chapter from The Book of Shaders: https://thebookofshaders.com/13/ as it explains the concept quite well. 



Current version of my ocean shader. 
![image](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/e76ef8c2-6af6-4208-984b-8343d90bef11)

While certainly better than earlier attempts I felt dissatisfied with the current lighting and and lack of subsurface scattering. My focus will be to implement these features. The overall appearance of the ocean is largely based on the amount of waves that are being added in combination with the amount of fractual browninan motion thats being added and will final tweaking will be done later. 

Early versions of Gerstner wave simulations are shown below: 

![image](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/c98260e2-4743-419d-a659-6d4b05c5877f)




Week 18 saw alot of experimentation with C++ and unity, however due to having to many issues with this I decided to change my approach again. This time making use of Unity built in shader language in combination. 
So far I have managed to generate a ocean tile and animate it according to the sum of sines principle which was outlined by GPU gems: https://developer.nvidia.com/gpugems/gpugems/part-i-natural-effects/chapter-1-effective-water-simulation-physical-models. The code to generate the ocean was done via C#, however the movement and the shading was done via unity shaders since it is more performance friendly. Thus the focus will be more the gerstner wave animations using the sum of sines method rather than implementing an FFT algorithm. 

I realized that i probably overcomplicated and I will likely do the FFT variation as a future project. I did alot more research and found so many variations of the ocean simulation Gerstner waves, eulerwaves, and of course sum of sines princinple, which was quite overwhelming to be honest. Thus i decided to start simple and build the project up in complexity. 

Below are some fun results: 
![Sumofsinewave](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/a986816a-5ee6-4830-8f14-d0ba4b43e9ae)


![Gerstner wave_fun](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/7e91df3c-7e34-4dba-8e6c-05d6ce9e30a9)

I avoided at first gerstner waves as they had an easier tendence to clip through each other. Instead I simply raised to the sinusoid term to an exponent K as a start.

![image](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/b8850081-7128-4056-a861-7206ef68f3d6)

Image From GPU gems chapter 1.

## Week 16-17 


These weeks saw unfortunatly little work as my time was largely spent on my bachelor thesis. However I did manage to explore some alternative. I found some difficulty with getting a DLL with c++ to work in unity, so I explored some alternatives. Firstly I explored what alternatives existed for practical implementation. These alternatives included making all code run within Unity and therefore use only C#. However since I wanted to try something new (Have worked with similar things in the course DD1354 Models and simulations) I decided to exclude this alternative. Still a previous project blog for this course provide to be quite useful (while add links to it later as they found really good sources/academic papers on the topic). 

Another less familiar alternative for me to use OpenGL in combination with different libraries. These included GLFW and Glad. I followed some tutorials but found that this approach to be too time consuming for my current circumstances with other courses.

For those people who want to explore this rabbithole a good tutorial which proved to be quite useful/beginner friendly was the "Modern Opengl guide test" by Alexander Overvoorde

https://raw.githubusercontent.com/Overv/Open.GL/master/ebook/Modern%20OpenGL%20Guide.pdf 

Thus after plenty of testing other alternatives I came back to my original idea with using Unity together with a custom built DLL to simulate the ocean. The results so far are decent considering the little time spent: 

![image](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/9db3e4ad-74d1-448b-9580-3ee5d4f07723)
![image](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/94328725-1c61-44e9-ba27-7e196ef09afa)

While the ocean is not moving I am happy that I managed to make the ocean generation happen outside of Unity. 

## Week 15:


I have followed a super basic Unity DLL tutorial to better understand how to structure my project. Below is my project specification: 



## Real time ocean simulation in Unity using Gerstner Waves, Sum of sines and Fractal Brownian Motion 


## Background
Within the entertainment industry, different computer graphics techniques are applied depending on the media form and the technical requirements. Movies such as Titanic have made use of visual effects to simulate behavior and movements of oceans. While impressive these ocean simulations are often done through complex fluid simulations or through the use of particle systems, both of which can be impractical for real time simulations such as games due to the strict performance requirements that limited hardware specs create. These limitations make the use of other methods necessary to simulate oceans. 
Problem
Ocean simulations in movies are often done as offline renders since there is no interactivity. For games and other interactive media this is not an option as these mediums require real time performance, often on less capable hardware. Thus rendering these oceans in real time with an acceptable frame-rate while still having a satisfactory appearance becomes critical. 

## Implementation

Technical 
My implementation will be in Unity through the use of both C# and standard surface shader which makes use of the HLSL language. C# will be used to generate the ocean tile while the surface shader will handle both the mesh displacement (animation) and the rendering. 

Code and the work progress will be documented on Github: https://github.com/AKSB-GP/DH2323_Ocean_simulation 





## Theoretical 
I will base the ocean simulations on a combination of the Sum of sines method, Gerstner Waves and Fractal Brownian Motion. This method provides in-theory friendly realtime performance.

Gerstner waves act as an approximate solution to the fluid dynamic equation where the model describes the ocean surface in terms of individual points where the displacement at time.

Figure 1.2 Motion of Gerstner wave from Wikipedia



The ocean will be a sum of these Gerstner waves and describe the position P on the surface as : 

P (x,y,t) = ( x+ W1(),y+ W2(), W3(),)

Where : 

W1() =  QiAiDi.x cos(wiDi(x,y) +ti)
W2() =  QiAiDi.y cos(wiDi(x,y) +ti)
W3() =  Aisin(wiDi(x,y) +ti)

With the help of the Gerstner function we can also calculate the normals of the ocean surface through the use of partial derivatives of the binormal B and the tangent T.

B=(1-  QiDi.x2WAS(),- QiDi.yDi.xWAS(), Di.xWAC())  
T=(-  QiDi.x2WAS(),1- QiDi.y2WAS(), Di.xWAC())  

The cross product of B and T gives us the normal N: 

N=(-  Di.xWAC(),- Di.yWAC(),1- QiWAs())  

Where : 
S() = sin(wiDiP +ti), 
C() = cos(wiDiP+ti) ,
WA = wiAi
The term Q is a parameter used to control the steepness of a wave and is usually described as 1 divided by WA [1]. The speed C of an wave can also be controlled by the wavelength [1,2]: 

C =g k  = g 2L

In which k is the magnitude of 2L .


Within this project, Fractal Brownian Motion will be used to add variations to both the waves and the normal maps. Fractal Brownian Motion (FBM) is a common model within computer graphics used for the purpose of creating values that tend to be similar to previous values with the random variations added [4,5,9]. In essence it is used to create variations that appear random to human perception while not being entirely random. 

Finally to add rendering details I will be adding basic Fresnel reflections.  Fresnel describes how much light is being refracted and how much is reflected. Often the following approximation is used: 

ReflectionCoefficient = Max(0,min(1,bias+scale 1+IN)power)

Where the bias, scale and power are parameters chosen by the artist. The vectors I and N are the incident vector (viewdirection vector) and normal vector respectively [6]. A simplified version of this approximation will be used instead as the many parameters can produce poor results if care is not taken. 

## Problems and limitations

Main problem and limitations lie with my lack of previous experience with shader programming in Unity. Another issue is to ensure that the performance becomes acceptable for real time applications. The primary scope limitation will be to exclude things such as buoyancy and object interactivity (for instance boats colliding with ocean waves).

# References


[1]
Mark Finch, Nvidia GPU GEMS Chapter 1 Effective water simulation from physical models. 2004. Retrieved from: https://developer.nvidia.com/gpugems/gpugems/part-i-natural-effects/chapter-1-effective-water-simulation-physical-models

[2]
Jerry Tessendorf, Simulating Ocean water.  2001 Retrieved from https://www.researchgate.net/publication/264839743_Simulating_Ocean_Water 

[3]
Morgan Westerberg Oliver Olguin Jönsson  A comparative performance analysis of Fast Fourier transformation and Gerstner waves June 2023 https://bth.diva-portal.org/smash/get/diva2:1778248/FULLTEXT02.pdf 

[4]
Information Coding / Computer Graphics, ISY, LiTH  Fractual terrains N.D. Retrieved from https://computer-graphics.se/TNM084/Files/pdf21/7b%20Fractal%20terrains.pdf 

[5]
Patricio Gonzalez Vivo, Jen Lower.  Book of shaders chapter 13 Fractual Brownian Motion Retrieved from  https://thebookofshaders.com/13/ 

[6]
Nvidia The CG tutorial ,2003. Retrieved from 
https://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter07.html 

[8]
Subsurface scattering
https://www.alanzucconi.com/2017/08/30/fast-subsurface-scattering-1/ 

[9]
Article about FBM
https://iquilezles.org/articles/fbm/ 


