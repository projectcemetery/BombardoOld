package ent;

/**
 *  Class for mob
 */
class Mob extends Entity {

    /**
     *  On player logic update
     *  @param dt - 
     */
    function onUpdate (dt : Float) : Bool {
        

        return false;
    }

    /**
     *  Constructor
     */
    public function new () {
        super ();

        waitEvent.waitUntil (onUpdate);
    }    
}