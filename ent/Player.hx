package ent;

import map.Level;
import col.CollideSide;
import ent.Bomb;
import ent.EntityFactory;

/**
 *  Player
 */
class Player extends Entity {

    /**
     *  Main 3d scene
     */
    var s3d : h3d.scene.Scene;

    /**
     *  Current game level
     */
    var level : Level;

    var entityFactory : EntityFactory;

    /**
     *  Player mesh
     */
    var mesh : h3d.scene.Mesh;

    /**
     *  Player speed
     */
    var speed : Float = 0.03;

    /**
     *  Move
     *  @param x - 
     */
    function move (x : Float, y : Float) {
        mesh.x += x;
        s3d.camera.pos.x += x;
        s3d.camera.target.x += x;

        mesh.y += y;
        s3d.camera.pos.y += y;
        s3d.camera.target.y += y;
    }

    /**
     *  Constructor
     */
    public function new  () {
        s3d = BomberApp.get ().s3d;
        level = BomberApp.get ().level;
        entityFactory = BomberApp.get ().entityFactory;

        var cube = new h3d.prim.Cube (0.5, 0.5, 0.5);
        //cube.translate (-0.25,-0.25,-0.25);
        mesh = new h3d.scene.Mesh (cube, s3d);
        mesh.material.color.setColor (0xFF3300);
        mesh.setPos (4.25, 3, 0.0);
        model = mesh;
    }    

    /**
     *  On player logic update
     *  @param dt - 
     */
    override public function onUpdate (dt : Float) : Void {
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
            // Place bomb
            var bomb = entityFactory.recycleBomb ();
            level.placeCellEntity (mesh.x, mesh.y, bomb);
        }
    }
}