package screen;

import ent.Entity;
import col.CollisionInfo;
import app.GameContext;

/**
 *  Screen controller
 */
class Screen {

    /**
     *  Game context
     */
    var ctx : GameContext;

    /**
     *  Constructor
     */
    public function new () {
        ctx = GameContext.get ();
    }

    /**
     *  On enter in screen
     */
    public function onEnter () : Void {}

    /**
     *  On leave screen
     */
    public function onLeave () : Void {}

    /**
     *  Add entity
     *  @param entity - 
     */
    public function addEntity (entity : Entity) : Void {
        ctx.scene3d.addChild (entity.model);
    }

    /**
     *  Remove entity
     *  @param entity - 
     */
    public function removeEntity (entity : Entity) : Void {
        ctx.scene3d.removeChild (entity.model);
    }
}