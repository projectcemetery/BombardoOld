package ent;

/**
 *  Power up
 */
class PowerUp extends StaticEntity {

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
    public function new () {
        super ();
        model = ctx.modelCache.loadModel(hxd.Res.bombpowerup2);
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