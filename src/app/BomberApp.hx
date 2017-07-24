package app;

import ent.Player;
import screen.GameScreen;

/**
 *  Main app of game
 */
class BomberApp extends hxd.App {

    /**
     *  Instance of app
     */
    static var instance : BomberApp;

    /**
     *  Game context
     */
    var ctx : GameContext;            

    /**
     *  On assets loaded
     */
    function onLoaded () : Void {
        ctx.registerScreen (GameScreen.NAME, new GameScreen ());
        ctx.startScreen (GameScreen.NAME);

        var dir = new h3d.scene.DirLight(new h3d.Vector(0.2, 0.3, -1), s3d);        
        dir.color.set(0.35, 0.35, 0.35);
        
        s3d.camera.zNear = 1;
        s3d.camera.zFar = 30;

        //new h3d.scene.CameraController (5, s3d).loadFromCamera ();
    }

    /**
     *  On app init
     */
    override function init() {
        ctx = new GameContext (this);
        ctx.assets.onLoaded = onLoaded;
        ctx.assets.loadPack ("pack.zip");
	}

	/**
	 *  On update frames
	 *  @param dt - 
	 */
	override function update (dt : Float) {        
        ctx.waitEvent.update (dt);
    }
}