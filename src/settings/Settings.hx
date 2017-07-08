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
        // TODO read from somethere. Tarantool???
        player = new PlayerSettings ();
    }
}