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
     *  On app init
     */
    override function init() {
        ctx = new GameContext (this);

        ctx.registerScreen (GameScreen.NAME, new GameScreen ());
        ctx.startScreen (GameScreen.NAME);

        var dir = new h3d.scene.DirLight(new h3d.Vector(0.2, 0.3, -1), s3d);        
        dir.color.set(0.35, 0.35, 0.35);
        
        s3d.camera.zNear = 1;
        s3d.camera.zFar = 30;

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
        ctx.waitEvent.update (dt);
    }
}