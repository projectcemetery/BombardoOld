package ent;

/**
 *  Entity factory
 */
class EntityFactory {

    /**
     *  Settings for bomb
     */
    public var bombSettings : BombSettings;

    /**
     *  Explosion settings
     */
    public var explosionSettings : ExplosionSettings;

    /**
     *  Bombs for recycle;
     */
    var bomb : Bomb;

    /**
     *  Constructor
     */
    public function new () {}

    /**
     *  Init after create
     */
    public function init () {
        // TODO load from file default settings

        bombSettings = {
            lifetime : 2.0,
            length : 2
        }

        explosionSettings = {
            lifetime : 1.0
        }

        bomb = new Bomb (bombSettings);
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

    /**
     *  Get explosion
     *  @return Explosion
     */
    public function recycleExplosion () : Explosion {
        // TODO recycle
        return new Explosion (explosionSettings);
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