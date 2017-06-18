import h3d.scene.*;
import h3d.shader.BaseMesh;
import ent.Player;
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
        
        level = new Level ();
        player = new Player ();
        
        var dir = new h3d.scene.DirLight(new h3d.Vector(0.2, 0.3, -1), s3d);
        dir.color.set(0.1, 0.1, 0.1);
        
        s3d.camera.zNear = 6;
        s3d.camera.zFar = 30;
        s3d.camera.pos.set (4.0, 8.0, 20);
        s3d.camera.target.set (4.0, 3, 0);       
       
       //new h3d.scene.CameraController (s3d).loadFromCamera ();
	}

	override function update( dt : Float ) {
        player.onUpdate (dt);
    }
}