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

layout(location = 0) out vec4 out_color; // Establishes the variable we will pass out of this shader.

in vec4 color;	// Take in a vec4 for color
 
void main(void)
{
	out_color = color; // Set our out_color equal to our in color, basically making this a pass-through shader.
}