package settings;

/**
 *  Settings for player
 *  TODO macros
 */
class PlayerSettings extends ChangeNotifier {

    /**
     *  Constant for property name
     */
    //public inline static var MAX_BOMB_COUNT = "MAX_BOMB_COUNT";

    /**
     *  Maximum bomb count that player can place for one time
     */
/*    var maxBombCountInternal : Int = 1;
    public var maxBombCount (get, set) : Int;
    public function get_maxBombCount () : Int {        
        return maxBombCountInternal;
    }

    public function set_maxBombCount (v : Int) : Int {
        maxBombCountInternal = v;
        notify (MAX_BOMB_COUNT, v);
        return maxBombCountInternal;
    }*/

    /**
     *  Maximum bomb count that player can place for one time
     */
    @:notify
    var maxBombCount = 1;
}