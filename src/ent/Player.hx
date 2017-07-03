package ent;

import h3d.col.Bounds;
import map.Level;
import col.Side;
import col.CollisionInfo;
import ent.Bomb;
import ent.EntityFactory;

/**
 *  Player
 */
class Player extends MovingEntity {

    /**
     *  Player speed
     */
    var speed : Float = 0.03;

    /**
     *  Placed bomb count
     */
    var placedCount : Int = 0;

    /**
     *  Placed bomb
     */
    var placedBomb : Bomb = null;

    /**
     *  Was collide with self bomb
     */
    var wasBombCollide = false;

    /**
     *  Move
     *  @param x - 
     */
    function onMoveComplete (dx : Float, dy : Float) : Void {
        ctx.s3d.camera.pos.x += dx;
        ctx.s3d.camera.target.x += dx;
        
        ctx.s3d.camera.pos.y += dy;
        ctx.s3d.camera.target.y += dy;

        if (dx > 0) {
            model.setRotateAxis (0,0, 1, 90 * 3.14 / 180);
        }

        if (dx < 0) {
            model.setRotateAxis (0,0, 1, -90 * 3.14 / 180);
        }

        if (dy < 0) {
            model.setRotateAxis (0,0, 1, 0);
        }

        if (dy > 0) {
            model.setRotateAxis (0,0, 1, 180 * 3.14 / 180);
        }
    }

    /**
     *  Place bomb
     */
    function placeBomb () : Void {
        if (placedCount >= ctx.settings.player.maxBombCount) return;

        placedCount += 1;
        // Place bomb
        placedBomb = ctx.entityFactory.recycleBomb ();
        ctx.level.placeEntity (model.x, model.y, placedBomb);
        placedBomb.onBoom = function () {
            placedCount -= 1;
        };
        placedBomb.startTimer ();
    }

    /**
     *  Filter collision
     */
    function onFilterCollision (c : CollisionInfo) : Bool {
        if ((placedBomb != null) && (c.entity2 == placedBomb)) {
            wasBombCollide = true;
            return true;
        }

        return false;
    }

    /**
     *  On player logic update
     *  @param dt - 
     */
    function onUpdate (dt : Float) : Void {
        if (isDisposed) return;
        
        var dx = 0.0;
        var dy = 0.0;

        if (hxd.Key.isDown (hxd.Key.W)) dy = -speed * dt;
        if (hxd.Key.isDown (hxd.Key.S)) dy = speed * dt;
        if (hxd.Key.isDown (hxd.Key.A)) dx = -speed * dt;
        if (hxd.Key.isDown (hxd.Key.D)) dx = speed * dt;

        wasBombCollide = false;
        move (dx, dy);
        if (!wasBombCollide) placedBomb = null;

        if (hxd.Key.isPressed (hxd.Key.SPACE)) {
            placeBomb ();
        }
    }

    /**
     *  Constructor
     */
    public function new  () {
        super ();        

        model = ctx.modelCache.loadModel(hxd.Res.testchar);
        model.scale (0.0015);

        ctx.level.placePlayer (this);
        
        setOnFilterCollision (onFilterCollision);
        setOnMoveComplete (onMoveComplete);
        setOnUpdate (onUpdate);       
    }

    /**
     *  On entity hit, by bombs or something else
     */
    override public function onHit () : Void {
        ctx.level.removeEntity (this);
    }
}