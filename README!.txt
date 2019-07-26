Documentation Author: Niko Procopi 2019

This tutorial was designed for Visual Studio 2017 / 2019
If the solution does not compile, retarget the solution
to a different version of the Windows SDK. If you do not
have any version of the Windows SDK, it can be installed
from the Visual Studio Installer Tool

Welcome to the Heightmap Tutorial!
Prerequesites: Rendering without buffers (in the "other" section)

This heightmap is a real heightmap of
the area that surrounds the main RIT campus
On line 245 of main.cpp, uncomment a few lines
to see where RIT is on the map.

In the previous tutorial, we rendered geometry without vertex or
index buffers. We called glDrawArrays, and the Vertex Shader
was able to generate 6 vertices, to draw 2 trianlges, as one 
square, by using glVertexID.

[VertexShader.glsl]
Rather than multiplying projection, view, and world (AKA model)
matrices in the vertex shader, we will multiply them on the CPU,
and then pass the finished matrix to the shader (called MVP).
We also pass the heightmap texture to the vertex shader as uniform
sampler2D heightmapTexture.

First, we calculate VertexLocation (line 55) to generate one square.
2D Vertices: (0, 0), (0, 1), (1, 0), (1, 1)

Next, we move all of those vertices to a tile in our terrain grid.
We have 1024x1024 pixels in our heightmap, so we make a grid of
1023x1023 quads.

TileLocation determines which quad in the heightmap we want to use.
X = 0 - 1023, Y = 0 - 1023 (line 59)

We add the TileLocation to the VertexLocation, so that all
the vertices are where they should be (line 63).

Now that these vertices are where they are, we need to get the
height of the vertices, this is where heghtmap comes in.
We need UV coordinates (0 - 1) to get a height from the heightmap,
so we divide our vertex location (0-1024) by 1024 to get the UV
	vec2 SampleLocation = VertexLocation / 1024;
	
We get a height from the heightmap, we call this the OriginalValue
because we might be changing the value later (line 71)
This value will be sent to the fragment shader later
	OriginalValue = texture( heightmapTexture, SampleLocation ).r;
	
We set Height to the original value
	Height = OriginalValue;
	
We set what value our sea-level is at. Sea-level should be at 
0.125, but if you want to flood the world, add to this value.
	WaterLevel = 0.125;
	
All water is flat, and all water is at the same elevation,
so if our height drops below sea-level, lets set height to sea-level,
so that we can draw perfectly flat blue water. Height and WaterLevel
both get sent to the fragment shader later.
	if(Height < WaterLevel)
		Height = WaterLevel;
		
When we draw the world geometry, if we try to draw a grid that 
is 1024 units large, the world will be huge, so lets scale it down
	VertexLocation = VertexLocation * 0.005;
	
Finally, we set the gl_Position, the official position of each
vertex in the frame. We scale height up a little bit, and we
multiply the position by MVP to transition from world-space to
screen space
	gl_Position = MVP * 
		vec4(VertexLocation.x, Height * 2.5, VertexLocation.y, 1.0);
		
After that, we get the X position of the vertex, which will be sent
to the fragment shader. We will use this to chop the screen in half.
	ScreenX = gl_Position.x;
	
[FragmentShader.glsl]
First we have to import the floats that we exported from the 
vertex shader:
	in float ScreenX;
	in float Height;
	in float OriginalValue;
	in float WaterLevel;
	
The farthest-left pixel on the screen will have an X value of -1
The farthest-right pixel on the screen will have an X value of 1

If we are on the left side of the screen ( if ScreenX < 0 )
Make the color of the pixel equal to the original height
	color = vec4(vec3(OriginalValue), 1.0);
This will give us the height of the surface, regardless
if it is over the water or under the water

If we are on the right side of the screen (else)
Check to see if our modified height is equal to the 
sea level ( if height is waterlevel). If it is,
make the color blue.

If height is not equal to sea level, then it must be greater.
In that case, give a mixture of ShoreColor and GrassColor,
where larger heights have more grass color and lower heights
have more shore color. We use mix(), a GLSL command, to interpolate
between the two values

Finally, we output the color to the screen
	out_color = color; 