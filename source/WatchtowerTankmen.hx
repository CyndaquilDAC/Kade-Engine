package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class WatchtowerTankmen extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas("tank/tankWatchtower");
		animation.addByPrefix('bop', 'watchtower gradient color', 24, false);
		animation.play('bop');
		antialiasing = true;
	}

	public function dance():Void
	{
		animation.play('bop');
	}
}
