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
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class NoteSplash extends FlxSprite
{
	public function new(?fromNote:Int = 0, x:Float, y:Float)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas('noteStyles/noteSplashes');

		animation.addByPrefix('note0-0', 'note impact 1 purple', 24, false);
		animation.addByPrefix('note0-1', 'note impact 2 purple', 24, false);
		animation.addByPrefix('note1-0', 'note impact 1 blue', 24, false);
		animation.addByPrefix('note1-1', 'note impact 2 blue', 24, false);
		animation.addByPrefix('note2-0', 'note impact 1 green', 24, false);
		animation.addByPrefix('note2-1', 'note impact 2 green', 24, false);
		animation.addByPrefix('note3-0', 'note impact 1 red', 24, false);
		animation.addByPrefix('note3-1', 'note impact 2 red', 24, false);

		setupNoteSplash(fromNote, x, y);
	}

	public function setupNoteSplash(?fromNote:Int = 0, x:Float, y:Float)
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