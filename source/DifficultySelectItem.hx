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

class DifficultySelectItem extends FlxSpriteGroup
{
	public function new(x:Float, y:Float, difficultyItself:Bool = false, isRight:Bool = false)
	{
		super(x, y);
		frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		if(!difficultyItself)
			{
				if(isRight)
					{
						animation.addByPrefix('idle', 'arrow right');
						animation.addByPrefix('press', "arrow push right", 24, false);
						animation.play('idle');
					}
				else
					{
						animation.addByPrefix('idle', "arrow left");
						animation.addByPrefix('press', "arrow push left");
						animation.play('idle');
					}
			}
		else
			{
				animation.addByPrefix('easy', 'EASY');
				animation.addByPrefix('normal', 'NORMAL');
				animation.addByPrefix('hard', 'HARD');
				animation.addByPrefix('baby', 'BABY');
				animation.addByPrefix('insane', 'INSANE');
				animation.play('easy');
			}
		antialiasing = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
