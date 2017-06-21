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
    var entity1 : Entity;

    /**
     *  Entity with wich collides
     */
    @:optional var entity2 : Entity;

    /**
     *  Entity which not need to check
     */
    @:optional var exceptEntity : Entity;

    /**
     *  Collision side
     */
    var side : CollideSide;

    /**
     *  Some bounds
     */
    var bounds : Bounds;

    /**
     *  Is collide
     */
    @:optional var isCollide : Bool;
}