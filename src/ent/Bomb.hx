package ent;

import map.Level;
import ent.EntityFactory;

/**
 *  Bomb entity
 */
class Bomb extends StaticEntity {    

    /**
     *  Settings for bomb
     */
    var bombSettings : BombSettings;

    /**
     *  Constructor
     */
    public function new (bombSettings : BombSettings) {
        super ();
        this.bombSettings = bombSettings;        
        
        model = modelCache.loadModel(hxd.Res.bomb);
        model.rotate (0.3, 0.0, 0.0);        
        model.scale (0.003);
    }

    /**
     *  Start bomb timer
     */
    public function startTimer () : Void {
        waitEvent.wait (bombSettings.lifetime, function () {
            var wallLeft = false;
            var wallRight = false;
            var wallTop = false;
            var wallBottom = false;

            // If wall on the way then returns true
            inline function process (px : Int, py : Int) : Bool {
                if (level.isWall (px, py)) return true;
                var entity = level.getEntity (px, py);                
                if (entity != null) entity.onHit ();
                var expl = entityFactory.recycleExplosion ();
                level.placeEntity (px, py, expl);
                expl.startTimer ();
                return false;
            }

            var pos = getPos ();
            var mapPos = level.getMapPos (pos.x, pos.y);
            process (mapPos.x, mapPos.y);
            for (i in 0...bombSettings.length - 1) {
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

            level.removeEntity (this);
        });
    }
}