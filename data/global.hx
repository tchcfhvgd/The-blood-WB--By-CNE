import Array;

import funkin.backend.system.MainState;
import funkin.backend.MusicBeatTransition;
import funkin.backend.MusicBeatState;
import funkin.backend.system.framerate.Framerate;

import hxvlc.flixel.FlxVideo;

import openfl.Lib;

public var globalGameTimer:Float = 0.;

var playVideo:Bool = false;

var onceTime:Bool = true;
var playBool:Bool = false;

var kaichangVideo:FlxVideo;

function new() {
	MusicBeatTransition.script = "data/scripts/transition";
}

function postGameStart() {
	if(playVideo) {
		FlxG.switchState(new MusicBeatState());
		//breakOriginFramerate();
	
		kaichangVideo = new FlxVideo();
		kaichangVideo.autoVolumeHandle = false;
		kaichangVideo.onEndReached.add(function() {
			kaichangVideo.dispose();
			playBool = false;
			FlxG.game.removeChild(kaichangVideo);
			FlxG.switchState(new TitleState());
		});
		FlxG.game.addChild(kaichangVideo);
	}
}

//不是哥们，故意不给我使用FlxTimer是吧？
function update(elapsed:Float) {
	globalGameTimer += elapsed * 1000;
	
	if(playVideo) {
		if(globalGameTimer >= 1000 && onceTime) {
			startKaichangVideo();
		
			onceTime = false;
		}
	
		if(playBool) {
			var startTransform:Float = 0.1;
			var endTransform:Float = 0.85;
		
			var percent:Float = kaichangVideo.time / kaichangVideo.length;
			if(percent < startTransform) {
				kaichangVideo.alpha += (elapsed / (1 - startTransform));
				kaichangVideo.volume += Std.int((elapsed / (1 - startTransform)) * 100);
			}else if(percent > endTransform) {
				kaichangVideo.alpha -= (elapsed / endTransform);
				kaichangVideo.volume -= Std.int((elapsed / endTransform) * 100);
			}
		}
	}
}

function startKaichangVideo() {
	if(kaichangVideo.load(Paths.video("kaichangbai"))) {
		playBool = kaichangVideo.play();
		kaichangVideo.volume = 0;
		kaichangVideo.alpha = 0;
	}else {
		FlxG.switchState(new TitleState());
		FlxG.game.removeChild(kaichangVideo);
	}
}

@:noCompletion
function breakOriginFramerate():Void {
	for(child in [Framerate.instance.fpsCounter, Framerate.instance.memoryCounter, Framerate.instance.codenameBuildField, Framerate.instance.bgSprite, Framerate.instance.categories]) {
		if(child is Array) {
			for(man in child) {
				Framerate.instance.removeChild(man);
			}
			continue;
		}
		
		Framerate.instance.removeChild(child);
	}
}
