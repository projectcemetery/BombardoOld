package ent;

import loader.Assets;

/**
 *  Explosion from bomb
 */
class Explosion extends StaticEntity {   

    /**
     *  Particles
     */
    var parts : h3d.parts.GpuParticles;

	/**
	 *  Particle group
	 */
	var group : h3d.parts.GpuParticles.GpuPartGroup;

    /**
     *  Player mesh
     */
    var mesh : h3d.scene.Mesh;

    /**
     *  Create particle emitter
     */
    function createEmitter () : Void {
        parts = new h3d.parts.GpuParticles(model);
        parts.visible = false;

        var material = new h3d.mat.Material();
		material.mainPass.culling = None;
		material.mainPass.depthWrite = false;
		material.blendMode = Add;
        material.color = new h3d.Vector (0.5, 0.1, 0.5, 1);

        var g = new h3d.parts.GpuParticles.GpuPartGroup(parts);        
        g.texture = ctx.assets.getTexture (Assets.explosionpart_png);
        g.emitMode = ParentBounds;
        g.emitDist = 0;

		g.fadeIn = 0.1;
		g.fadeOut = 0.4;		
		g.size = 0.6;
		g.sizeRand = 2;		

		g.speed = 0.9;
		g.speedRand = 0.5;

		g.life = 0.3;
		g.lifeRand = 1;
		g.nparts = 1000;
        group = g;
        parts.addGroup (g, material);
    }

    /**
     *  Constructor
     */
    public function new () {
        super ();

        var cube = new h3d.prim.Cube (1.0, 1.0, 1.0);
        cube.translate (-0.5,-0.5,-0.5);
        mesh = new h3d.scene.Mesh (cube);                
        mesh.culled = true;
        model = mesh;
        isObstacle = false;

        createEmitter ();
    }

    /**
     *  Start work
     */
    public function startTimer () : Void {
        parts.visible = true;
        parts.x = model.x;
        parts.y = model.y;
        parts.z = 1;

        var lifetime = ctx.settings.player.boomTime;
        ctx.waitEvent.wait (lifetime, function () {
            level.removeEntity (this);
        });
    }
}