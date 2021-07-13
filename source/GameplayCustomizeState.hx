import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.FlxObject;
#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end

import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.ui.Keyboard;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.*;
import haxe.*;
import lime.*;
import openfl.*;


class GameplayCustomizeState extends MusicBeatState
{

    var defaultX:Float = FlxG.width * 0.55 - 135;
    var defaultY:Float = FlxG.height / 2 - 50;

    var sick:FlxSprite = new FlxSprite().loadGraphic(Paths.image('sick','shared'));

    var bf:Boyfriend = new Boyfriend(770, 450, 'bf');
    var dad:Character;
    var gf:Character;

    var strumLine:FlxSprite;
    var strumLineNotes:FlxTypedGroup<FlxSprite>;
    var playerStrums:FlxTypedGroup<FlxSprite>;
    private var camHUD:FlxCamera;
    
    public override function create() {
        #if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Customizing Gameplay Modules", null);
		#end

		Conductor.changeBPM(102);
		persistentUpdate = true;

        super.create();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
        FlxG.cameras.add(camHUD);

        var bg:FlxSprite = new FlxSprite(-600, -200);
        bg.frames = Paths.getSparrowAtlas('test/testBackground');
        bg.animation.addByPrefix('back', 'stageBack', 24, true);
        bg.animation.play('back');
        bg.scrollFactor.set(0.9, 0.9);
        bg.active = false;
        add(bg);
        trace('back added');

        var stageFront:FlxSprite = new FlxSprite(-650, 600);
        stageFront.frames = Paths.getSparrowAtlas('test/testBackground');
        stageFront.animation.addByPrefix('front', 'stageFront', 24, true);
        stageFront.animation.play('front');
        stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
        stageFront.updateHitbox();
        stageFront.antialiasing = true;
        stageFront.scrollFactor.set(0.9, 0.9);
        stageFront.active = false;
        add(stageFront);
        trace('front added');

        var stageLightLeft:FlxSprite = new FlxSprite(-25, -75);
        stageLightLeft.frames = Paths.getSparrowAtlas('test/testBackground');
        stageLightLeft.animation.addByPrefix('light', 'stageLight', 24, true);
        stageLightLeft.animation.play('light');
        stageLightLeft.scrollFactor.set(1.25, 1.25);
        stageLightLeft.antialiasing = true;
        add(stageLightLeft);
        trace('left light added');

        var stageLightRight:FlxSprite = new FlxSprite(1570, -75);
        stageLightRight.frames = Paths.getSparrowAtlas('test/testBackground');
        stageLightRight.animation.addByPrefix('light', 'stageLight', 24, true);
        stageLightRight.animation.play('light');
        stageLightRight.flipX = true;
        stageLightRight.scrollFactor.set(1.25, 1.25);
        stageLightRight.antialiasing = true;
        add(stageLightRight);
        trace('right light added');

        var stageCurtains:FlxSprite = new FlxSprite(-500, -300);
        stageCurtains.frames = Paths.getSparrowAtlas('test/testBackground');
        stageCurtains.animation.addByPrefix('curtains', 'stageCurtains', 24, true);
        stageCurtains.animation.play('curtains');
        stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
        stageCurtains.updateHitbox();
        stageCurtains.scrollFactor.set(1.3, 1.3);
        stageCurtains.active = false;
        stageCurtains.antialiasing = true;
        add(stageCurtains);
        trace('curtains added');

		var camFollow = new FlxObject(0, 0, 1, 1);

		dad = new Character(100, 100, 'dad');
        gf = new Character(400, 130, 'gf');
        gf.scrollFactor.set(0.95, 0.95);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x + 400, dad.getGraphicMidpoint().y);

		camFollow.setPosition(camPos.x, camPos.y);

        add(gf);
        add(bf);
        add(dad);

        add(sick);

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = 0.9;
		FlxG.camera.focusOn(camFollow.getPosition());

		strumLine = new FlxSprite(0, 25).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

        sick.cameras = [camHUD];
        strumLine.cameras = [camHUD];
        playerStrums.cameras = [camHUD];
        
		generateStaticArrows(0);
		generateStaticArrows(1);

        
        if (!FlxG.save.data.changedHit)
        {
            FlxG.save.data.changedHitX = defaultX;
            FlxG.save.data.changedHitY = defaultY;
        }

        sick.x = FlxG.save.data.changedHitX;
        sick.y = FlxG.save.data.changedHitY;

        sick.updateHitbox();

        FlxG.mouse.visible = true;

    }

    override function update(elapsed:Float) {
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        super.update(elapsed);

        FlxG.camera.zoom = FlxMath.lerp(0.9, FlxG.camera.zoom, 0.95);
        camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);

        if (FlxG.mouse.overlaps(sick) && FlxG.mouse.pressed)
        {
            sick.x = FlxG.mouse.x - sick.width / 2;
            sick.y = FlxG.mouse.y - sick.height / 2;
        }

        if (FlxG.mouse.overlaps(sick) && FlxG.mouse.justReleased)
        {
            FlxG.save.data.changedHitX = sick.x;
            FlxG.save.data.changedHitY = sick.y;
            FlxG.save.data.changedHit = true;
        }

        if (controls.BACK)
        {
            FlxG.mouse.visible = false;
            FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new OptionsMenu());
        }

    }

    override function beatHit() 
    {
        super.beatHit();

        bf.playAnim('idle');
        dad.dance();
        gf.dance();

        FlxG.camera.zoom += 0.015;
        camHUD.zoom += 0.010;

        trace('beat');

    }


    // ripped from play state cuz im lazy
    
	private function generateStaticArrows(player:Int):Void
        {
            for (i in 0...4)
            {
                // FlxG.log.add(i);
                var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
                babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets', 'shared');
                babyArrow.animation.addByPrefix('green', 'arrowUP');
                babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
                babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
                babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
                babyArrow.antialiasing = true;
                babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
                switch (Math.abs(i))
                {
                    case 0:
                        babyArrow.x += Note.swagWidth * 0;
                        babyArrow.animation.addByPrefix('static', 'arrowLEFT');
                        babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
                    case 1:
                        babyArrow.x += Note.swagWidth * 1;
                        babyArrow.animation.addByPrefix('static', 'arrowDOWN');
                        babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
                    case 2:
                        babyArrow.x += Note.swagWidth * 2;
                        babyArrow.animation.addByPrefix('static', 'arrowUP');
                        babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
                    case 3:
                        babyArrow.x += Note.swagWidth * 3;
                        babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
                        babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
                }
                babyArrow.updateHitbox();
                babyArrow.scrollFactor.set();
    
                babyArrow.ID = i;
    
                if (player == 1)
                {
                    playerStrums.add(babyArrow);
                }
    
                babyArrow.animation.play('static');
                babyArrow.x += 50;
                babyArrow.x += ((FlxG.width / 2) * player);
    
                strumLineNotes.add(babyArrow);
            }
        }
}