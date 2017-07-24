package ent;

import col.Side;
import col.CollisionInfo;
import loader.Assets;

/**
 *  Class for mob
 */
class Mob extends MovingEntity {

    /**
     *  Player speed
     */
    var speed : Float = 0.015;

    /**
     *  Direction of moving
     */
    var direction : Side;

    /**
     *  Move
     *  @param x - 
     */
    function onMoveComplete (dx : Float, dy : Float) : Void {
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
     *  Generate new direction
     */
    function newDirection () : Side {
        var intDir = Math.floor (Math.random () * 4);
        if (intDir > 3) intDir = 3;
        return Side.createByIndex (intDir);
    }

    /**
     *  On collision
     *  @param cols - 
     */
    function onCollision (cols : Array<CollisionInfo>) : Void {
        if (cols.length > 0) {            
            var play : Entity = null;
            for (c in cols) {
                if (Std.is(c.parentEntity, Player)) {
                    play = c.parentEntity;
                    break;
                }
                if (c.entities != null) {
                    for (ent in c.entities) {
                        if (Std.is(ent, Player)) {
                            play = ent;
                            break;
                        }
                    }
                }
            }
            if (play != null) {
                play.onHit ();
            } else {
                direction = newDirection ();
            }
        }
    }

    /**
     *  On player logic update
     *  @param dt - 
     */
    function onUpdate (dt : Float) : Void {
        switch (direction) {
            case Side.Top: move (0, -dt * speed);
            case Side.Bottom: move (0, dt * speed);
            case Side.Left: move (-dt * speed, 0);
            case Side.Right: move (dt * speed, 0);
            default:
        }
    }

    /**
     *  Constructor
     */
    public function new () {
        super ();
        
        model = ctx.assets.getObject (Assets.Model_hmd);
        model.scale (0.06);

        model.playAnimation(ctx.assets.getAnimation (Assets.Model_hmd));

        setOnCollision (onCollision);
        setOnUpdate (onUpdate);
        setOnMoveComplete (onMoveComplete);
        direction = newDirection ();
    }

    /**
     *  On entity hit, by bombs or something else
     */
    override public function onHit () : Void {
        gameScreen.onMobKilled ();
        level.removeEntity (this);
    }
}