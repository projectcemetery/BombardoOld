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
     *  Length of explosion in map cells
     */
    @:notify
    var boomLength : Int = 1;

    /**
     *  Player score
     */
    @:notify
    var score : Int = 0;

    /**
     *  Player score
     */
    @:notify
    var speed : Int = 1;

    /**
     *  Time before boom
     */
    public var beforeBoom : Int = 3;        

    /**
     *  Time of explosion
     */
    public var boomTime : Int = 1;

    /**
     *  Chance of powerup in percent
     */
    public var powerUpChance = 10; 

    /**
     *  Reset settings
     */
    public function reset () {
        maxBombCount = 1;
        score = 0;
        speed = 1;
        boomLength = 1;
    }

    /**
     *  Constructor
     */
    public function new () {}
}