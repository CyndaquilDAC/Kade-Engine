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
import Paths;

class WeekLockItem extends FlxSpriteGroup
{
	public function new(x:Float)
	{
		super(x, y);
		frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		animation.addByPrefix('lock', 'lock');
		animation.play('lock');
		antialiasing = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
