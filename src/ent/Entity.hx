package ent;

import h3d.col.Point;
import h3d.col.Bounds;
import h3d.scene.Object;
import col.CollisionInfo;
import col.Side;
import app.GameContext;

/**
 *  Base entity class
 */
class Entity {

    /**
     *  Game context
     */
    var ctx : GameContext;

    /**
     *  Is entity disposed
     */
    var isDisposed : Bool = false;   

    /**
     *  Width of bounds
     */
    var boundWidth : Float;

    /**
     *  Height of bounds
     */
    var boundHeight : Float;

    /**
     *  Entity bounds
     */
    var bounds : Bounds;

    /**
     *  Internal on update
     *  @param dt - 
     *  @return Bool
     */
    var onUpdateInternal : Float -> Void;

    /**
     *  Callback for collision filter
     */
    var onFilterCollisionInternal : CollisionInfo -> Bool;

    /**
     *  Callback when all move complete and collision checked
     */
    var onMoveCompleteInternal : Float -> Float -> Void;

    /**
     *  Callback on collision
     */
    var onCollisionInternal : Array<CollisionInfo> -> Void;

    /**
     *  If true, then entity can't go through it
     */
    public var isObstacle (default, null) : Bool;

    /**
     *  Set on update
     *  @param val - 
     *  @return Float -> Void
     */
    function setOnUpdate (val : Float -> Void) : Void {
        if (onUpdateInternal == null) {
            onUpdateInternal = val;
            ctx.waitEvent.waitUntil (function (dt : Float) {
                if (isDisposed) return true;
                onUpdateInternal (dt);
                return false;
            });
        } else {
            onUpdateInternal = val;
        }
    }

    /**
     *  Set callback to filter collision
     *  @param collision - 
     */
    function setOnFilterCollision (filter : CollisionInfo -> Bool) : Void {
        onFilterCollisionInternal = filter;
    }

    /**
     *  Set callback on move complete
     *  @param call - 
     */
    function setOnMoveComplete (call : Float -> Float -> Void) : Void {
        onMoveCompleteInternal = call;
    }

    /**
     *  Set callback on collision
     *  @param call - 
     */
    function setOnCollision (call : Array<CollisionInfo> -> Void) : Void {
        onCollisionInternal = call;
    }    

    /**
     *  Constructor
     */
    public function new () {
        ctx = GameContext.get ();
        boundWidth = 0.8;
        boundHeight = 0.8;
        bounds = Bounds.fromValues (0,0,0, boundWidth, boundHeight, 1);
        isObstacle = true;
    }
        
    /**
     *  Entity model
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
    public function onDispose () : Void {
        isDisposed = true;
    }

    /**
     *  Get bounds of entity
     *  @return Bounds
     */
    public function getBounds () : Bounds {
        var pos = model.getAbsPos ();
        bounds.xMin = pos._41 - boundWidth / 2;
        bounds.xMax = bounds.xMin + boundWidth;
        bounds.yMin = pos._42 - boundHeight / 2;
        bounds.yMax = bounds.yMin + boundHeight;
        return bounds;
    }

    /**
     *  On entity hit, by bombs or something else
     */
    public function onHit () : Void {}

    /**
     *  Move entity with checking collisions
     *  @param dx - 
     *  @param dy - 
     *  TODO: refactor this
     */
    function move (dx : Float, dy : Float) : Void {
        if ((dx < 0.001 && dx > -0.001) && (dy < 0.001 && dy > -0.001)) return;

        var cols = new Array<CollisionInfo> ();        
        var bounds = getBounds ();

        // RIGHT
        if (dx > 0) {
            var b = bounds.clone ();
            b.xMax += dx;
            cols.push ({
                entity1 : this,
                side : Side.Right,
                bounds : b                
            });
        }
        // LEFT
        else if (dx < 0) {
            var b = bounds.clone ();
            b.xMin += dx;
            cols.push ({
                entity1 : this,
                side : Side.Left,
                bounds : b
            });
        }

        // BOTTOM
        if (dy > 0) {
            var b = bounds.clone ();
            b.yMax += dy;
            cols.push ({
                entity1 : this,
                side : Side.Bottom,
                bounds : b                
            });          
        } 
        // TOP
        else if (dy < 0) {
            var b = bounds.clone ();
            b.yMin += dy;
            
            cols.push ({
                entity1 : this,
                side : Side.Top,
                bounds : b,
            });
        }

        cols = ctx.level.isCollide (cols);        

        var cdx = 0.0;
        var cdy = 0.0;

        var colCompl = new Array<CollisionInfo>();
        for (c in cols) {
            // If true then collision not need check
            if (onFilterCollisionInternal != null) {
                if (onFilterCollisionInternal (c)) c.isCollide = false;
            }

            if (c.entity2 != null && c.entity2.onCollisionInternal != null) c.entity2.onCollisionInternal ([c]);

            // If no collision or entity is not obstacle
            if (!c.isCollide || (c.entity2 != null && !c.entity2.isObstacle)) {
                switch (c.side) {
                    case Side.Top: 
                        model.y += dy;
                        bounds.yMin += dy;
                        bounds.yMax += dy;
                        cdy = dy;
                    case Side.Bottom: 
                        model.y += dy;
                        bounds.yMin += dy;
                        bounds.yMax += dy;
                        cdy = dy;
                    case Side.Left: 
                        model.x += dx;
                        bounds.xMin += dx;
                        bounds.xMax += dx;
                        cdx = dx;
                    case Side.Right: 
                        model.x += dx;
                        bounds.xMin += dx;
                        bounds.xMax += dx;
                        cdx = dx;
                    default: {}
                }
            } else {
                colCompl.push (c);
            }
        }        

        if (onCollisionInternal != null) onCollisionInternal (colCompl);
        if (onMoveCompleteInternal != null) onMoveCompleteInternal (cdx, cdy);
    }
}