# DH2323_Ocean_simulation
This repository is my project in the DH2323 Computer graphics and interaction where I built a real-time ocean simulation using Unity and ShaderLab. 

### Gifs:
https://drive.google.com/drive/folders/1-MqZckLOp_0Jk_ZN-JXunHnT5De_w2CV?usp=sharing 

### Images:
https://drive.google.com/drive/folders/1cqdHrjCrZFVvTwD3yQzKgNpxNpjPpkjS?usp=sharing



Below is one of the final images which became better than I expected: 

![image](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/7b9e140a-d471-4ab1-8ff0-055a5cc8e0c5)

![baseshader](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/a866e1c5-1462-42e2-9287-94dc035b5b06)

![baseshader2](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/bd2c2eb1-010c-4418-8cdd-84a445341246)


![Maxsmoothness](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/60d1fbcc-661b-46e5-8893-95673fcf9579)

![withoutsmoothness](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/35da26fa-2a11-4e02-be61-1abc62011676)


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

Fractal Brownian Motion is the process of creating values that tend to similar to previous values but still appear random to us. It is essential created through multiple layers of Perlin noise and is a common application within procedural generation. In short it is used to create random values without being completely random. I higly recommend to read this chapter from The Book of Shaders: https://thebookofshaders.com/13/ as it explains the concept quite well. Below is the Current version of my ocean shader. 



![image](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/e76ef8c2-6af6-4208-984b-8343d90bef11)

While certainly better than earlier attempts I felt dissatisfied with the current lighting and and lack of subsurface scattering. My focus will be to implement these features. The overall appearance of the ocean is largely based on the amount of waves that are being added in combination with normal maps.


I also saw alot of experimentation with C++ and unity, however due to having to many issues with this I decided to change my approach again. This time making use of Unity built in shader language in combination. 
So far I have managed to generate a ocean tile and animate it according to the sum of sines principle which was outlined by GPU gems: https://developer.nvidia.com/gpugems/gpugems/part-i-natural-effects/chapter-1-effective-water-simulation-physical-models. The code to generate the ocean was done via C#, however the movement and the shading was done via unity shaders since it is more performance friendly. Thus the focus will be more the gerstner wave animations using the sum of sines method rather than implementing an FFT algorithm. 

I realized that i probably overcomplicated and I will likely do the FFT variation as a future project. I did alot more research and found so many variations of the ocean simulation Gerstner waves, eulerwaves, and of course sum of sines princinple, which was quite overwhelming to be honest. Thus I decided to start simple and build the project up in complexity. 

Below are some fun results using sinewaves with K exponent: 
![Sumofsinewave](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/a986816a-5ee6-4830-8f14-d0ba4b43e9ae)

An example of Gerstner wave going very wrong! 
![Gerstner wave_fun](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/7e91df3c-7e34-4dba-8e6c-05d6ce9e30a9)

I avoided at first Gerstner waves as they had an easier tendence to clip through each other. Instead I simply raised the sinusoid term to an exponent K as a starting point. 

![image](https://github.com/AKSB-GP/DH2323_Ocean_simulation/assets/35559511/6e187b51-a329-4a90-ae71-cfbf06162adf)


Image From GPU Gems chapter 1.


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


