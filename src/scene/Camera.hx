package scene;

import h3d.col.Point;

/**
 *  Scene camera
 */
class Camera {

    /**
     *  3D scene
     */
    var s3d : h3d.scene.Scene;

    /**
     *  Constructor
     *  @param scene - 
     */
    public function new (scene : h3d.scene.Scene) {
        s3d = scene;
    }

    /**
     *  Place camera
     *  @param from - 
     *  @param to - 
     */
    public inline function lookAt (from : Point, to : Point) : Void {
        s3d.camera.pos.set (from.x, from.y, from.z);
        s3d.camera.target.set (to.x, to.y, to.z);
    }

    /**
     *  Move camera
     *  @param dx - 
     *  @param dy - 
     *  @param dz - 
     */
    public inline function move (dx : Float, dy :Float, ?dz : Float) : Void {
        s3d.camera.pos.x += dx;
        s3d.camera.target.x += dx;
        
        s3d.camera.pos.y += dy;
        s3d.camera.target.y += dy;

        if (dz != null) {
            s3d.camera.pos.z += dz;
            s3d.camera.target.z += dz;
        }
    }
}