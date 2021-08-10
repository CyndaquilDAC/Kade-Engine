package;

import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";
	public static var currChanges:String = "dk";
	
	private var bgColors:Array<String> = [
		'#314d7f',
		'#4e7093',
		'#70526e',
		'#594465'
	];
	private var colorRotation:Int = 1;

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
	
	override function create()
	{
		super.create();

		ShaderFilters();
		if(filters != null)
			camera.setFilters(filters);
			camera.filtersEnabled = true;
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('week54prototype', 'shared'));
		bg.scale.x *= 1.55;
		bg.scale.y *= 1.55;
		bg.screenCenter();
		bg.antialiasing = FlxG.save.data.antialiasing;
		add(bg);
		
		var kadeLogo:FlxSprite = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('KadeEngineLogo'));
		kadeLogo.scale.y = 0.3;
		kadeLogo.scale.x = 0.3;
		kadeLogo.x -= kadeLogo.frameHeight;
		kadeLogo.y -= 180;
		kadeLogo.alpha = 0.8;
		kadeLogo.antialiasing = FlxG.save.data.antialiasing;
		add(kadeLogo);
		
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Your Kade Engine is outdated!\nYou are on "
			+ MainMenuState.kadeEngineVer
			+ "\nwhile the most recent version is " + needVer + "."
			+ "\n\nWhat's new:\n\n"
			+ currChanges
			+ "\n& more changes and bugfixes in the full changelog"
			+ "\n\nPress Space to view the full changelog and update\nor ESCAPE to ignore this",
			32);

		if (MainMenuState.nightly != "")
			txt.text = 
			"You are on\n"
			+ MainMenuState.kadeEngineVer
			+ "\nWhich is a PRE-RELEASE BUILD!"
			+ "\n\nReport all bugs to the author of the pre-release.\nSpace/Escape ignores this.";
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);
		
		FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
		FlxTween.angle(kadeLogo, kadeLogo.angle, -10, 2, {ease: FlxEase.quartInOut});
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
			if(colorRotation < (bgColors.length - 1)) colorRotation++;
			else colorRotation = 0;
		}, 0);
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			if(kadeLogo.angle == -10) FlxTween.angle(kadeLogo, kadeLogo.angle, 10, 2, {ease: FlxEase.quartInOut});
			else FlxTween.angle(kadeLogo, kadeLogo.angle, -10, 2, {ease: FlxEase.quartInOut});
		}, 0);
		
		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			if(kadeLogo.alpha == 0.8) FlxTween.tween(kadeLogo, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
			else FlxTween.tween(kadeLogo, {alpha: 0.8}, 0.8, {ease: FlxEase.quartInOut});
		}, 0);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT && MainMenuState.nightly == "")
		{
			fancyOpenURL("https://kadedev.github.io/Kade-Engine/changelogs/changelog-" + needVer);
		}
		else if (controls.ACCEPT)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
