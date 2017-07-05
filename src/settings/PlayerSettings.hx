package settings;

import dispatch.ChangeNotifier;

/**
 *  Settings for player
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
     *  Time before boom
     */
    public var beforeBoom : Int = 3;
    
    /**
     *  Length of explosion in map cells
     */
    public var bombBoomLength : Int = 2;

    /**
     *  Time of explosion
     */
    public var boomTime : Int = 1;

    /**
     *  Constructor
     */
    public function new () {}
}