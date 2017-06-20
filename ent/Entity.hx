package ent;

import h3d.col.Point;
import h3d.scene.Object;
import map.Level;

/**
 *  Base entity class
 */
class Entity {

    /**
     *  Main 3d scene
     */
    var s3d : h3d.scene.Scene;

    /**
     *  Model cache
     */
    var modelCache : h3d.prim.ModelCache;

    /**
     *  Current game level
     */
    var level : Level;    

    /**
     *  Entity factory
     */
    var entityFactory : EntityFactory;

    /**
     *  For timer
     */
    var waitEvent : hxd.WaitEvent;

    /**
     *  Constructor
     */
    public function new () {
        waitEvent = BomberApp.get ().waitEvent;
        s3d = BomberApp.get ().s3d;
        modelCache = BomberApp.get ().modelCache;
        level = BomberApp.get ().level;
        entityFactory = BomberApp.get ().entityFactory;
    }

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
    public function getPos () : Point {
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
     *  Dispose entity
     */
    public function onDispose () : Void {}

    /**
     *  On entity hit, by bombs or something else
     */
    public function onHit () : Void {}    
}