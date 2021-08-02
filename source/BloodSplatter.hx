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
 * blood n shit lol!
 */
class BloodSplatter extends FlxSpriteGroup
{
	public function new(x:Float, y:Float, right:Bool = false)
	{
		super(x, y);
		frames = Paths.getSparrowAtlas('particleShit/Effects_Assets');
		if(FlxG.save.data.naughty)
		{
			animation.addByPrefix('splat', 'blood 1', 24, false, right);
			animation.addByPrefix('carsplat', 'blood car', 24, false, right);
		}
		else
		{
			animation.addByPrefix('splat', 'blood 1 CENSOR', 24, false, right);
			animation.addByPrefix('carsplat', 'blood car CENSOR', 24, false, right);
		}
		antialiasing = true;
	}
}
