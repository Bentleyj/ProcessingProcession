#version 120

uniform sampler2DRect u_Tex;
uniform float u_Brightness;
uniform float u_Contrast;
uniform vec2 u_CamResolution;
uniform vec2 u_WindowResolution;
uniform vec2 u_ScreenResolution;
uniform vec2 u_Offset;
varying vec2 texCoord;

void main() {
    vec2 p = texCoord;
    //p /= u_WindowResolution;
    //p -= u_Offset;
    //p /= u_CamResolution;
    //p.x = 1.0 - p.x;
    //p.x += u_Offset.x;
    //p *= u_CamResolution;
    float xDiff = u_WindowResolution.x - u_CamResolution.x;
    float yDiff = u_WindowResolution.y - u_CamResolution.y;
    
    if (xDiff < yDiff) {
        p *= u_CamResolution.y / (u_WindowResolution.y);
    } else {
        p *= u_CamResolution.x / (u_WindowResolution.x);
    }
    vec4 col = texture2DRect(u_Tex, p);
    
    vec3 BW = vec3((col.r + col.g + col.b)/3.0f);
    
    BW *= u_Contrast;
    
    BW += vec3(u_Brightness);
    
    gl_FragColor = vec4(BW, 1.0);
}
