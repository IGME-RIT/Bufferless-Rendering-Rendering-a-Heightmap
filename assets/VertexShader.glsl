/*
Title: Buffer Free 3
File Name: FragmentShader.glsl
Copyright © 2015
Original authors: Joshua Alway
Written under the supervision of David I. Schwartz, Ph.D., and
supported by a professional development seed grant from the B. Thomas
Golisano College of Computing & Information Sciences
(https://www.rit.edu/gccis) at the Rochester Institute of Technology.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

References:
http://terrain.party/ - For the heightmap

Description:
This program serves to demonstrate rendering without a buffer, using modulus math on just the gl_VertexID variable.
This builds upon the previous "Buffer Free 2" example, adding in a heightmap (as a .bmp texture) and displaying the data visually. 
The heightmap used is a heightmap of the area around Rochester, exported from a website called 'terrain.party'. Data is loaded 
without the use of an external library (like SOIL).
*/

#version 440 core // Identifies the version of the shader, this line must be on a separate line from the rest of the shader code

out float ScreenX;			// the X-coordinate of the vertex on the screen (important for fragment shader)
out float Height;			// the modified height that we get from the heightmap
out float OriginalValue;	// the original height that we get from the heightmap
out float WaterLevel;		// the water level

// Our uniform Model-View-Projection matrix to modify our position values
uniform mat4 MVP;			

// Our heightmap BMP texture
uniform sampler2D heightmapTexture;

void main(void)
{
    int i = gl_VertexID;					// Which square is it? We need 2 triangles, so 6 vertices per square.
    int TileIndex = i / 6;					// 0, 1, 2, 3, 4, 5, 0, 1... Which vertex is it in the square?
    int VertexInTile = i % 6;	            // 0, 0, 0, 1, 1, 1, 0, 0... Which triangle is it in the square? 
    int TriangleInTile = VertexInTile / 3;  // 0, 1, 2, 1, 2, 3, 0, 1... Indices for a square. 
                                                
    int Index = VertexInTile - (2 * TriangleInTile);
    vec2 VertexLocation = vec2(
                        Index % 2, 				// x = index % 2
                        (Index / 2) % 2 );		// z = (index / 2) % 2

    vec2 TileLocation = vec2(
                        (TileIndex % 1023),		//   = index % 1023
                        (TileIndex / 1023));	//   = index / 1023 (we don't need a mod here, since we know we are using a constant 1024*1024 tiles)

    VertexLocation += TileLocation;
    // Wow, there sure was a lot of information in that simple incremental count from 0 to 1023*1023*6.
    

    // The sample location for accessing the 2D texture: essentially a 2D 0 to 1 index of where we are sampling.
    vec2 SampleLocation = VertexLocation / 1024;

    // This value now in a range of 0 to 1, where 0 was 0 in our 8 bit texture and 1 was 255 in our 8 bit texture.
    OriginalValue = texture( heightmapTexture, SampleLocation ).r;

	// set height to the original value from the texture
	Height = OriginalValue;

	// set the sea-level
	WaterLevel = 0.125;

	// clamp lowest heights to sea-level
	if(Height < WaterLevel)
		Height = WaterLevel;

    // Shrink the whole thing down to a more manageable scale. Alternatively, this could be done with the model transformation matrix.
    VertexLocation = VertexLocation * 0.005;
  
	// location of this vertex on the screen  
    gl_Position = MVP * vec4(VertexLocation.x, Height * 2.5, VertexLocation.y, 1.0);

	// the X-coordinate of the vertex on the screen
	ScreenX = gl_Position.x;
}													 

