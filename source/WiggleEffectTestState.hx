package;

import lime.app.Promise;
import lime.app.Future;

import flixel.*;
import haxe.*;
import lime.*;
import openfl.*;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

import WiggleEffect;

import flixel.addons.ui.*;

/**
 * debugger for wiggle effect, gonna be used for modding support
 */
class WiggleEffectTestState extends MusicBeatState
{

	
	function new()
	{
		super();
	}
	
	override function create()
	{
        Conductor.changeBPM(102);
	}
	
	override function beatHit()
	{
		super.beatHit();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
        if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
	}
}