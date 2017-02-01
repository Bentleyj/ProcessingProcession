#version 120

uniform vec2 u_Resolution;
uniform sampler2DRect u_Tex;
uniform float u_Offset;
uniform float u_Contrast;
uniform float u_Brightness;


void main()
{
    vec2 p = gl_FragCoord.xy / u_Resolution;
    p.y = 1.0 - p.y;
    p.x = 1.0 - p.x;

    vec4 col = texture2DRect(u_Tex, vec2((p.x * u_Resolution.x) + u_Offset, (p.y) * u_Resolution.y));
    vec3 BW = vec3((col.x + col.y + col.z)/3.0f);
    
    BW *= u_Contrast;
    
    BW += vec3(u_Brightness);
    
    gl_FragColor = vec4(vec3(BW), 1);
}
