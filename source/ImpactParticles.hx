package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.*;
import haxe.*;
import lime.*;
import openfl.*;

/**
 *	impact particles for stuff
 */
class ImpactParticles extends FlxSpriteGroup
{
	public function new(x:Float, y:Float, right:Bool = false, blue:Bool = false)
	{
		super(x, y);
		frames = Paths.getSparrowAtlas('particleShit/Effects_Assets');
		if(blue)
			animation.addByPrefix('impact', 'impact particles blue', 24, false, right);
		else
			animation.addByPrefix('impact', 'impact particles', 24, false, right);
		antialiasing = true;
	}
}
