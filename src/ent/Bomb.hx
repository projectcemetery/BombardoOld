package ent;

/**
 *  Bomb entity
 */
class Bomb extends StaticEntity {

    /**
     *  Particles
     */
    var parts : h3d.parts.GpuParticles;

	/**
	 *  Particle group
	 */
	var group : h3d.parts.GpuParticles.GpuPartGroup;
    
    /**
     *  Bomb is armed
     */
    var isArmed : Bool;

    /**
     *  Time for animation
     */
    var time : Float;

    /**
     *  Call back on boom
     */
    public var onBoom : Void -> Void;

    /**
     *  On logic update
     *  @param dt - 
     */
    function onUpdate (dt : Float) : Void {
        if (!isArmed) return;
        time += dt;
        if (time < 30) {
            model.scale (1.007);
        } else {
            model.scale (0.995);
        }

        if (time > 70) time = 0;
    }

    /**
     *  Create particle emitter
     */
    function createEmitter () : Void {
        parts = new h3d.parts.GpuParticles();

        var g = new h3d.parts.GpuParticles.GpuPartGroup();
        g.texture = hxd.Res.bombburn.toTexture ();
        g.emitMode = Cone;
		g.emitAngle = 0.3;
		g.emitDist = 0;

		g.fadeIn = 0.1;
		g.fadeOut = 0.4;
		g.gravity = 1;
		g.size = 0.3;
		g.sizeRand = 0.6;

		g.rotSpeed = 10;

		g.speed = 3;
		g.speedRand = 0.5;

		g.life = 0.3;
		g.lifeRand = 0.5;
		g.nparts = 100;
        group = g;
        parts.addGroup (g);
    }

    /**
     *  Explode bomb
     */
    function boom () : Void {
        level.removeEntity (this);
        var boomLength = ctx.settings.player.bombBoomLength;

        var wallLeft = false;
        var wallRight = false;
        var wallTop = false;
        var wallBottom = false;

        // If wall on the way then returns true
        inline function process (px : Int, py : Int) : Bool {
            if (level.isWall (px, py)) return true;
            var entArr = level.getEntity (px, py);
            if (entArr != null) {
                for (entity in entArr) entity.onHit ();
            }
            var expl = level.recycleExplosion ();
            level.placeEntity (px, py, expl);
            expl.startTimer ();
            return false;
        }

        var pos = getPos ();
        var mapPos = level.getMapPos (pos.x, pos.y);
        process (mapPos.x, mapPos.y);
        for (i in 0...boomLength - 1) {
            var x = mapPos.x + (i + 1);
            var y = mapPos.y;
            if (!wallRight) wallRight = process (x, y);

            x = mapPos.x - (i + 1);
            y = mapPos.y;
            if (!wallLeft) wallLeft = process (x, y);

            x = mapPos.x;
            y = mapPos.y + (i + 1);
            if (!wallBottom) wallBottom = process (x, y);

            x = mapPos.x;
            y = mapPos.y - (i + 1);
            if (!wallTop) wallTop = process (x, y);
        }

        if (onBoom != null) onBoom ();        
    }

    /**
     *  Constructor
     */
    public function new () {
        super ();
        
        model = ctx.modelCache.loadModel(hxd.Res.bomb);
        model.rotate (0.3, 0.0, 0.0);        
        model.scale (0.003);
        time = 0;        
        createEmitter ();
    }

    /**
     *  Start bomb timer
     */
    public function startTimer () : Void {        
        ctx.scene3d.addChild (parts);
        setOnUpdate (onUpdate);
        isArmed = true;
        parts.x = model.x + 0.01;
        parts.y = model.y - 0.08;
        parts.z = 1.1;        

        var lifetime = ctx.settings.player.beforeBoom;        

        ctx.waitEvent.wait (lifetime, function () {
            boom ();
        });
    }

    /**
     *  Dispose bomb
     */
    override public function onDispose () : Void {
        super.onDispose ();
        if (parts != null) {
            ctx.scene3d.removeChild (parts);
        }
    }

    /**
     *  On entity hit, by bombs or something else
     */
    override public function onHit () : Void {        
        boom ();
    }
}