package;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	var bg:FlxSprite;

	public var filters:Array<BitmapFilter> = [];

    function ShaderFilters():Void
	{
        for(filter in filters)
        {
            filters.remove(filter);
        }
		//Matrix shaders:
		if (FlxG.save.data.colorblindMode == 'deuteranopia')
		{
			var matrix:Array<Float> = [
						0.43, 0.72, -.15, 0, 0,
						0.34, 0.57, 0.09, 0, 0,
						-.02, 0.03,    1, 0, 0,
						   0,    0,    0, 1, 0,
					];
			filters.push(new ColorMatrixFilter(matrix));
		}
		if (FlxG.save.data.colorblindMode == 'protanopia')
		{
			var matrix:Array<Float> = [
						0.20, 0.99, -.19, 0, 0,
						0.16, 0.79, 0.04, 0, 0,
						0.01, -.01,    1, 0, 0,
						   0,    0,    0, 1, 0,
					];
			filters.push(new ColorMatrixFilter(matrix));
		}
		if (FlxG.save.data.colorblindMode == 'tritanopia')
		{
			var matrix:Array<Float> = [
						0.20, 0.99, -.19, 0, 0,
						0.16, 0.79, 0.04, 0, 0,
						0.01, -.01,    1, 0, 0,
						   0,    0,    0, 1, 0,
					];
			filters.push(new ColorMatrixFilter(matrix));
		}
	}

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (PlayState.SONG.player1)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			default:
				daBf = 'bf';
		}

		super();

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');

		ShaderFilters();
		if(filters != null)
			camera.setFilters(filters);
			camera.filtersEnabled = true;
	}

	var startVibin:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if(FlxG.save.data.InstantRespawn)
		{
			LoadingState.loadAndSwitchState(new PlayState());
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
			FlxTween.tween(bg, {alpha: 1}, 1);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
			startVibin = true;
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (startVibin && !isEnding)
		{
			bf.playAnim('deathLoop', true);
		}
		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			PlayState.startTime = 0;
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
