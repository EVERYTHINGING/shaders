// Created by inigo quilez - iq/2013
// https://www.youtube.com/c/InigoQuilez
// https://iquilezles.org

// Instead of using a pont, circle, line or any mathematical shape for traping the orbit
// of fc(z), one can use any arbitrary shape. For example, a NyanCat :)
//
// I invented this technique more than 10 years ago (can have a look to those experiments 
// here http://www.iquilezles.org/www/articles/ftrapsbitmap/ftrapsbitmap.htm).


//Initialize shiva shader in browser console with:
//gShaderToy.SetTexture(0, {mSrc:'https://i.ibb.co/gg9bNYZ/dancing-shiva-nataraja.png', mType:'texture', mID:1, mSampler:{ filter: 'mipmap', wrap: 'repeat', vflip:'true', srgb:'false', internal:'byte' }});

vec4 getShivaColor( vec2 p, float time )
{
	p = clamp(p,0.0,1.0);
	//p.x = p.x*40.0/1024.0;
	//p.y = 0.5 + 1.2*(0.5-p.y);
	p = clamp(p,0.0,1.0);
	float fr = floor( mod( 20.0*time, 6.0 ) );
	//p.x += fr*40.0/256.0;
	return texture( iChannel0, p );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (2.0*fragCoord-iResolution.xy)/iResolution.y;
    
    float time = max( iTime-5.5, 0.0 );
    float rotation = time;
    
    // zoom	
	p = vec2(0.5,-0.05)  + p*0.75 * pow( 0.5, 1.0*(0.5+0.5*(iMouse.x*.05)) );
	
    vec4 col = vec4(0.0);
	vec3 s = mix( vec3( 0.2,0.2, 1.0 ), vec3( 0.5,-0.2,0.5), 0.5+0.5*sin(0.5*rotation) );

    // iterate Jc	
	vec2 c = vec2(-0.76, 0.15);
	float f = 0.0;
	vec2 z = p;
	for( int i=0; i<100; i++ )
	{
		if( (dot(z,z)>4.0) || (col.w>0.1) ) break;

        // fc(z) = z² + c		
		z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
		
		col = getShivaColor( s.xy + s.z*z, time );
		f += 1.0;
	}
	
	vec3 bg = 0.5*vec3(1.0,0.5,0.5) * sqrt(f/100.0);
	
	col.xyz = mix( bg, col.xyz, col.w );
    
    col *= step( 2.0, iTime );
    col += texture( iChannel1, vec2(0.01,0.2) ).x * (1.0-step( 5.5, iTime ));
	
	fragColor = vec4( col.xyz,1.0);
}