package;

import cpp.Stdio;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import Song.SwagSong;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenManager;
import flixel.tweens.misc.ColorTween;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.*;
import haxe.*;
import lime.*;
import openfl.*;


#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{

	public static var startingSelection:Int = 0;

	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;
	var bg:FlxSprite;

	var micRating:FlxSprite;

	public static var songData:Map<String,Array<SwagSong>> = [];

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var diffCalcText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

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

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			var meta = new SongMetadata(data[0], Std.parseInt(data[2]), data[1]);
			songs.push(meta);
			var diffs = [];

			var format = meta.songName;

			FreeplayState.loadDiff(0,format,meta.songName,diffs);
			FreeplayState.loadDiff(1,format,meta.songName,diffs);
			FreeplayState.loadDiff(2,format,meta.songName,diffs);
			FreeplayState.loadDiff(3,format,meta.songName,diffs);
			FreeplayState.loadDiff(4,format,meta.songName,diffs);
			FreeplayState.songData.set(meta.songName,diffs);
			trace('loaded diffs for ' + meta.songName);
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if desktop
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 105, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		diffCalcText = new FlxText(scoreText.x, scoreText.y + 66, 0, "", 24);
		diffCalcText.font = scoreText.font;
		add(diffCalcText);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		add(scoreText);

		micRating = new FlxSprite(1130, 570);
		micRating.frames = Paths.getSparrowAtlas('Rating_Mics');
		micRating.animation.addByPrefix('okay', 'okay');
		micRating.animation.addByPrefix('null', 'null');
		micRating.animation.addByPrefix('good', 'good');
		micRating.animation.addByPrefix('shit', 'shit');
		micRating.animation.addByPrefix('bad', 'bad');
		micRating.animation.addByPrefix('sick', 'sick');
		micRating.animation.addByPrefix('fc', 'fc');
		micRating.animation.play('null');
		add(micRating);

		changeSelection(startingSelection);
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				if(micRating.angle == -4) 
					FlxTween.angle(micRating, micRating.angle, 4, 4, {ease: FlxEase.quartInOut});
				if (micRating.angle == 4) 
					FlxTween.angle(micRating, micRating.angle, -4, 4, {ease: FlxEase.quartInOut});
			}, 0);

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	function changeMicRating()
	{
		if(Highscore.getCombo(songs[curSelected].songName.toLowerCase(), curDifficulty).contains('FC'))
			{
				micRating.animation.play('fc');
			}
		else
			{
				//THIS IS TEMP, IM JUST TOO DUMB TO FIGURE OUT HOW TO CALCULATE SONG MAX SCORE AND DIVIDE IT FAIRLY AND IM TIRED AND ITS MIDNIGHT
				if(lerpScore >= 50000)
					{
						micRating.animation.play('sick');
					}
				else if(lerpScore >= 40000)
					{
						micRating.animation.play('good');
					}
				else if(lerpScore >= 30000)
					{
						micRating.animation.play('okay');
					}
				else if(lerpScore >= 20000)
					{
						micRating.animation.play('bad');
					}
				else if(lerpScore >= 10000)
					{
						micRating.animation.play('shit');
					}
			}
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "SCORE:" + lerpScore;
		comboText.text = combo + '\n';


		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			startingSelection = curSelected;
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState(false));
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 4;
		if (curDifficulty > 4)
			curDifficulty = 0;
		var songHighscore = songs[curSelected].songName;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
			case 3:
				diffText.text = "INSANE";
			case 4:
				diffText.text = "BABY";
		}
		diffCalcText.text = 'RATING: ${DiffCalc.CalculateDiff(songData.get(songs[curSelected].songName)[curDifficulty])}';

		changeMicRating();
	}

	public static function loadDiff(diff:Int, format:String, name:String, array:Array<SwagSong>)
		{
			try 
			{
				array.push(Song.loadFromJson(Highscore.formatSong(format, diff), name));
			}
			catch(ex)
			{
				// do nada
			}
		}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		iconArray[curSelected].animation.curAnim.curFrame = 0;
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		iconArray[curSelected].animation.curAnim.curFrame = 2;
		// selector.y = (70 * curSelected) + 30;

		//bg.color = weekColors[songs[curSelected].week];
		
		FlxTween.color(bg, 1, bg.color, weekColors[songs[curSelected].week]);
		var songHighscore = songs[curSelected].songName;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		#end

		diffCalcText.text = 'RATING: ${DiffCalc.CalculateDiff(songData.get(songs[curSelected].songName)[curDifficulty])}';

		changeMicRating(); 

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var hmm;
		try
		{
			hmm = songData.get(songs[curSelected].songName)[curDifficulty];
			if (hmm == null)
				return;
		}
		catch(ex)
		{
			return;
		}

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
