package ent;

/**
 *  Entity factory
 */
class EntityFactory {

    /**
     *  Bombs for recycle;
     */
    var bomb : Bomb;

    /**
     *  Constructor
     */
    public function new () {
        bomb = new Bomb ();
    }

    /**
     *  Recycle bomb
     *  @param x - 
     *  @param y - 
     *  @param type - 
     */
    public function recycleBomb () : Bomb {
        // TODO recycle
        return bomb;
    }
}