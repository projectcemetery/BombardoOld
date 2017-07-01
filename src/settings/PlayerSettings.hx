package settings;

import dispatch.ChangeNotifier;

/**
 *  Settings for player
 *  TODO macros
 */
class PlayerSettings extends ChangeNotifier {

    /**
     *  Maximum bomb count that player can place for one time
     */
    @:notify
    var maxBombCount : Int = 1;

    /**
     *  Player score
     */
    @:notify
    var score : Int = 0;

    /**
     *  Constructor
     */
    public function new () {}
}