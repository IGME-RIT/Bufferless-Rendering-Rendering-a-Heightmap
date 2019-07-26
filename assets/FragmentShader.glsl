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

in float ScreenX;
in float Height;
in float OriginalValue;
in float WaterLevel;
 
void main(void)
{
	// color of the pixel, set to black by default
	vec4 color = vec4(0);

    // If on the left side of the screen, draw with a red color based on the value we pulled from the texture.
    if( ScreenX < 0.0 )
    {
		// make it yellow, because I think it looks nice
        color = vec4(vec3(OriginalValue), 1.0);
    }

	// If on the right side of the screen, add a bit of interesting effects to it.
    else            
    {   
        if( Height == WaterLevel )
        {
            // Give our water a nice blue.
            color = vec4(0.3, 0.5, 0.9, 1.0);
        }

        else
        {
            vec4 ShoreColor = vec4(0.2, 0.23, 0.22, 1.0);
            vec4 GrassColor = vec4(0.05, 0.4, 0.1, 1.0);

            // Figure out how grassy this area should be for a smooth transition. This will lerp from 1.05 * water height (full rocky) to 1.1 (full grassy).
            float GrassinessFactor = clamp((Height-WaterLevel * 1.05) * 20.0, 0.0, 1.0);

			// interpolate between the colors, as height increases
            color = mix(ShoreColor, GrassColor, GrassinessFactor);
        }
    }

    // And there you have it: a heightmap of Rochester
	// if you uncomment lines at 245 in main.cpp,
	// you'll see a spire in the terrain denoting the position of RIT. (if only the rivers had less of a slope to them and showed up in their entirety)

	// Set our out_color equal to our in color, basically making this a pass-through shader.
	out_color = color; 
}