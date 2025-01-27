import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.filters.ShaderFilter;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

importAddons("shader.OUTLINE");

public var frameRateGroup:Sprite;

var fps:TextField;
var fpsFormat:TextFormat;

var osText:TextField;
var osFormat:TextFormat;

var scFont:Font = Assets.getFont(Paths.font("Super Cartoon.ttf"));

var outline:OUTLINE;
var outlineOptions:Dynamic = {
	color: 0xFFA50000,
	size: 0.05,
	samples: 8
};

function new() {
	Main.framerateSprite.visible = false;
	
	frameRateGroup = new Sprite();
	
	#if mobile
	frameRateGroup.scaleX = FlxG.scaleMode.scale.x;
	frameRateGroup.scaleY = FlxG.scaleMode.scale.y;
	#end
	
	fpsFormat = new TextFormat(scFont.fontName, 24, 0xFFFFFFFF, null, null, null, null, null, TextFormatAlign.LEFT);
	osFormat = new TextFormat(scFont.fontName, 18, 0xFFFFFFFF, null, null, null, null, null, TextFormatAlign.LEFT);
	
	outline = new OUTLINE(outlineOptions.color);
	outline.size = outlineOptions.size;
	outline.samples = outlineOptions.samples;
	
	//Application.current.window.alert();
	
	initMembers();
	frameRateGroup.filters = [new ShaderFilter(outline.shader)];
	Main.instance.addChild(frameRateGroup);
	
	#if desktop
	var positionX = (FlxG.stage.stageWidth - FlxG.width * FlxG.scaleMode.scale.x) / 2;
	#elseif mobile
	var positionX = fps.width;
	#end
	
	frameRateGroup.x = positionX;
}

function update(elapsed:Float) {
	updateFPS(Lib.getTimer() - framerateKey.currentTime);
}

function destroy() {
	Main.framerateSprite.visible = true;
	
	Main.instance.removeChild(frameRateGroup);
}

var framerateKey:Dynamic = {
	currentValue: 0.0,
	currentTime: 0.0,
	cacheCount: 0,
	times: []
};
var publish:Float = 0;
function updateFPS(deltaTime:Float) {
	framerateKey.currentTime += deltaTime;
	framerateKey.times.push(framerateKey.currentTime);

	while (framerateKey.times[0] < framerateKey.currentTime - 1000) {
		framerateKey.times.shift();
	}

	var currentCount = framerateKey.times.length;
	publish = CoolUtil.fpsLerp(publish, (currentCount + framerateKey.cacheCount) / 2, 0.33);
	framerateKey.currentValue = floatToStringPrecision(FlxMath.bound(publish, 0, FlxG.drawFramerate), 1);

	if (fps.visible) {
		fps.text = "FPS: " + framerateKey.currentValue;
	}

	framerateKey.cacheCount = currentCount;
}

function initMembers() {
	fps = new TextField();
	
	fps.text = "FPS: 0.0";
	fps.defaultTextFormat = fpsFormat;
	fps.autoSize = TextFieldAutoSize.LEFT;
	
	frameRateGroup.addChild(fps);
	
	osText = new TextField();
	osText.text = "System OS: " + LimeSystem.platformName + "[" + LimeSystem.deviceVendor + "(" + LimeSystem.deviceModel + ")" + "]" + "-" + LimeSystem.platformVersion;
	osText.autoSize = TextFieldAutoSize.LEFT;
	osText.defaultTextFormat = osFormat;
	osText.y = fps.height + 5;
	
	frameRateGroup.addChild(osText);
}