package ent;

import map.Level;
import col.CollideSide;
import col.CollisionInfo;
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
     *  Placed bomb
     */
    var placedBomb : Bomb = null;

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
        placedBomb = entityFactory.recycleBomb ();
        level.placeEntity (mesh.x, mesh.y, placedBomb);
        placedBomb.startTimer ();
    }

    /**
     *  On player logic update
     *  @param dt - 
     */
    function onUpdate (dt : Float) : Bool {
        if (isDisposed) return true;

        var bounds = mesh.getBounds ();
        var cols = new Array<CollisionInfo> ();        

        if (hxd.Key.isDown (hxd.Key.W)) {
            var b = bounds.clone();
            b.yMin += -speed * dt;
            cols.push ({
                entity1 : this,
                side : CollideSide.Top,
                bounds : b,                
            });
        } 
        if (hxd.Key.isDown (hxd.Key.S)) {
            var b = bounds.clone();
            b.yMax += speed * dt;
            cols.push ({
                entity1 : this,
                side : CollideSide.Bottom,
                bounds : b                
            });
        } 
        if (hxd.Key.isDown (hxd.Key.A)) {
            var b = bounds.clone();
            b.xMin += -speed * dt;
            cols.push ({
                entity1 : this,
                side : CollideSide.Left,
                bounds : b                
            });
        } 
        if (hxd.Key.isDown (hxd.Key.D)) {
            var b = bounds.clone();
            b.xMax += speed * dt;
            cols.push ({
                entity1 : this,
                side : CollideSide.Right,
                bounds : b                
            });
        }

        cols = level.isCollide (cols);

        var wasBombCollide = false;
        for (c in cols) {
            if ((placedBomb != null) && (c.entity2 == placedBomb)) {
                trace ("GOOD");
                c.isCollide = false;
                wasBombCollide = true;
            }

            if (!c.isCollide) {
                switch (c.side) {
                    case CollideSide.Top: move (0, -speed * dt);
                    case CollideSide.Bottom: move (0, speed * dt);
                    case CollideSide.Left: move (-speed * dt, 0);
                    case CollideSide.Right: move (speed * dt, 0);
                    default: {}
                }
            }
        }

        if (!wasBombCollide) placedBomb = null;

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