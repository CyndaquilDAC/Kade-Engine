package;
import flixel.*;
import haxe.*;
import lime.*;
import openfl.*;

/**
 * type of loopin going on.
 */
enum LoopState{
    NONE; // The song is not Looping
    REPEAT; // The song is either in a AB Loop or normal repeat mode
    ANODE; // The "A" Node
    ABREPEAT; //The song is on ab repeat.
}