package;

import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class GameOverState extends FlxTransitionableState
{
	var bfX:Float = 0;
	var bfY:Float = 0;

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
		super();

		bfX = x;
		bfY = y;
	}

	override function create()
	{

		ShaderFilters();
		if(filters != null)
			camera.setFilters(filters);
			camera.filtersEnabled = true;

		var loser:FlxSprite = new FlxSprite(100, 100);
		var loseTex = Paths.getSparrowAtlas('lose');
		loser.frames = loseTex;
		loser.animation.addByPrefix('lose', 'lose', 24, false);
		loser.animation.play('lose');
		loser.antialiasing = FlxG.save.data.antialiasing;
		add(loser);

		var bf:Boyfriend = new Boyfriend(bfX, bfY);
		// bf.scrollFactor.set();
		add(bf);
		bf.playAnim('firstDeath');

		FlxG.camera.follow(bf, LOCKON, 0.001);
		
		var restart:FlxSprite = new FlxSprite(500, 50).loadGraphic(Paths.image('restart'));
		restart.setGraphicSize(Std.int(restart.width * 0.6));
		restart.updateHitbox();
		restart.alpha = 0;
		restart.antialiasing = FlxG.save.data.antialiasing;
		add(restart);

		FlxG.sound.music.fadeOut(2, FlxG.sound.music.volume * 0.6);

		FlxTween.tween(restart, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(restart, {y: restart.y + 40}, 7, {ease: FlxEase.quartInOut, type: PINGPONG});

		super.create();
	}

	private var fading:Bool = false;

	override function update(elapsed:Float)
	{
		var pressed:Bool = FlxG.keys.justPressed.ANY;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if(FlxG.save.data.InstantRespawn)
		{
			fading = true;
			FlxG.sound.music.fadeOut(0.5, 0, function(twn:FlxTween)
			{
				FlxG.sound.music.stop();
				LoadingState.loadAndSwitchState(new PlayState());
			});
		}

		if (gamepad != null)
		{
			if (gamepad.justPressed.ANY)
				pressed = true;
		}

		pressed = false;

		if (pressed && !fading)
		{
			fading = true;
			FlxG.sound.music.fadeOut(0.5, 0, function(twn:FlxTween)
			{
				FlxG.sound.music.stop();
				LoadingState.loadAndSwitchState(new PlayState());
			});
		}
		super.update(elapsed);
	}
}
