import DiffCalc;
import openfl.system.System;
import flixel.math.FlxMath;
import Song.SwagSong;

/**
 * calculate your maximum possible scores! or dont idk lol
 */
class MaxScoreCalc
{
    public static function CalculateMaxScore(song:SwagSong)
    {
        trace('calculatamables maximalation scoreablezations on ' + song.song.toLowerCase());
        // cleaned notes
        var readableNotes:Array<SmallNote> = [];

        if (song.notes == null)
            return 0.0;

        if (song.notes.length == 0)
            return 0.0;

        // find all of the notes
        for(i in song.notes) // sections
        {
            for (ii in i.sectionNotes) // notes
            {
                var gottaHitNote:Bool = i.mustHitSection;

				if (ii[1] > 3)
					gottaHitNote = !i.mustHitSection;

                if (gottaHitNote)
                    readableNotes.push(new SmallNote(ii[0],Math.floor(Math.abs(ii[1]))));
            }
        }
        readableNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
        return readableNotes.length * 350;
        trace(song.song.toLowerCase() + ' max score is ' + readableNotes.length * 350);
    }
}