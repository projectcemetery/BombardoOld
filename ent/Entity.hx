package ent;

import h3d.col.Point;
import h3d.scene.Object;

/**
 *  Base entity class
 */
class Entity {

    /**
     *  Model
     */
    public var model (default, null) : Object;

    /**
     *  Reset entity. All it's state. For override
     */
    public function reset () : Void {}

    /**
     *  Get position. Virtual
     *  @param x - 
     *  @param y - 
     */
    public function getPos (x : Float, y : Float) : Point {
        return new Point (model.x, model.y, model.z);
    }

    /**
     *  Set position. Virtual
     */
    public function setPos (x : Float, y : Float) : Void {
        model.x = x;
        model.y = y;
    }

    /**
     *  On update logic. For override
     */
    public function onUpdate (dt : Float) : Void {}
}