package scene;

import h3d.col.Bounds;
import h3d.scene.Object;

/**
 *  Game scene with objects and camera
 *  Calculates culling for objects
 */
class Scene3d {

    /**
     *  3D scene
     */
    var s3d : h3d.scene.Scene;

    /**
     *  Time to count
     */
    var calcTime : Float;

    /**
     *  Camera
     */
    public var camera : Camera;

    /**
     *  Objects
     */
    public var objects : Array<Object>;

    /**
     *  Constructor
     */
    public function new (scene : h3d.scene.Scene, wait : hxd.WaitEvent) {
        objects = new Array<Object> ();
        calcTime = 0;
        s3d = scene;
        camera = new Camera (s3d);
        wait.waitUntil (onUpdate);
    }

    /**
     *  Add object to scene
     *  @param object - 
     */
    public function addChild (object : h3d.scene.Object) : Void {
        s3d.addChild (object);
        objects.push (object);
    }

    /**
     *  Remove child
     *  @param object - 
     */
    public function removeChild (object : h3d.scene.Object) : Void {
        s3d.removeChild (object);
        objects.remove (object);
    }

    /**
     *  On update
     *  @param dt - 
     *  @return Bool
     */
    public function onUpdate (dt : Float) : Bool {
        if (calcTime > 10) {
            for (o in objects) {
                var b = o.getBounds ();
                o.visible = b.inFrustum (s3d.camera.m);
            }
            calcTime = 0;
        }
        calcTime += dt;
        return false;
    }
}