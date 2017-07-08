package ent;

import col.CollisionInfo;
import col.Side;

/**
 *  Entity that does not move
 */
class MovingEntity extends LevelEntity {
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

        cols = level.isCollide (cols);

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