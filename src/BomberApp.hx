import h3d.scene.*;
import h3d.shader.BaseMesh;
import ent.Player;
import ent.EntityFactory;
import map.Level;

/**
 *  Main app of game
 */
class BomberApp extends hxd.App {

    /**
     *  Instance of app
     */
    static var instance : BomberApp;

    /**
     *  Player mesh
     */
    var player : Player;

    /**
     *  Current game level
     */
    public var level (default, null) : Level;    

    /**
     *  Cache for models
     */
    public var modelCache (default, null) : h3d.prim.ModelCache;

    /**
     *  Entity factory
     */
    public var entityFactory (default, null) : EntityFactory;

    /**
     *  For creating timers
     */
    public var waitEvent (default, null) : hxd.WaitEvent;

    /**
     *  Get app
     *  @return BomberApp
     */
    public static inline function get () : BomberApp {
        return instance;
    }

    /**
     *  On app init
     */
    override function init() {
        instance = this;
        
        waitEvent = new hxd.WaitEvent ();
        modelCache = new h3d.prim.ModelCache();

        level = new Level ();
        entityFactory = new EntityFactory ();        

        level.init ();
        entityFactory.init ();

        player = new Player ();

        var dir = new h3d.scene.DirLight(new h3d.Vector(0.2, 0.3, -1), s3d);        
        dir.color.set(0.15, 0.15, 0.15);
        
        s3d.camera.zNear = 6;
        s3d.camera.zFar = 30;
        s3d.camera.pos.set (4.0, 8.0, 20);
        s3d.camera.target.set (4.0, 3, 0);
       
        //new h3d.scene.CameraController (s3d).loadFromCamera ();
	}

	override function update( dt : Float ) {        
        waitEvent.update (dt);
    }
}