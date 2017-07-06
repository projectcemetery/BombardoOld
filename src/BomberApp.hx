import h3d.scene.*;
import ent.Player;
import ent.EntityFactory;
import map.Level;
import gui.Hud;
import screen.Screen;
import screen.GameScreen;
import settings.Settings;

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
     *  Game screens
     */
    var screens : Map<String, Screen>;

    /**
     *  Cache for models
     */
    public var modelCache (default, null) : h3d.prim.ModelCache;

    /**
     *  For creating timers
     */
    public var waitEvent (default, null) : hxd.WaitEvent;

    /**
     *  Event dispatcher
     */
    public var dispatcher (default, null) : dispatch.Dispatcher;    

    /**
     *  Current game level
     */
    public var level (default, null) : Level;        

    /**
     *  Player hud
     */
    public var hud (default, null) : Hud;

    /**
     *  Entity factory
     */
    public var entityFactory (default, null) : EntityFactory;

    /**
     *  All settings
     */
    public var settings (default, null) : Settings;

    /**
     *  Get app
     *  @return BomberApp
     */
    public static inline function get () : BomberApp {
        return instance;
    }

    /**
     *  Notify that mob was killed
     */
    public function onMobKilled () : Void {
        settings.player.score += 5;
    }

    /**
     *  On app init
     */
    override function init() {
        instance = this;
        
        waitEvent = new hxd.WaitEvent ();
        modelCache = new h3d.prim.ModelCache();

        dispatcher = dispatch.Dispatcher.get ();
        settings = new Settings ();
        level = new Level ();
        hud = new Hud ();
        entityFactory = new EntityFactory ();

        screens = new Map<String, Screen> ();
        screens["GameScreen"] = new GameScreen ();

        settings.init ();
        level.init ();
        entityFactory.init ();
        hud.init ();

        player = new Player ();

        var dir = new h3d.scene.DirLight(new h3d.Vector(0.2, 0.3, -1), s3d);        
        dir.color.set(0.15, 0.15, 0.15);
        
        s3d.camera.zNear = 1;
        s3d.camera.zFar = 30;

        /*var gameover = new gui.GameOverDialog ();
        gameover.init ();
        gameover.show ();*/

        /*var model = modelCache.loadModel(hxd.Res.bombpowerup);    
        model.scale (0.006);
        model.setPos (player.model.x, player.model.y, 0.3);
        s3d.addChild (model);*/

        // TODO: background of game level
        /*var skyTexture = new h3d.mat.Texture(128, 128, [Cube, MipMapped]);
		var bmp = hxd.Pixels.alloc(skyTexture.width, skyTexture.height, h3d.mat.Texture.nativeFormat);
		var faceColors = [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF];
		for( i in 0...6 ) {
			for( x in 0...128 )
				for( y in 0...128 )
					bmp.setPixel(x,y, (x + y) & 1 == 0 ? faceColors[i] : (faceColors[i]>>1)&0x7F7F7F);
			skyTexture.uploadPixels(bmp, 0, i);
		}
		skyTexture.mipMap = Linear;

		var sky = new h3d.prim.Sphere(30, 128, 128);        
		sky.addNormals();
		var skyMesh = new h3d.scene.Mesh(sky, s3d);
        skyMesh.setPos (0, 0, 0);
		skyMesh.material.mainPass.culling = Front;
		skyMesh.material.mainPass.addShader(new h3d.shader.CubeMap(skyTexture));*/

        //new h3d.scene.CameraController (5, s3d).loadFromCamera ();
	}

	override function update( dt : Float ) {        
        waitEvent.update (dt);
    }
}