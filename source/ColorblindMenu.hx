package;

import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class ColorblindMenu extends MusicBeatSubstate
{
	public var blackBox:FlxSprite;
	public var gfDance:FlxSprite;
	public var dumbshit:Alphabet;
	public var typeOfFilter:Alphabet;
	public var filterTypes:Array<String> = ['none', 'deuteranopia', 'protanopia', 'tritanopia'];
	public var curSelected:Int = 0;
	var danceLeft:Bool = false;

	public function new()
	{
		super();
		var detmatrix:Array<Float> = [
			0.43, 0.72, -.15, 0, 0,
			0.34, 0.57, 0.09, 0, 0,
			-.02, 0.03,    1, 0, 0,
			0,    0,    0, 1, 0,
		];
		filtersdeuteranopia.push(new ColorMatrixFilter(detmatrix));
		var protanopiamatrix:Array<Float> = [
					0.20, 0.99, -.19, 0, 0,
					0.16, 0.79, 0.04, 0, 0,
					0.01, -.01,    1, 0, 0,
					   0,    0,    0, 1, 0,
				];
		filtersprotanopia.push(new ColorMatrixFilter(protanopiamatrix));
		var matrixtri:Array<Float> = [
					0.20, 0.99, -.19, 0, 0,
					0.16, 0.79, 0.04, 0, 0,
					0.01, -.01,    1, 0, 0,
					0,    0,    0, 1, 0,
				];
		filterstritanopia.push(new ColorMatrixFilter(matrixtri));

		blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);
		blackBox.alpha = 0;
		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = FlxG.save.data.antialiasing;
		gfDance.screenCenter();
		add(gfDance);
		gfDance.alpha = 0;
		dumbshit = new Alphabet(0, gfDance.getGraphicMidpoint().y - gfDance.height / 2, "Pick a colorblind filter!", true);
		typeOfFilter = new Alphabet(0, gfDance.getGraphicMidpoint().y + gfDance.height / 2, FlxG.save.data.colorblindMode, true);
		dumbshit.alpha = 0;
		typeOfFilter.alpha = 0;
		add(dumbshit);
		add(typeOfFilter);
		FlxTween.tween(blackBox, {alpha: 0.7}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(gfDance, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(dumbshit, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(typeOfFilter, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if(FlxG.keys.justPressed.ESCAPE)
		{
			quit();
		}
		if(controls.LEFT)
		{
			if(curSelected == 0)
				curSelected = filterTypes.length - 1;
			else
				curSelected--;
			refreshGfFilter();
		}
		if(controls.RIGHT)
		{
			if(curSelected == filterTypes.length - 1)
				curSelected = 0;
			else
				curSelected++;
			refreshGfFilter();
		}
	}

	public function refreshGfFilter() 
	{
		typeOfFilter.text = filterTypes[curSelected];
		switch(curSelected)
		{
			case 0:
				camera.filtersEnabled = false;
			case 1:
				camera.setFilters(filtersdeuteranopia);
				camera.filtersEnabled = true;
			case 2:
				camera.setFilters(filtersprotanopia);
				camera.filtersEnabled = true;
			case 3:
				camera.setFilters(filterstritanopia);
				camera.filtersEnabled = true;
		}
	}

	function quit()
	{
		FlxG.save.data.colorblindMode = filterTypes[curSelected];

        OptionsMenu.instance.acceptInput = true;

		FlxTween.tween(gfDance, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(dumbshit, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(typeOfFilter, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0}, 1.1, {ease: FlxEase.expoInOut, onComplete: function(flx:FlxTween){close();}});
    }

	override function beatHit()
	{
		super.beatHit();

		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');
	}

	public var filtersprotanopia:Array<BitmapFilter> = [];
	public var filtersdeuteranopia:Array<BitmapFilter> = [];
	public var filterstritanopia:Array<BitmapFilter> = [];
}
