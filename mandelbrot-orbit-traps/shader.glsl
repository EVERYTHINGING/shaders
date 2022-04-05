void mainImage( out vec4 fragColor, vec2 fragCoord )
{
	vec2 uv = 2.* fragCoord / iResolution.xy -1.;
    float dist = 0., t=iTime;
    uv *= vec2(2,1);

    uv *= pow(.1,0.+iMouse.x*0.01);
    uv += vec2(.275015, .0060445);
 
    vec2 z = vec2(0.);   
    int trap=0;
    
    for(int i = 0; i < 400; i++){
        float l = dot(z,z);
        if(l > 4.) { trap = i; break; }
        dist = min( 1e20,l) + cos(float(i)*12.005+3.*t);
        z = mat2(z,-z.y,z.x)*z + uv;
    }
    dist = sqrt(dist);
	float orb = sqrt(float(trap))/64.;
    
    fragColor = orb==0. ? vec4(0.)
                        : log(dist) * sqrt(vec4(0,dist,dist-abs(sin(t)),0)) + vec4(0,0,orb, 1);
}