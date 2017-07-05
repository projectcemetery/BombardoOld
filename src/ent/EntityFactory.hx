package ent;

/**
 *  Entity factory
 */
class EntityFactory {

    /**
     *  Constructor
     */
    public function new () {}

    /**
     *  Init after create
     */
    public function init () {  
        // Preload
        new Bomb ();      
    }

    /**
     *  Recycle bomb
     *  @param x - 
     *  @param y - 
     *  @param type - 
     */
    public function recycleBomb () : Bomb {
        // TODO recycle
        return new Bomb ();
    }

    /**
     *  Get explosion
     *  @return Explosion
     */
    public function recycleExplosion () : Explosion {
        // TODO recycle
        return new Explosion ();
    }

    /**
     *  Get mob
     *  @return Mob
     */
    public function recicleMob () : Mob {
        // TODO recicle
        return new Mob ();
    }

    /**
     *  Get DestructableWall
     *  @return DestructableWall
     */
    public function recycleDestructableWall () : DestructableWall {
        return new DestructableWall ();
    }   
}