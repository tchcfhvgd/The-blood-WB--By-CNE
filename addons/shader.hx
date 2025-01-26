import openfl.Assets;

/**
 * 这里不得不列举@橘子整的转场必备shader
 */
class Trans extends FlxBasic {
	public var shaderCode:String;
	public var shader:FunkinShader;
	
	public var apply:Float;
	
	public function new() {
		shader = new FunkinShader(this.shaderCode);
		
		apply = 0.;
		shader.apply = apply;
	}
	
	public function set_apply(val:Float):Float {
		apply = val;
		
		shader.apply = apply;
		return apply;
	}
	
	public function get_shaderCode():String {
		return "
// TRANSITION CODE BY NE_EO

#pragma header

uniform float apply;

void main()
{
	vec2 uv = openfl_TextureCoordv.xy;
	vec2 fragCoord = uv * openfl_TextureSize.xy;
	vec4 col = texture2D(bitmap, uv);

	vec2 uvf = fragCoord/openfl_TextureSize.xx;

	float dd = distance(uvf, vec2(0.5, openfl_TextureSize.y/openfl_TextureSize.x*0.5))*1.6666;

	if(dd > 1.0-apply)
		col.rgba = vec4(0.0, 0.0, 0.0, 1.0);

	gl_FragColor = col;
}
		";
	}
}

/**
 * 老电视花瓶
 */
class OldTv extends FlxBasic {
	public var shaderCode:String;
	public var shader:FunkinShader;
	
	public var iTime:Float;
	public var alphaNoise:Float;
	public var blueOpac:Float;
	public var redOpac:Float;
	public var noiseTex:BitmapData;
	public var glitchModifier:Float;
	
	/**
	 * 实例化，dddd
	 * @param texPath 给一个噪点的路径图片
	 */
	public function new(texPath:String) {
		shader = new FunkinShader(this.shaderCode);
		
		iTime = 0.;
		alphaNoise = 1;
		blueOpac = 0;
		redOpac = 0.;
		glitchModifier = 0;
		
		if(Assets.exists(texPath))
			noiseTex = Assets.getBitmapData(texPath);
		
		shader.iTime = iTime;
		shader.alphaNoise = alphaNoise;
		shader.blueOpac = blueOpac;
		shader.redOpac = redOpac;
		shader.glitchModifier = glitchModifier;
		
		shader.noiseTex = noiseTex;
	}
	
	public override function update(elapsed:Float) {
		super.update(elapsed);
	
		this.iTime += elapsed;
	}
	
	public function set_iTime(val:Float):Float {
		iTime = val;
		
		shader.iTime = iTime;
		return iTime;
	}
	
	public function set_alphaNoise(val:Float):Float {
		alphaNoise = val;
		
		shader.alphaNoise = alphaNoise;
		return alphaNoise;
	}
	
	public function set_blueOpac(val:Float):Float {
		blueOpac = val;
		
		shader.blueOpac = blueOpac;
		return blueOpac;
	}
	
	public function set_redOpac(val:Float):Float {
		redOpac = val;
		
		shader.redOpac = redOpac;
		return redOpac;
	}
	
	public function set_glitchModifier(val:Float):Float {
		glitchModifier = val;
		
		shader.glitchModifier = glitchModifier;
		return glitchModifier;
	}
	
