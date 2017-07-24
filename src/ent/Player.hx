package ent;

import col.CollisionInfo;
import ent.Bomb;
import loader.Assets;
import h3d.anim.Animation;

/**
 *  Player
 */
class Player extends MovingEntity {

    /**
     *  Player speed factor
     */
    var speedFactor : Float = 0.03;

    /**
     *  Real player speed
     */
    var realSpeed : Float;

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
     *  Run animation
     */
    var runAnimation : Animation;

    /**
     *  Idle animation
     */
    var idleAnimation : Animation;

    /**
     *  Current animation
     */
    var currentAnimation : Animation;

    /**
     *  Is player moving
     */
    var isRunning : Bool;

    /**
     *  Move
     *  @param x - 
     */
    function onMoveComplete (dx : Float, dy : Float) : Void {
        ctx.scene3d.camera.move (dx, dy);                

        if (dx > 0) {
            model.setRotateAxis (0,0, 1, 180 * 3.14 / 180);            
            isRunning = true;
        }

        if (dx < 0) {
            model.setRotateAxis (0,0, 1, 0);
            isRunning = true;
        }

        if (dy < 0) {
            model.setRotateAxis (0,0, 1, 90 * 3.14 / 180);
            isRunning = true;
        }

        if (dy > 0) {
            model.setRotateAxis (0,0, 1, -90 * 3.14 / 180);
            isRunning = true;
        }

        playAnimation ();
    }

    /**
     *  Place bomb
     */
    function placeBomb () : Void {
        if (placedCount >= ctx.settings.player.maxBombCount) return;

        // Check bomb exists
        var entArr = level.getEntity (model.x, model.y);
        if (entArr != null) {
            for (e in entArr) {
                if (Std.is (e, Bomb)) return;
            }
        }

        placedCount += 1;
        // Place bomb
        placedBomb = level.recycleBomb ();
        level.placeEntity (model.x, model.y, placedBomb);
        placedBomb.onBoom = function () {
            placedCount -= 1;
        };
        placedBomb.startTimer ();
    }

    /**
     *  Filter collision
     */
    function onFilterCollision (c : CollisionInfo) : Bool {
        if (c.entities != null) {
            for (e in c.entities) {
                if (e == placedBomb) return true;
            }
        }        
        return false;
    }

    /**
     *  On player logic update
     *  @param dt - 
     */
    function onUpdate (dt : Float) : Void {
        if (isDisposed) return;
        
        isRunning = false;
        var dx = 0.0;
        var dy = 0.0;       

        if (hxd.Key.isDown (hxd.Key.W)) dy = -realSpeed * dt;
        if (hxd.Key.isDown (hxd.Key.S)) dy = realSpeed * dt;
        if (hxd.Key.isDown (hxd.Key.A)) dx = -realSpeed * dt;
        if (hxd.Key.isDown (hxd.Key.D)) dx = realSpeed * dt;

        if (hxd.Key.isPressed (hxd.Key.SPACE)) {
            placeBomb ();
        }

        if ((dx < 0.001 && dx > -0.001) && (dy < 0.001 && dy > -0.001)) {
            playAnimation ();
            return;            
        }
        
        wasBombCollide = false;
        if (placedBomb != null) {
            var entArr = level.getEntity (model.x, model.y);
            if (entArr != null) {
                for (e in entArr) {
                    if (e == placedBomb) wasBombCollide = true;
                }
            }
        }
        if (!wasBombCollide) placedBomb = null;

        move (dx, dy);
    }

    /**
     *  On collision
     *  @param cols - 
     */
    function onCollision (cols : Array<CollisionInfo>) : Void {
        for (c in cols) {
            if (c.entities != null) {
                for (ent in c.entities) {
                    if (Std.is (ent, PowerUp)) {
                        ent.onHit ();
                        gameScreen.onPowerUp (cast ent);
                    }
                }
            }
        }
    }

    /**
     *  Play animation
     */
    function playAnimation () : Void {
        if (isRunning && currentAnimation != runAnimation) {
            model.playAnimation (runAnimation);
            currentAnimation = runAnimation;
        } else if (!isRunning && currentAnimation != idleAnimation) {
            model.playAnimation (idleAnimation);
            currentAnimation = idleAnimation;
        }
    }

    /**
     *  Constructor
     */
    public function new  () {
        super ();

        runAnimation = ctx.assets.getAnimation(Assets.run_forward_inPlace_hmd);
        idleAnimation = ctx.assets.getAnimation(Assets.happy_idle_hmd);

        model = ctx.assets.getObject(Assets.charWork_hmd);
        model.scale (0.05);                
        reset ();

        ctx.dispatcher.addHandler (settings.PlayerSettings.SPEED, function (e) {
            realSpeed += (speedFactor / 3);
        });
    }

    /**
     *  Reset player data
     */
    override public function reset () : Void {
        isRunning = false;
        placedCount = 0;
        placedBomb = null;
        wasBombCollide = false;
        isDisposed = false;

        realSpeed = speedFactor;
        
        setOnFilterCollision (onFilterCollision);
        setOnCollision (onCollision);
        setOnMoveComplete (onMoveComplete);
        setOnUpdate (onUpdate);
    }

    /**
     *  On entity hit, by bombs or something else
     */
    override public function onHit () : Void {
        gameScreen.onPlayerDied ();
        level.removeEntity (this);
    }
}