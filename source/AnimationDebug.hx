package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.*;
import haxe.*;
import lime.*;
import openfl.*;
import CoolUtil;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.addons.*;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end

using StringTools;

class AnimationDebug extends MusicBeatState
{
	var bf:Boyfriend;
	var bfUnderlay:Boyfriend;
	var dad:Character;
	var dadUnderlay:Character;
	var char:Character;
	var charUnderlay:Character;
	var textAnim:FlxText;
	var textUnderlayAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var curAnimUnderlay:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'dad';
	var camFollow:FlxObject;
	var enemy:Bool = true;
	var animToUnderlay:String = 'idle';

	public function new(daAnim:String = 'dad', enemy:Bool = true)
	{
		super();
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		this.daAnim = daAnim;
		this.enemy = enemy;
	}

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Animation Debug Menu", null);
		#end
		FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.music('freakyMenu'), 1);

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		if (!enemy)
			isDad = false;

		if (isDad)
		{
			dadUnderlay = new Character(100, 100, daAnim);
			dadUnderlay.screenCenter();
			dadUnderlay.debugMode = true;
			add(dadUnderlay);
			charUnderlay = dadUnderlay;
			dadUnderlay.flipX = false;
			dadUnderlay.color = FlxColor.BLACK;
			dadUnderlay.alpha = 0.5;
			
			dad = new Character(100, 100, daAnim);
			dad.screenCenter();
			dad.debugMode = true;
			add(dad);
			char = dad;
			dad.flipX = false;
		}
		else
		{
			bfUnderlay = new Boyfriend(770, 450, daAnim);
			bfUnderlay.screenCenter();
			bfUnderlay.debugMode = true;
			add(bfUnderlay);
			charUnderlay = bfUnderlay;
			bfUnderlay.flipX = false;
			bfUnderlay.color = FlxColor.BLACK;
			bfUnderlay.alpha = 0.5;

			bf = new Boyfriend(770, 450, daAnim);
			bf.screenCenter();
			bf.debugMode = true;
			add(bf);
			char = bf;
			bf.flipX = false;
		}

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.color = FlxColor.BLACK;
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);
		textUnderlayAnim = new FlxText(300, 46);
		textUnderlayAnim.color = FlxColor.BLACK;
		textUnderlayAnim.size = 26;
		textUnderlayAnim.scrollFactor.set();
		add(textUnderlayAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLACK;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;
		textUnderlayAnim.text = animToUnderlay;

		if (FlxG.keys.pressed.E)
			FlxG.camera.zoom += 0.025;
		if (FlxG.keys.pressed.Q)
			FlxG.camera.zoom -= 0.025;

		if(FlxG.keys.justPressed.MINUS)
			curAnimUnderlay--;
			animToUnderlay = animList[curAnimUnderlay].toLowerCase();
		if(FlxG.keys.justPressed.PLUS)
			curAnimUnderlay++;
			animToUnderlay = animList[curAnimUnderlay].toLowerCase();

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);
			charUnderlay.playAnim(animToUnderlay);

			updateTexts();
			genBoyOffsets(false);
		}

		var upP = FlxG.keys.anyPressed([UP]);
		var rightP = FlxG.keys.anyPressed([RIGHT]);
		var downP = FlxG.keys.anyPressed([DOWN]);
		var leftP = FlxG.keys.anyPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP)
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
				charUnderlay.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
				charUnderlay.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
				charUnderlay.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;
				charUnderlay.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
			charUnderlay.playAnim(animToUnderlay);
		}

		if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
			}

		super.update(elapsed);
	}
}
