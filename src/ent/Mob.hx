package ent;

import col.Side;
import col.CollisionInfo;

/**
 *  Class for mob
 */
class Mob extends Entity {

    /**
     *  Player mesh
     */
    var mesh : h3d.scene.Mesh;

    /**
     *  Player speed
     */
    var speed : Float = 0.015;

    /**
     *  Direction of moving
     */
    var direction : Side;

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
            //trace  (Std.is (cols[0].entity1, Mob));
            direction = newDirection ();
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

        var cube = new h3d.prim.Cube (0.6, 0.6, 0.6);
        cube.translate (-0.3,-0.3,-0.3);
        mesh = new h3d.scene.Mesh (cube);
        mesh.material.color.setColor (0x1133AF);
        model = mesh;        

        setOnCollision (onCollision);
        setOnUpdate (onUpdate);
        direction = newDirection ();
    }

    /**
     *  On entity hit, by bombs or something else
     */
    override public function onHit () : Void {
        BomberApp.get ().onMobKilled ();
        level.removeEntity (this);
    }
}