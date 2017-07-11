package col;

import h3d.col.Bounds;
import ent.Entity;

/**
 *  Collision info
 */
typedef CollisionInfo = {

    /**
     *  Parent entity
     */
    var parentEntity : Entity;

    /**
     *  Entities with collide
     */
    @:optional var entities : Array<Entity>;

    /**
     *  Entity which not need to check
     */
    @:optional var exceptEntity : Entity;

    /**
     *  Collision side
     */
    var side : Side;

    /**
     *  Some bounds
     */
    var bounds : Bounds;

    /**
     *  Is collide
     */
    @:optional var isCollide : Bool;
}