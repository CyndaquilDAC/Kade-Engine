package;

import haxe.macro.Expr.Case;
import flixel.addons.transition.Transition;
import flixel.addons.transition.FlxTransitionSprite;
import flixel.addons.transition.TransitionTiles;
import flixel.math.FlxRandom;
import cpp.Random;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.addons.*;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
import flixel.*;
import haxe.*;
import lime.*;
import openfl.*;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var funnyRun:Bool = false;

	//im goin fuckin mad with these fx
	/*
	var transRandomTypeOne:Int = 0;
	var transRandomTypeTwo:Int = 0;
	var transRandomIntroShape:Int = 0;
	var transRandomOutroShape:Int = 0;
	var transTypeOneFinal:TransitionType;
	var transTypeTwoFinal:TransitionType;
	var transGraphicIntro:FlxGraphic;
	var transGraphicOutro:FlxGraphic;

	var beatsTillLogoBumpTypeSwitch:Int = 15;
	var logoBumpType:Int = 0;
	*/

	var curWacky:Array<String> = [];
	var curWackyTwo:Array<String> = [];
	var curWackyThree:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		
		PlayerSettings.init();

		#if desktop
		DiscordClient.initialize();

		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		 
		#end

		curWacky = FlxG.random.getObject(getIntroTextShit());
		curWackyTwo = FlxG.random.getObject(getIntroTextShit());
		curWackyThree = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT
		#if debug
		flixel.addons.studio.FlxStudio.create();
		#end
		super.create();

		FlxG.save.bind('foreverfunkin', 'cyndaquildac');
		//save system??? never...
		/*
		if(FlxG.save.data.saveThatsBeenPicked == null)
			{
				FlxG.save.data.saveThatsBeenPicked = 0;
			}
		*/
		SaveData.initSave();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		if (Date.now().getDay() == 5)
			{
				//FlxG.save.data.unlockedLoadingFunkerSkin = true;
			}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end
	}

	var logoBl:FlxSprite;
	var logoUnder:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('titleBg'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		logoUnder = new FlxSprite(-150, -100);
		logoUnder.frames = Paths.getSparrowAtlas('logoBumpin');
		logoUnder.antialiasing = true;
		logoUnder.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoUnder.animation.play('bump');
		logoUnder.updateHitbox();
		logoUnder.color = FlxColor.BLACK;
		logoUnder.visible = false;

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		add(logoUnder);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		#if switch
		titleText.frames = Paths.getSparrowAtlas('titleStart');
		#else
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		#end

		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		//this bitch said OLD LOGO
		/*
		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		add(logo);
		*/

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8r", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
		{
			//god forgive me for this code
			/*
			transRandomIntroShape = FlxG.random.int(0, 2);
			transRandomOutroShape = FlxG.random.int(0, 2);
			transRandomTypeOne = FlxG.random.int(0, 1);
			transRandomTypeTwo = FlxG.random.int(0, 1);
			switch(transRandomIntroShape)
			{
				case 0:
					{
						transGraphicIntro = FlxGraphic.fromClass(GraphicTransTileDiamond);
					}
				case 1:
					{
						transGraphicIntro = FlxGraphic.fromClass(GraphicTransTileCircle);
					}
				case 2:
					{
						transGraphicIntro = FlxGraphic.fromClass(GraphicTransTileSquare);
					}
			}
			switch(transRandomOutroShape)
			{
				case 0:
					{
						transGraphicOutro = FlxGraphic.fromClass(GraphicTransTileDiamond);
					}
				case 1:
					{
						transGraphicOutro = FlxGraphic.fromClass(GraphicTransTileCircle);
					}
				case 2:
					{
						transGraphicOutro = FlxGraphic.fromClass(GraphicTransTileSquare);
					}
			}
			switch(transRandomTypeOne)
			{
				case 0:
					{
						transTypeOneFinal = FADE;
					}
				case 1:
					{
						transTypeOneFinal = TILES;
					}
			}
			switch(transRandomTypeTwo)
			{
				case 0:
					{
						transTypeTwoFinal = FADE;
					}
				case 1:
					{
						transTypeTwoFinal = TILES;
					}
			}
			*/
			
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(TILES, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(0, 0, Lib.application.window.width, Lib.application.window.height));
			FlxTransitionableState.defaultTransOut = new TransitionData(TILES, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(0, 0, Lib.application.window.width, Lib.application.window.height));

			FlxTransitionableState.defaultTransIn.tileData = {asset: diamond, width: 32, height: 32};
			FlxTransitionableState.defaultTransOut.tileData = {asset: diamond, width: 32, height: 32};

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
			Conductor.changeBPM(102);
			initialized = true;
		}
			
		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
	
			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{

				// Get current version of Funkin' Forever

				var http = new haxe.Http("https://raw.githubusercontent.com/KadeDev/Kade-Engine/master/version.downloadMe");

				http.onData = function (data:String) {
				  
				  	if (!MainMenuState.funkinForeverVer.contains(data.trim()) && !OutdatedSubState.leftState && MainMenuState.nightly == "")
					{
						trace('outdated lmao! ' + data.trim() + ' != ' + MainMenuState.funkinForeverVer);
						OutdatedSubState.needVer = data;
						//switch to main menu state cuz fuck that bitch ass outdatedsubstate
						FlxG.switchState(new MainMenuState());
					}
					else
					{
						FlxG.switchState(new MainMenuState());
					}
				}
				
				http.onError = function (error) {
				  trace('error: $error');
				  FlxG.switchState(new MainMenuState()); // fail but we go anyway
				}
				
				http.request();

			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.finish();
		logoBl.animation.play('bump');
		logoUnder.animation.finish();
		logoUnder.animation.play('bump');
		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				createCoolText(['ninjamuffin99', 'PhantomArcade', 'kawaisprite', 'evilsk8r', 'CyndaquilDAC']);
			// credTextShit.visible = true;
			case 3:
				addMoreText('present...');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				createCoolText(["Funkin' Forever", 'created by']);
			case 6:
				addMoreText('CyndaquilDAC');
			// credTextShit.text += '\nNewgrounds';
			case 7:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case  8:
				createCoolText(["Based on Kade Engine", 'created by']);
			case 9:
				addMoreText('KadeDeveloper');
			case 10:
				deleteCoolText();
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 12:
				addMoreText(curWacky[1]);
				if(curWacky[1] == 'you deadass built like a')
					{
						PlayState.SONG = Song.loadFromJson(Highscore.formatSong('ugh-easter-egg', 2));
						PlayState.storyDifficulty = 2;
						PlayState.storyWeek = 7;
						LoadingState.loadAndSwitchState(new PlayState(true));
					}
			// credTextShit.text += '\nlmao';
			case 14:
				deleteCoolText();
				createCoolText([curWackyTwo[0]]);
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 16:
				addMoreText(curWackyTwo[1]);
				if(curWackyTwo[1] == 'you deadass built like a')
					{
						PlayState.SONG = Song.loadFromJson(Highscore.formatSong('ugh-easter-egg', 2));
						PlayState.storyDifficulty = 2;
						PlayState.storyWeek = 7;
						LoadingState.loadAndSwitchState(new PlayState(true));
					}
			case 18:
				deleteCoolText();
				createCoolText([curWackyThree[0]]);
			case 20:
				addMoreText(curWackyThree[1]);
				if(curWackyThree[1] == 'you deadass built like a')
					{
						PlayState.SONG = Song.loadFromJson(Highscore.formatSong('ugh-easter-egg', 2));
						PlayState.storyDifficulty = 2;
						PlayState.storyWeek = 7;
						LoadingState.loadAndSwitchState(new PlayState(true));
					}
			case 22:
				deleteCoolText();
				addMoreText("Friday Night Funkin':");
			// credTextShit.visible = true;
			case 23:
				addMoreText("Funkin'");
			// credTextShit.text += '\nNight';
			case 24:
				addMoreText('Forever'); // credTextShit.text += '\nFunkin';
			case 25:
				addMoreText('Version 0.1.0');
			case 26:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			FlxTween.tween(logoBl,{y: -100}, 1.4, {ease: FlxEase.expoInOut});
			FlxTween.tween(logoUnder,{y: -100}, 1.4, {ease: FlxEase.expoInOut, startDelay: 0.1});
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
				{
					if(logoBl.angle == -4) 
						FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
					if (logoBl.angle == 4) 
						FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
					if(logoUnder.angle == -4)
						{
							FlxTween.angle(logoUnder, logoUnder.angle, 4, 4, {ease: FlxEase.quartInOut, startDelay: 0.1});
						}
					if(logoUnder.angle == 4)
						{
							FlxTween.angle(logoUnder, logoUnder.angle, -4, 4, {ease: FlxEase.quartInOut, startDelay: 0.1});
						}
				}, 0);
			skippedIntro = true;
		}
	}
}
