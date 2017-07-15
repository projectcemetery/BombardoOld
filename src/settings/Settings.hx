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
     *  Mob count
     */
    public var mobCount : Int = 0;

    /**
     *  Constructor
     */
    public function new () {
        // TODO read from somethere. Tarantool???
        player = new PlayerSettings ();
    }
}