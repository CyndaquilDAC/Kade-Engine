//i hate how messy the shit i did to this code is and i hope i never have to look at it again.

package;

import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import PlayState;
import Song;
import flixel.*;
import haxe.*;
import lime.*;
import openfl.*;


using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var dialogEnded:Bool = false;
	var curCharacter:String = '';
	var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD??? WHY NINJAMUFFIN WHY??? I MEAN I GET FOR THE PIXEL FONT BUT YOU OBLITERATED THE OLD CODE!!!
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'roses':
				//sex is real this is official
			case 'blammed':
				FlxG.sound.playMusic(Paths.music('blammedDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'south':
				FlxG.sound.playMusic(Paths.music('southDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'bopeebo' | 'drug-pop-bopeebo' | 'drug pop bopeebo':
				FlxG.sound.playMusic(Paths.music('bopeeboDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'dadbattle' | 'dad battle':
				FlxG.sound.playMusic(Paths.music('dadbattleDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'fresh':
				FlxG.sound.playMusic(Paths.music('freshDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'high':
				FlxG.sound.playMusic(Paths.music('highDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'milf':
				FlxG.sound.playMusic(Paths.music('milfDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'pico':
				FlxG.sound.playMusic(Paths.music('picoDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'satin-panties' | 'satin panties':
				FlxG.sound.playMusic(Paths.music('satin-pantiesDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'spookeez':
				FlxG.sound.playMusic(Paths.music('spookeezDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'ugh' | 'guns':
				FlxG.sound.playMusic(Paths.music('DISTORTO'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'stress':
				FlxG.sound.playMusic(Paths.music('KlaskiiRomper'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			default:
				FlxG.sound.playMusic(Paths.music('breakfast'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);

		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);
		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				new FlxTimer().start(0.83, function(tmr:FlxTimer)
					{
						bgFade.alpha += (1 / 5) * 0.7;
						if (bgFade.alpha > 0.7)
							bgFade.alpha = 0.7;
					}, 5);
			default:
				bgFade.color = FlxColor.WHITE;
				FlxTween.tween(bgFade, {alpha: 0.7}, 0.83);
		}
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				box = new FlxSprite(-20, 45);
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				box.antialiasing = false;
			case 'roses':
				box = new FlxSprite(-20, 45);
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				box = new FlxSprite(-20, 45);
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

			default:
				box = new FlxSprite(40);
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ui/speech_bubbles','shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				box.antialiasing = true;
				box.y = FlxG.height * 0.5;

		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(-20, 40);
		switch(PlayState.SONG.player2){
			case 'senpai' | 'senpai-angry' | 'spirit' | 'spirit-flash':
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.antialiasing = true;
				portraitLeft.antialiasing = false;
				portraitLeft.visible = false;
			case 'gf':
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/GFPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
			case 'gf-christmas':
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/GFChristmasPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
			case 'spooky':
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/SpookyPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
			case 'parents-christmas':
				switch (PlayState.SONG.song.toLowerCase()){
					case 'cocoa':
						portraitLeft.frames = Paths.getSparrowAtlas('portraits/ParentsChristmasPortrait','shared');
					case 'eggnog':
						portraitLeft.frames = Paths.getSparrowAtlas('portraits/ParentsChristmasAltPortrait','shared');
					default:
						portraitLeft.frames = Paths.getSparrowAtlas('portraits/ParentsChristmasNeitherSpecificPortrait','shared');
				}
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
			case 'pico':
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/PicoPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
			case 'monster-christmas':
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/MONSTERChristmasPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
			case 'monster':
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/MonsterPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
			case 'mom' | 'mom-car':
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/momportrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
			default:
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/DadPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
		}
		portraitRight = new FlxSprite(0, 40);
		switch(PlayState.SONG.player1){
			case 'bf-pixel':
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.antialiasing = true;
				portraitRight.antialiasing = false;
				portraitRight.visible = false;
				//rightDialogueSound = FlxG.sound.load(Paths.sound('bfPixelDialogue'));
			case 'bf-christmas':
				portraitRight.frames = Paths.getSparrowAtlas('portraits/BFChristmasPortrait','shared');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.antialiasing = true;
				portraitRight.visible = false;
				//rightDialogueSound = FlxG.sound.load(Paths.sound('bfDialogue'));
			default:
				portraitRight.frames = Paths.getSparrowAtlas('portraits/BFREGPORTRAIT','shared');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.antialiasing = true;
				portraitRight.visible = false;
				//rightDialogueSound = FlxG.sound.load(Paths.sound('bfDialogue'));
		}
		box.animation.play('normalOpen');
		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.updateHitbox();
			default:
				//fuck you
		}
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(1042, 590);
		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				handSelect.frames = Paths.getSparrowAtlas('weeb/pixelUI/Textbox_Hand_Animated');
				handSelect.animation.addByPrefix('hand', 'hand', 24, true);
				handSelect.animation.play('hand');
				handSelect.setGraphicSize(Std.int(handSelect.width * 6 * 0.9));
				handSelect.updateHitbox();
			default:
				handSelect.frames = Paths.getSparrowAtlas('ui/Textbox_Arrow_Animated');
				handSelect.animation.addByPrefix('hand', 'hand', 24, true);
				handSelect.animation.play('hand');
		}
		handSelect.visible = false;
		add(handSelect);

		face.setGraphicSize(Std.int(face.width * 6));
		add(face);
		face.visible = false;


		if (!talkingRight)
		{
			switch(PlayState.SONG.song.toLowerCase())
			{
				case 'senpai' | 'roses' | 'thorns':
					//fuck
				default:
					box.flipX = true;
			}
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		switch(PlayState.SONG.song.toLowerCase()){
			case 'senpai' | 'roses' | 'thorns':
				dropText.font = 'Pixel Arial 11 Bold';
				dropText.color = 0xFFD89494;
			default:
				/*
				dropText.font = Paths.font("vcr.ttf");
				dropText.color = FlxColor.GRAY;
				*/
		}
		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				add(dropText);
			default:
				//youre either a smart fella or a fart smella
		}

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		switch(PlayState.SONG.song.toLowerCase()){
			case 'senpai' | 'roses' | 'thorns':
				swagDialogue.font = 'Pixel Arial 11 Bold';
				swagDialogue.color = 0xFF3F2021;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
			default:
				/*
				swagDialogue.font = Paths.font("vcr.ttf");
				swagDialogue.color = FlxColor.BLACK;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('FunkinText'), 0.6)];
				*/
		}
		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				add(swagDialogue);
			default:
				//o3iutuidf
		}

		dialogue = new Alphabet(0, 80, "", false, true);
		dialogue.y = 80 + FlxG.height * 0.5;
		// dialogue.x = 90;
		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				//egiyfgsresg3rehtegdvc
			default:
				add(dialogue);
		}
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() != 'roses')
						FlxG.sound.music.fadeOut(2.2, 0);
					
					switch(PlayState.SONG.song.toLowerCase())
					{
						case 'senpai' | 'roses' | 'thorns':
							new FlxTimer().start(0.2, function(tmr:FlxTimer)
								{
									box.alpha -= 1 / 5;
									bgFade.alpha -= 1 / 5 * 0.7;
									portraitLeft.alpha -= 1 / 5;
									portraitRight.alpha -= 1 / 5;
									face.alpha -= 1 / 5;
									swagDialogue.alpha -= 1 / 5;
									dropText.alpha = swagDialogue.alpha;
									dialogue.alpha -= 1 / 5;
									handSelect.alpha -= 1/5;
								}, 5);
						default:
							FlxTween.tween(box, {alpha: 0}, 1.2);
							FlxTween.tween(bgFade, {alpha: 0}, 1.2);
							FlxTween.tween(portraitLeft, {alpha: 0}, 1.2);
							FlxTween.tween(portraitRight, {alpha: 0}, 1.2);
							FlxTween.tween(swagDialogue, {alpha: 0}, 1.2);
							FlxTween.tween(dropText, {alpha: 0}, 1.2);
							FlxTween.tween(dialogue, {alpha: 0}, 1.2);
							FlxTween.tween(handSelect, {alpha: 0}, 1.2);
							FlxTween.tween(face, {alpha: 0}, 1.2);
					}

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				{
					// swagDialogue.text = ;
					swagDialogue.resetText(dialogueList[0]);
					swagDialogue.start(0.04, true);
					swagDialogue.completeCallback = function() {
						trace("dialogue finish");
						handSelect.visible = true;
						dialogEnded = true;
					}
					handSelect.visible = false;
					dialogEnded = false;
				}
			default:
				{
					var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
					theDialog.y = 70 + FlxG.height * 0.5;
					dialogue = theDialog;
					add(theDialog);
					dialogue.completeCallback = function() {
						trace("dialogue finish");
						handSelect.visible = true;
						dialogEnded = true;
					}
					handSelect.visible = false;
					dialogEnded = false;
				}
		}

		switch (curCharacter)
		{
			case 'dad':
				face.visible = false;
				portraitRight.visible = false;
				portraitLeft.animation.remove('enter');
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/DadPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
				switch(PlayState.SONG.song.toLowerCase())
				{
					case 'senpai' | 'roses' | 'thorns':
						//do nothing cuz the thing to do doesnt exist
					default:
						dialogue.personTalking = 'DAD';
				}
			case 'senpai':
					portraitRight.visible = false;
					portraitLeft.animation.remove('enter');
					portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
					portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
					portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set();
					portraitLeft.antialiasing = true;
					portraitLeft.antialiasing = false;
					portraitLeft.visible = false;
					switch(PlayState.SONG.player2)
					{
						case 'spirit' | 'spirit-flash':
							face.visible = true;
					}
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
			case 'mom':
				face.visible = false;
				portraitRight.visible = false;
				portraitLeft.animation.remove('enter');
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/momportrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
				switch(PlayState.SONG.song.toLowerCase())
				{
					case 'senpai' | 'roses' | 'thorns':
						//do nothing cuz the thing to do doesnt exist
					default:
						dialogue.personTalking = 'MOM';
				}
			case 'gf':
				face.visible = false;
				portraitRight.visible = false;
				portraitLeft.animation.remove('enter');
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/GFPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
			case 'gfchristmas':
				face.visible = false;
				portraitRight.visible = false;
				portraitLeft.animation.remove('enter');
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/GFChristmasPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
			case 'monster':
				face.visible = false;
				portraitRight.visible = false;
				portraitLeft.animation.remove('enter');
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/MonsterPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
				switch(PlayState.SONG.song.toLowerCase())
				{
					case 'senpai' | 'roses' | 'thorns':
						//do nothing cuz the thing to do doesnt exist
					default:
						dialogue.personTalking = 'MONSTER';
				}
			case 'monsterchristmas':
				face.visible = false;
				portraitRight.visible = false;
				portraitLeft.animation.remove('enter');
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/MONSTERChristmasPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
				switch(PlayState.SONG.song.toLowerCase())
				{
					case 'senpai' | 'roses' | 'thorns':
						//do nothing cuz the thing to do doesnt exist
					default:
						dialogue.personTalking = 'MONSTER';
				}
			case 'dadchristmas':
				face.visible = false;
				portraitRight.visible = false;
				portraitLeft.animation.remove('enter');
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/ParentsChristmasPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
				switch(PlayState.SONG.song.toLowerCase())
				{
					case 'senpai' | 'roses' | 'thorns':
						//do nothing cuz the thing to do doesnt exist
					default:
						dialogue.personTalking = 'DAD';
				}
			case 'momchristmas':
				face.visible = false;
				portraitRight.visible = false;
				portraitLeft.animation.remove('enter');
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/ParentsChristmasAltPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
				switch(PlayState.SONG.song.toLowerCase())
				{
					case 'senpai' | 'roses' | 'thorns':
						//do nothing cuz the thing to do doesnt exist
					default:
						dialogue.personTalking = 'MOM';
				}
			case 'parentschristmas':
				face.visible = false;
				portraitRight.visible = false;
				portraitLeft.animation.remove('enter');
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/ParentsChristmasNeitherSpecificPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
			case 'pico':
				face.visible = false;
				portraitRight.visible = false;
				portraitLeft.animation.remove('enter');
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/PicoPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
				switch(PlayState.SONG.song.toLowerCase())
				{
					case 'senpai' | 'roses' | 'thorns':
						//do nothing cuz the thing to do doesnt exist
					default:
						dialogue.personTalking = 'PICO';
				}
			case 'spooky':
				face.visible = false;
				portraitRight.visible = false;
				portraitLeft.animation.remove('enter');
				portraitLeft.frames = Paths.getSparrowAtlas('portraits/SpookyPortrait','shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.antialiasing = true;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
				switch(PlayState.SONG.song.toLowerCase())
				{
					case 'senpai' | 'roses' | 'thorns':
						//do nothing cuz the thing to do doesnt exist
					default:
						dialogue.personTalking = 'SPOOKY';
				}
			case 'bf':
				face.visible = false;
				portraitLeft.visible = false;
				portraitRight.animation.remove('enter');
				portraitRight.frames = Paths.getSparrowAtlas('portraits/BFREGPORTRAIT','shared');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				portraitRight.antialiasing = true;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
				switch(PlayState.SONG.song.toLowerCase())
				{
					case 'senpai' | 'roses' | 'thorns':
						//do nothing cuz the thing to do doesnt exist
					default:
						dialogue.personTalking = 'BF';
				}
			case 'bfchristmas':
				face.visible = false;
				portraitLeft.visible = false;
				portraitRight.animation.remove('enter');
				portraitRight.frames = Paths.getSparrowAtlas('portraits/BFChristmasPortrait','shared');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				portraitRight.antialiasing = true;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
				switch(PlayState.SONG.song.toLowerCase())
				{
					case 'senpai' | 'roses' | 'thorns':
						//do nothing cuz the thing to do doesnt exist
					default:
						dialogue.personTalking = 'BF';
				}
			case 'bfpixel':
				face.visible = false;
				portraitLeft.visible = false;
				portraitRight.animation.remove('enter');
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				portraitRight.antialiasing = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
