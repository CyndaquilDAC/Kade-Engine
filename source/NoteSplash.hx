package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import flixel.*;
import haxe.*;
import lime.*;
import openfl.*;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

/**
 * note splash particles for sicks!!!
 * detoria wrote the original version of this code (i think. i might be dumb.)
 * cyndaquildac did some fixins hehe.
 * so yeah.
 */
class NoteSplash extends FlxSprite
{
	public function new(?fromNote:String = 'green', x:Float, y:Float, ?frameSuffix:String = '')
	{
        if(frameSuffix.contains('pixel'))
        {
            setGraphicSize(Std.int(width * 6));
            updateHitbox();
        }

		super(x, y);

		frames = Paths.getSparrowAtlas('hud/notes/splashes' + frameSuffix);

		animation.addByPrefix('notepurple-0', 'note impact 1 purple', 24, false);
		animation.addByPrefix('notepurple-1', 'note impact 2 purple', 24, false);
		animation.addByPrefix('noteblue-0', 'note impact 1 blue', 24, false);
		animation.addByPrefix('noteblue-1', 'note impact 2 blue', 24, false);
		animation.addByPrefix('notegreen-0', 'note impact 1 green', 24, false);
		animation.addByPrefix('notegreen-1', 'note impact 2 green', 24, false);
		animation.addByPrefix('notered-0', 'note impact 1 red', 24, false);
		animation.addByPrefix('notered-1', 'note impact 2 red', 24, false);

		setupNoteSplash(fromNote, x, y);
	}

	public function setupNoteSplash(?fromNote:String = 'green', x:Float, y:Float)
	{
		this.x = x;
		this.y = y;

        visible = true;

		alpha = 1;

		animation.play("note" + fromNote + "-" + FlxG.random.int(0, 1), true);
		//animation.curAnim.frameRate += Random.int(-2, 2);
		updateHitbox();

		offset.x += 90;
		offset.y += 80;

		//trace('note splash called');
	}

	override function update(elapsed:Float)
    {
        super.update(elapsed);
            if(animation.curAnim.finished)
                {
                    visible = false;
                    kill();
                }
    }
} 