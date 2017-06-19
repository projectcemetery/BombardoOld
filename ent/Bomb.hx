package ent;

/**
 *  Bomb entity
 */
class Bomb extends Entity {    

    /**
     *  Constructor
     */
    public function new () {        
        var cache = BomberApp.get ().modelCache;
        model = cache.loadModel(hxd.Res.bomb);
        model.rotate (0.3, 0.0, 0.0);        
        model.scale (0.003);
    }
}