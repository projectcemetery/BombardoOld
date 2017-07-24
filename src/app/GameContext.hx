package app;

import dispatch.Dispatcher;
import settings.Settings;
import screen.Screen;
import scene.Scene3d;
import loader.Assets;

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
     *  Asset manager
     */
    public var assets (default, null) : Assets;

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
     *  Current game screen
     */
    public var screen (default, null) : Screen;

    /**
     *  For creating timers
     */
    public var waitEvent (default, null) : hxd.WaitEvent;

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
        assets = new Assets ();
        engine = app.engine;
        scene2d = app.s2d;        
        waitEvent = new hxd.WaitEvent ();
        scene3d = new Scene3d (app.s3d, waitEvent);
        //modelCache = new h3d.prim.ModelCache();
        
        dispatcher = new Dispatcher ();
        settings = new Settings ();

        screens = new Map<String, Screen> ();

        instance = this;
    }

    /**
     *  Register screen
     *  @param name - 
     *  @param screen - 
     */
    public function registerScreen (name : String, screen : Screen) : Void {
        screens[name] = screen;
    }

    /**
     *  Start screen
     *  @param name - 
     */
    public function startScreen (name : String) : Void {
        if (screen != null) screen.onLeave ();
        screen = screens[name];
        if (screen == null) return;
        screen.onEnter ();
    }
}