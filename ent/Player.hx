package ent;

import map.Level;
import col.CollideSide;
import ent.Bomb;
import ent.EntityFactory;

/**
 *  Player
 */
class Player extends MovingEntity {

    /**
     *  Player mesh
     */
    var mesh : h3d.scene.Mesh;

    /**
     *  Player speed
     */
    var speed : Float = 0.03;

    /**
     *  Is entity disposed
     */
    var isDisposed : Bool = false;

    /**
     *  Move
     *  @param x - 
     */
    function move (x : Float, y : Float) : Void {
        mesh.x += x;
        s3d.camera.pos.x += x;
        s3d.camera.target.x += x;

        mesh.y += y;
        s3d.camera.pos.y += y;
        s3d.camera.target.y += y;
    }    

    /**
     *  Place bomb
     */
    function placeBomb () : Void {
        // Place bomb
        var bomb = entityFactory.recycleBomb ();
        level.placeEntity (mesh.x, mesh.y, bomb);
        bomb.startTimer ();
    }

    /**
     *  On player logic update
     *  @param dt - 
     */
    function onUpdate (dt : Float) : Bool {
        if (isDisposed) return true;

        var bounds = mesh.getBounds ();

        if (hxd.Key.isDown (hxd.Key.W)) {
            var b = bounds.clone();
            b.yMin += -speed * dt;
            if (!level.isCollideSide (b, CollideSide.Top)) move (0, -speed * dt);
        } 
        if (hxd.Key.isDown (hxd.Key.S)) {
            var b = bounds.clone();
            b.yMax += speed * dt;
            if (!level.isCollideSide (b, CollideSide.Bottom)) move (0, speed * dt);
        } 
        if (hxd.Key.isDown (hxd.Key.A)) {
            var b = bounds.clone();
            b.xMin += -speed * dt;
            if (!level.isCollideSide (b, CollideSide.Left)) move (-speed * dt, 0);
        } 
        if (hxd.Key.isDown (hxd.Key.D)) {
            var b = bounds.clone();
            b.xMax += speed * dt;
            if (!level.isCollideSide (b, CollideSide.Right)) move (speed * dt, 0);
        }
        if (hxd.Key.isPressed (hxd.Key.SPACE)) {
            placeBomb ();
        }

        return false;
    }

    /**
     *  Constructor
     */
    public function new  () {
        super ();

        var cube = new h3d.prim.Cube (0.5, 0.5, 0.5);
        cube.translate (-0.25,-0.25,-0.25);
        mesh = new h3d.scene.Mesh (cube);
        mesh.material.color.setColor (0xFF3300);
        model = mesh;

        level.placeEntity (4, 3, this);

        waitEvent.waitUntil (onUpdate);
    }

    /**
     *  On entity hit, by bombs or something else
     */
    override public function onHit () : Void {
        level.removeEntity (this);
    }

    /**
     *  Dispose entity
     */
    override public function onDispose () : Void {
        isDisposed = true;
    }
}