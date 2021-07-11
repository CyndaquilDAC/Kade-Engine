package;

import flixel.FlxSprite;

class HealthIconFullGrid extends FlxSprite
{
    //THIS IS ONLY HERE BECAUSE IM TOO LAZY TO MAKE A COMPETENT ICON SWITCHER FOR CHARTING STATE LMAO

	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('chartingGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1, 2], 0, false, isPlayer);
		animation.add('bf-car', [0, 1, 2], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1, 2], 0, false, isPlayer);
        animation.add('bf-holding-gf', [3, 4, 5], 0, false, isPlayer);
		animation.add('bf-pixel', [6, 7, 8], 0, false, isPlayer);
		animation.add('spooky', [41, 42, 43], 0, false, isPlayer);
		animation.add('pico', [27, 28, 29], 0, false, isPlayer);
		animation.add('mom', [16, 17, 18], 0, false, isPlayer);
		animation.add('mom-car', [16, 17, 18], 0, false, isPlayer);
		animation.add('tankman', [44, 45, 46], 0, false, isPlayer);
		animation.add('dad', [10, 11, 12], 0, false, isPlayer);
		animation.add('senpai', [31, 32, 33], 0, false, isPlayer);
		animation.add('senpai-angry', [34, 35, 36], 0, false, isPlayer);
		animation.add('spirit', [37, 38, 39], 0, false, isPlayer);
		animation.add('gf', [13, 14, 15], 0, false, isPlayer);
		animation.add('parents-christmas', [24, 25, 26], 0, false, isPlayer);
		animation.add('monster', [21, 22, 23], 0, false, isPlayer);
		animation.add('monster-christmas', [21, 22, 23], 0, false, isPlayer);
		animation.play(char);

		switch(char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				antialiasing = false;
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