	public function get_shaderCode():String {
		return "
	 #pragma header

    uniform float iTime;
    uniform float alphaNoise;
    uniform float blueOpac;
    uniform float redOpac;
    uniform sampler2D noiseTex;
    uniform float glitchModifier;

    float onOff(float a, float b, float c)
    {
    	return step(c, sin(iTime + a*cos(iTime*b)));
    }

    float ramp(float y, float start, float end)
    {
    	float inside = step(start,y) - step(end,y);
    	float fact = (y-start)/(end-start)*inside;
    	return (1.-fact) * inside;

    }

    vec4 getVideo(vec2 uv)
      {
      	vec2 look = uv;
        	float window = 1./(1.+20.*(look.y-mod(iTime/4.,1.))*(look.y-mod(iTime/4.,15.)));
        	look.x = look.x + (sin(look.y*10. + iTime)/540.*onOff(4.,4.,.3)*(1.+cos(iTime*80.))*window)*(glitchModifier*2.);
        	float vShift = 0.4*onOff(2.,3.,.9)*(sin(iTime)*sin(iTime*20.) +
        										 (1.0 + 0.1*sin(iTime*200.)*cos(iTime)));
        	look.y = mod(look.y + vShift*glitchModifier, 1.);
      	vec4 video = flixel_texture2D(bitmap,look);

      	return video;
      }

    vec2 screenDistort(vec2 uv)
    {
        uv = (uv - 0.5) * 2.0;
      	uv *= 1.1;
      	uv.x *= 1.0 + pow((abs(uv.y) / 4.5), 2.0);
      	uv.y *= 1.0 + pow((abs(uv.x) / 3.5), 2.0);
      	uv  = (uv / 2.0) + 0.5;
      	uv =  uv *0.92 + 0.04;
      	return uv;
    	return uv;
    }
    float random(vec2 uv)
    {
     	return fract(sin(dot(uv, vec2(15.5151, 42.2561))) * 12341.14122 * sin(iTime * 0.03));
    }
    float filmGrainNoise(in float time, in vec2 uv)
    {
    return fract(sin(dot(uv, vec2(12.9898, 78.233) * time)) * 43758.5453);
    }
    float noise(vec2 uv)
    {
     	vec2 i = floor(uv);
        vec2 f = fract(uv);

        float a = random(i);
        float b = random(i + vec2(1.,0.));
    	float c = random(i + vec2(0., 1.));
        float d = random(i + vec2(1.));

        vec2 u = smoothstep(0., 1., f);

        return mix(a,b, u.x) + (c - a) * u.y * (1. - u.x) + (d - b) * u.x * u.y;

    }


    vec2 scandistort(vec2 uv) {
    	float scan1 = clamp(cos(uv.y * 3.0 + iTime), 4.0, 1.0);
    	float scan2 = clamp(cos(uv.y * 6.0 + iTime + 4.0) * 10.0,0.0, 1.0) ;
    	float amount = scan1 * scan2 * uv.x;

    	uv.x -= 0.015 * mix(flixel_texture2D(noiseTex, vec2(uv.x, amount)).r * amount, amount, 0.2);

    	return uv;

    }
    void main()
    {
    	vec2 uv = openfl_TextureCoordv;
      vec2 curUV = screenDistort(uv);
    	uv = scandistort(curUV);
    	vec4 video = getVideo(uv);
      float vigAmt = 1.0;
      float x = 0.0;
      float grainFactor = filmGrainNoise(iTime, uv);


      video.r = getVideo(vec2(x+uv.x+0.001,uv.y+1.0)).x + abs(sin(0.12 * redOpac)); // used for sirokous fire part
      video.g = getVideo(vec2(x+uv.x-0.001,uv.y+1.0)).y + abs(sin(0.06 * blueOpac));
      video.b = getVideo(vec2(x+uv.x-0.001,uv.y+1.0)).z + abs(sin(0.06 * blueOpac));
    	vigAmt = 2.+.1*sin(iTime + 5.*cos(iTime*5.));

    	float vignette = (1.1-vigAmt*(uv.y-.5)*(uv.y-.5))*(0.1-vigAmt*(uv.x-.5)*(uv.x-.5));

      gl_FragColor = mix(video,vec4(noise(uv * 75.)),.05);

      if(curUV.x<0. || curUV.x>1. || curUV.y<0. || curUV.y>1.){
        gl_FragColor = vec4(0.0,0.0,0.0,0.0);
      }

    }
		";
	}
}