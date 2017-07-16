package ent;

/**
 *  Power up type
 */
enum PowerUpType {

    /**
     *  Bomb count
     */
    Bomb;

    /**
     *  Boom lenght
     */
    Boom;

    /**
     *  Player speed
     */
    Speed;
}

/**
 *  Power up
 */
class PowerUp extends StaticEntity {

    /**
     *  Power up type
     */
    public var type : PowerUpType;

    /**
     *  On update
     *  @param dt - 
     */
    function onUpdate (dt : Float) : Void {
        model.rotate (0.0, 0.0, -0.025);
    }

    /**
     *  Constructor
     */
    public function new (type : PowerUpType) {
        super ();

        this.type = type;

        switch (type) {
            case PowerUpType.Bomb:
                model = ctx.modelCache.loadModel(hxd.Res.bombpowerup2);
            case PowerUpType.Boom:
                model = ctx.modelCache.loadModel(hxd.Res.boompowerup);
            case PowerUpType.Speed:
                model = ctx.modelCache.loadModel(hxd.Res.speedpowerup);
            default:
        }        

        model.scale (0.005);
        model.setPos (0, 0, 0.25);

        setOnUpdate (onUpdate);
    }

    /**
     *  On entity hit, by bombs or something else
     */
    override public function onHit () : Void {
        level.removeEntity (this);
    }
}