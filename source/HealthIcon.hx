package;

import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	var tex:FlxAtlasFrames;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		loadGraphic(Paths.image('icons/' + char), true, 150, 150);
		animation.add(char, [0, 1, 2], 0, false, isPlayer);
		animation.play(char);
		switch(char){
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				{
					antialiasing = false;
				}
			default:
				{
					antialiasing = true;
				}
		}
		scrollFactor.set();
	}

	//change char is just a clone of the new function cuz im dumb lol!!!!

	public function changeChar(char:String = 'bf', isPlayer:Bool = false)
		{
			loadGraphic(Paths.image('icons/' + char), true, 150, 150);
			animation.add(char, [0, 1, 2], 0, false, isPlayer);
			animation.play(char);
			switch(char){
				case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
					{
						antialiasing = false;
					}
				default:
					{
						antialiasing = true;
					}
			}
			scrollFactor.set();
		}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
