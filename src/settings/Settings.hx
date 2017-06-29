package settings;

/**
 *  Settings for objects: Player, Mobs
 */
class Settings {

    /**
     *  Settings for player
     */
    public var player : PlayerSettings;

    /**
     *  Constructor
     */
    public function new () {
    }

    /**
     *  On post create
     */
    public function init () : Void {
        // TODO read from somethere. Tarantool???
        player = new PlayerSettings ();        
    }
}