package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import CoolUtil;
import flixel.*;
import haxe.*;
import lime.*;
import openfl.*;

#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var returnWeek:Int = 0;

	var yellowBG:FlxSprite;

	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['Bopeebo', 'Fresh', 'Dadbattle'],
		['Spookeez', 'South', 'Monster'],
		['Pico', 'Philly', 'Blammed'],
		['Satin-Panties', 'High', 'Milf'],
		['Cocoa', 'Eggnog', 'Winter-Horrorland'],
		['Senpai', 'Roses', 'Thorns'],
		['Ugh', 'Guns', 'Stress']
	];

	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true, true];

	var weekColors:Array<FlxColor> = [
		FlxColor.fromRGB(165, 0, 77),
		FlxColor.fromRGB(175, 102, 206),
		FlxColor.fromRGB(213, 126, 0),
		FlxColor.fromRGB(183, 216, 85),
		FlxColor.fromRGB(216, 85, 142),
		FlxColor.WHITE,
		FlxColor.fromRGB(255, 170, 111),
		FlxColor.fromRGB(238, 157, 6)
	];

	var weekCharacters:Array<Dynamic> = [
		['', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['spooky', 'bf', 'gf'],
		['pico', 'bf', 'gf'],
		['mom', 'bf', 'gf'],
		['parents-christmas', 'bf-christmas', 'gf-christmas'],
		['senpai', 'bf', 'gf'],
		['', 'bf', 'gf']
	];
	var weekNames:Array<String> = CoolUtil.coolTextFile(Paths.txt('weekNames'));

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		trace('rich presence updated');
		#end
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				trace('music now exists');
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 6942021", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		yellowBG = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, FlxColor.WHITE);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
				trace('week locked');
			}
		}

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false, 'dad'));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true, 'bf'));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true, 'gf'));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);
		trace('difficulty selectors added');

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);
		trace('left arrow added');

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('baby', 'BABY');
		sprDifficulty.animation.addByPrefix('insane', 'INSANE');
		sprDifficulty.animation.play('easy');
		sprDifficulty.antialiasing = true;
		changeDifficulty();
		trace('funie difficulty');

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);
		trace('right arrow added');

		add(yellowBG);
		add(grpWeekCharacters);
		trace('yellow bg and group characters now exist');

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);
		trace('text n shit');

		updateText();
		changeWeek(returnWeek);

		super.create();
	}

	override function update(elapsed:Float)
	{
		//why did i add this
		/*
		if(FlxG.keys.justPressed.SEVEN){
			if(grpWeekCharacters.members[0].publicName == 'senpai' || grpWeekCharacters.members[0].publicName == 'senpai-alt'){
				if(grpWeekCharacters.members[0].publicName == 'senpai'){
					grpWeekCharacters.members[0].setCharacter('senpai-alt');
				}
				else if(grpWeekCharacters.members[0].publicName == 'senpai-alt'){
					grpWeekCharacters.members[0].setCharacter('senpai');
				}
			}
		}
		*/
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			trace('bye bye story menu');
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				if(grpWeekCharacters.members[1].publicName == 'bf-christmas'){
					grpWeekCharacters.members[1].animation.play('bfChristmasConfirm');
				}
				else{
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				}
				if(grpWeekCharacters.members[2].publicName == 'gf-christmas'){
					grpWeekCharacters.members[2].animation.play('gfChristmasCheer');
				}
				else{
				grpWeekCharacters.members[2].animation.play('gfCheer');
				}
				stopspamming = true;
				trace('confirmation confirmed');
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;


			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
				case 3:
					diffic = '-insane';
				case 4:
					diffic = '-baby';
			}

			PlayState.storyDifficulty = curDifficulty;
			returnWeek = curWeek;
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 4;
		if (curDifficulty > 4)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
				trace('easy');
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
				trace('normal');
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
				trace('hard');
			case 3:
				sprDifficulty.animation.play('insane');
				sprDifficulty.offset.x = 70;
				trace('insane');
			case 4:
				sprDifficulty.animation.play('baby');
				sprDifficulty.offset.x = 20;
				trace('baby');
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		//yellowBG.color = weekColors[curWeek];

		FlxTween.color(yellowBG, 1, yellowBG.color, weekColors[curWeek]);

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		updateText();
	}

	override function beatHit()
	{
		super.beatHit();
		grpWeekCharacters.members[0].dance();
		grpWeekCharacters.members[1].dance();
		grpWeekCharacters.members[2].dance();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		txtTracklist.text = "Tracks\n\n";
		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
		{
			txtTracklist.text += i + "\n";
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
