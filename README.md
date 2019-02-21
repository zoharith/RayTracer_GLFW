# RayTracer_GLFW
Ray casting/tracing engine

Ray Tracing with OpenGL written with c++, project's solution is compiled with Visual Studio 2017.

I implemeneted a ray casting/tracing engine. A ray tracer shoots rays from the observer’s eye through a screen and into a scene of objects. It calculates the ray’s intersection with objects, finds the nearest intersection and calculates the color of the surface according to its material and lighting conditions.

The screen is located on z=0 plane. The right up corner of the screen is located at (1,1,0) and the left bottom corner of the screen is located at (-1,-1,0). All in the scene coordinates.

The Primitive objects in the scene:

Sphere

A sphere is defined by a center point and scalar radius. The normal of each point on the sphere’s surface is easily computed as the normalized subtraction of the point and the center.

Plane

A plane is defined by a normal to the plane and a negative scalar which represents the "d" in the plane equation (𝑎𝑥 + 𝑏𝑦 + 𝑐𝑧 + 𝑑 = 0). Every plane is an infinite plane and will be divided to squares in checkers board pattern. In the dark square the diffuse component of Phong model has 0.5 coefficient.

Lighting-lighting implementation contains:

Ambient lighting – a color that reflects from all surfaces with equal intensity.

Directional – A light source like the sun, which lies at infinity and has just a direction.

Spot light – A point light source that illuminates in a direction given by a vector 𝐷. This light source has a cutoff angle as describe in the following image. Every light source has its own intensity (color) and there can be multiple light sources in a scene. Shadows appear where objects obscure a light source. In the equation they are expressed in the 𝑆𝑖 term. To know if a point 𝑝 in space (usually on a surface) lies in a shadow of a light source, you need to shoot a ray from 𝑝 in the direction of the light and check if it hits something. If it does, make sure that it really hits it before reaching the light source and that the object hit is not actually a close intersection with the object the ray emanated from.

In addition, changing the forth coordinate of the eye (camera) vector will reveal a reflection ray tracing with recursion level 1.

Different scenes can be found at rayTraserGLFW\res as text files.

Files in question are parsed by the parser and drawn by the GPU.
