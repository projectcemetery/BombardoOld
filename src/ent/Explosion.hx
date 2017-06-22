package ent;

import map.Level;

/**
 *  Explosion from bomb
 */
class Explosion extends StaticEntity {   

    /**
     *  Player mesh
     */
    var mesh : h3d.scene.Mesh;

    /**
     *  Explosion settings
     */
    var explosionSettings : ExplosionSettings;

    /**
     *  Constructor
     */
    public function new (explosionSettings : ExplosionSettings) {
        super ();
        
        this.explosionSettings = explosionSettings;
        var cube = new h3d.prim.Cube (0.5, 0.5, 0.5);
        cube.translate (-0.25,-0.25,-0.25);
        mesh = new h3d.scene.Mesh (cube);
        mesh.material.color.setColor (0xFF3355);
        model = mesh;        
    }

    /**
     *  Start work
     */
    public function startTimer () : Void {
        waitEvent.wait (explosionSettings.lifetime, function () {
            level.removeEntity (this);
        });
    }
}