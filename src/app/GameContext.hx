package app;

import ent.EntityFactory;
import dispatch.Dispatcher;
import settings.Settings;
import map.Level;
import gui.Hud;
import screen.Screen;

/**
 *  All classes needed for game
 */
class GameContext {

    /**
     *  Instance of game
     */
    static var instance : GameContext;

    /**
     *  Game screens
     */
    var screens : Map<String, Screen>;

    /**
     *  Engine
     */
    public var engine (default, null) : h3d.Engine;

    /**
     *  2D scene
     */
    public var scene2d (default, null) : h2d.Scene;

    /**
     *  3D scene
     */
    public var scene3d (default, null) : Scene3d;

    /**
     *  For creating timers
     */
    public var waitEvent (default, null) : hxd.WaitEvent;

    /**
     *  Entity factory
     */
    public var entityFactory (default, null) : EntityFactory;

    /**
     *  Cache for models
     */
    public var modelCache (default, null) : h3d.prim.ModelCache;

    /**
     *  All settings
     */
    public var settings (default, null) : Settings;

    /**
     *  Event dispatcher
     */
    public var dispatcher (default, null) : Dispatcher;

    /**
     *  Player hud
     *  TODO: remove
     */
    public var hud (default, null) : Hud;

    /**
     *  Current game level
     *  TODO: remove
     */
    public var level (default, null) : Level;  

    /**
     *  Return instance
     *  @return GameContext
     */
    public static function get () : GameContext {
        return instance;
    }

    /**
     *  Constructor
     *  @param app - 
     */
    @:allow(app.BomberApp)
    function new (app : hxd.App) {        
        engine = app.engine;
        scene2d = app.s2d;
        scene3d = new Scene3d (app.s3d);
        waitEvent = new hxd.WaitEvent ();
        modelCache = new h3d.prim.ModelCache();

        // TODO: to constructor
        dispatcher = Dispatcher.get ();
        settings = new Settings ();
        entityFactory = new EntityFactory ();
        level = new Level ();
        hud = new Hud ();        

        instance = this;
    }

    /**
     *  Init objects
     */
    @:allow(app.BomberApp)
    function init () : Void {
        settings.init ();
        level.init ();
        hud.init ();
    }
}