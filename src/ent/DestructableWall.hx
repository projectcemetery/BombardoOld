package ent;

import h3d.mat.Material;
import h3d.prim.Cube;
import h3d.scene.Mesh;
import loader.Assets;

/**
 *  Destructable wall
 */
class DestructableWall extends StaticEntity {

    /**
     *  Wall material
     */
    static var mat : Material;

    /**
     *  Cube primitive
     */
    static var cube : Cube;

    /**
     *  Constructor
     */
    public function new () {
        super ();

        if (mat == null) {
            var tex = ctx.assets.getTexture (Assets.wood_png);
            mat = new Material (tex);
            mat.mainPass.enableLights = true;
            mat.shadows = true;
            cube = new Cube (1, 1, 1);
            cube.translate (-0.5, -0.5, 0);
            cube.addNormals ();
            cube.addUVs ();
        }

        model = new Mesh (cube, mat);
        ctx.scene3d.addChild (model);
    }

    /**
     *  On entity hit, by bombs or something else
     */
    override public function onHit () : Void {
        gameScreen.onWallDesctroyed (mapX, mapY);
        level.removeEntity (this);
    }
}