package scene;

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
     *  Camera
     */
    public var camera : Camera;

    /**
     *  Constructor
     */
    public function new (scene : h3d.scene.Scene) {
        s3d = scene;
        camera = new Camera (s3d);
    }

    /**
     *  Add object to scene
     *  @param object - 
     */
    public function addChild (object : h3d.scene.Object) : Void {
        s3d.addChild (object);
    }

    /**
     *  Remove child
     *  @param object - 
     */
    public function removeChild (object : h3d.scene.Object) : Void {
        s3d.removeChild (object);
    }    
}