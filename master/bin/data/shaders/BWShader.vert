#version 120
#extension GL_ARB_texture_rectangle : enable
#extension GL_EXT_gpu_shader4 : enable

varying vec2 texCoord;
uniform vec2 u_Offset;
uniform vec2 u_WindowResolution;

void main() {
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    gl_TexCoord[0] = gl_MultiTexCoord0;
    gl_FrontColor = gl_Color;
    vec2 baseCoord = gl_Vertex.xy;
    //baseCoord /= u_WindowResolution;
    //baseCoord.x = 1.0 - baseCoord.x;
    //baseCoord *= u_WindowResolution;
    
    baseCoord -= u_Offset;
    baseCoord *= vec2(-1.0, 1.0);
    baseCoord.x += u_WindowResolution.x;
    texCoord = baseCoord;
}
