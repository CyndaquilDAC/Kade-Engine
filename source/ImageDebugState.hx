package;

import flixel.util.FlxColor;
import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import WiggleEffect;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

class ImageDebugState extends MusicBeatState
{
	var loadingBg:FlxSprite;
    var loadingFunkers:FlxSprite;
    var loadingLoader:FlxSprite;
    var bf:Boyfriend;
    var iconFucker:HealthIcon;
    var wiggleShit:WiggleEffect = new WiggleEffect();
	
	function new()
	{
		super();
	}
	
	override function create()
	{
        Conductor.changeBPM(102);
        wiggleShit.effectType = WiggleEffectType.FLAG;
        wiggleShit.waveAmplitude = 0.25;
        wiggleShit.waveFrequency = 25;
        wiggleShit.waveSpeed = 0.01;
        iconFucker = new HealthIcon('bf', true);
        iconFucker.setPosition(100, 202);
        iconFucker.shader = wiggleShit.shader;
        add(iconFucker);
        bf = new Boyfriend(200, 302, 'bf');
        bf.shader = wiggleShit.shader;
        add(bf);
	}
	
	override function beatHit()
	{
		super.beatHit();
        wiggleShit.update(Conductor.crochet);
        bf.dance();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
        if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
	}
}