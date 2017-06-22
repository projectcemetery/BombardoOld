package map;

import h3d.scene.Mesh;
import h3d.col.Bounds;
import col.Side;
import col.CollisionInfo;
import ent.Entity;
import ent.StaticEntity;
import ent.MovingEntity;
import ent.EntityFactory;

/**
 *  Game level
 */
class Level {
    
    /**
     *  Main 3d scene
     */
    var s3d : h3d.scene.Scene;

    /**
     *  Entity factory
     */
    var entityFactory : EntityFactory;

    /**
     *  Box for walls and floor
     */
    var box : h3d.prim.Cube;

    /**
     *  Wall material
     */
    var wallMat : h3d.mat.MeshMaterial;    

    /**
     *  Floor material
     */
    var floorMat : h3d.mat.MeshMaterial;

    /**
     *  Map width
     */
    var mapWidth : Int;

    /**
     *  Map height
     */
    var mapHeight : Int;

    /**
     *  Map for walls
     */
    var wallMap : Map<Int, Mesh> = new Map<Int, Mesh> ();

    /**
     *  Static entities that does not move from cell
     */
    var cellEntities : Map<Int, Entity> = new Map<Int, Entity> ();

    /**
     *  Moving entities
     */
    var moveEntities : Array<Entity> = new Array<Entity> ();

    /**
     *  Get mesh wall
     *  @return Mesh
     */
    function getWall (x : Int, y : Int) : Mesh {
        var pos = y * mapWidth + x;
        return wallMap[pos];
    }

    /**
     *  Add wall
     *  @param x - 
     *  @param y - 
     */
    function addWall (x : Int, y : Int) {
        var boxMesh = new h3d.scene.Mesh (box, wallMat, s3d);        
        boxMesh.setPos (x, y, 0);
        var pos = y * mapWidth + x;
        wallMap[pos] = boxMesh;
    }

    /**
     *  Add floor
     *  @param x - 
     *  @param y - 
     */

    function addFloor (x : Int, y : Int) {
        var boxMesh = new h3d.scene.Mesh (box, floorMat, s3d);
        boxMesh.setPos (x, y, -1);
    }

    /**
     *  Create level
     */
    function createLevel () {
        var tiled = hxd.Res.map1.toMap ();        
        mapWidth = tiled.width;        
        mapHeight = tiled.height;

        for (layer in tiled.layers) {
            var x = 0;
            var y = 0;

            for (dat in layer.data) {
                if (x >= mapWidth) {
                    x = 0;
                    y += 1;
                }
                
                if (dat > 0) {
                    switch (layer.name) {
                        case "Walls": addWall (x, y);
                        case "Floor": addFloor (x, y);                        
                        default:
                    }
                }   
                
                x += 1;
            }

            // Add object to map
            for (obj in layer.objects) {
                
            }
        }        
    }

    /**
     *  Place static cell entity to map
     *  @param x - 
     *  @param y - 
     *  @param entity - 
     */
    function placeCellEntity (x : Float, y : Float, entity : Entity) : Void {        
        var mapPos = getMapPos (x, y);
        var pos = mapPos.y * mapWidth + mapPos.x;
        cellEntities[pos] = entity;
        s3d.addChild (entity.model);
        entity.setPos (mapPos.x + 0.5, mapPos.y + 0.5);
    }

    /**
     *  Remove entity from map
     *  @param entity - 
     */
    function removeCellEntity (entity : Entity) {
        var ps = entity.getPos ();
        var mapPos = getMapPos (ps.x, ps.y);
        var pos = mapPos.y * mapWidth + mapPos.x;
        cellEntities.remove (pos);
        s3d.removeChild (entity.model);
    }

    /**
     *  Return entity from map, by map cell position
     *  return null if not exists
     *  @param x - 
     *  @param y - 
     *  @return Entity
     */
    function getCellEntity (x : Int, y : Int) : Entity {
        var pos = y * mapWidth + x;
        return cellEntities[pos];
    }

    /**
     *  Place moving entity
     *  @param x - 
     *  @param y - 
     *  @param entity - 
     */
    function placeMoveEntity (x : Float, y : Float, entity : Entity) : Void {
        var mapPos = getMapPos (x, y);
        entity.setPos (mapPos.x + 0.5, mapPos.y + 0.5);
        s3d.addChild (entity.model);
        moveEntities.push (entity);
    }

    /**
     *  Remove moving entity
     *  @param entity - 
     */
    function removeMoveEntity (entity : Entity) : Void {
        moveEntities.remove (entity);
        s3d.removeChild (entity.model);
    }

    /**
     *  TODO: profile collisions check
     *  
     *  Is collide with entity
     *  @param bounds - 
     *  @param side - 
     */
    function isEntityCollide (entity : Entity, bounds : Bounds, side : Side, ?except : Entity) : Entity {        
        inline function checkTopLeft () : Entity {
            var topY = Std.int (bounds.yMin);
            var leftX = Std.int (bounds.xMin);
            return getEntity (leftX, topY);            
        }

        inline function checkTopRight () : Entity {
            var topY = Std.int (bounds.yMin);
            var rightX = Std.int (bounds.xMax);
            return getEntity (rightX, topY);            
        }

        inline function checkBottomRight () : Entity {
            var bottomY = Std.int (bounds.yMax);
            var rightX = Std.int (bounds.xMax);
            return getEntity (rightX, bottomY);            
        }
        
        inline function checkBottomLeft () : Entity {
            var bottomY = Std.int (bounds.yMax);
            var leftX = Std.int (bounds.xMin);
            return getEntity (leftX, bottomY);
        }

        var ent : Entity = null;

        switch (side) {
            case Side.Top:
                ent = checkTopLeft ();
                if (ent == null) ent = checkTopRight ();
            case Side.Right:
                ent = checkTopRight ();
                if (ent == null) ent = checkBottomRight ();
            case Side.Bottom:
                ent = checkBottomRight ();
                if (ent == null) ent = checkBottomLeft ();
            case Side.Left:
                ent = checkBottomLeft ();
                if (ent == null) ent = checkTopLeft ();
            default: {}
        }

        if (except != null && ent == except) return null;
        if ((ent != null) && (ent != entity)) return ent;
        return null;
    }

    /**
     *  Check if entity collide with level from bounds side
     *  @return Bool
     */
    function isWallCollide (bounds : h3d.col.Bounds, side : Side) : Bool {

        inline function checkCollide (m :Mesh) : Bool {
            var bou = m.getBounds ();
            return bounds.collide (bou);
        }

        inline function checkTopLeft () : Bool {            
            var topY = Std.int (bounds.yMin);
            var leftX = Std.int (bounds.xMin);
            var wallMesh = getWall (leftX, topY);
            if (wallMesh != null) return checkCollide (wallMesh);
            return false;
        }

        inline function checkTopRight () : Bool {
            var topY = Std.int (bounds.yMin);
            var rightX = Std.int (bounds.xMax);
            var wallMesh = getWall (rightX, topY);
            if (wallMesh != null) return checkCollide (wallMesh);
            return false;
        }

        inline function checkBottomLeft () : Bool {
            var bottomY = Std.int (bounds.yMax);
            var leftX = Std.int (bounds.xMin);
            var wallMesh = getWall (leftX, bottomY);
            if (wallMesh != null) return checkCollide (wallMesh);
            return false;
        }

        inline function checkBottomRight () : Bool {
            var bottomY = Std.int (bounds.yMax);
            var rightX = Std.int (bounds.xMax);
            var wallMesh = getWall (rightX, bottomY);
            if (wallMesh != null) return checkCollide (wallMesh);
            return false;
        }

        // Check top
        if (side == Side.Top) {
            // Check left top
            if (checkTopLeft () || checkTopRight ()) return true;
        } 
        // Check left
        else if (side == Side.Left) {
            if (checkTopLeft () || checkBottomLeft ()) return true;
        }
        // Check right
        else if (side == Side.Right) {
            if (checkTopRight () || checkBottomRight ()) return true;
        }
        // Check bottom
        else if (side == Side.Bottom) {
            if (checkBottomLeft () || checkBottomRight ()) return true;
        }

        return false;
    }

    /**
     *  Constructor
     */
    public function new () {}

     /**
     *  Init after create
     */
    public function init () {
        s3d = BomberApp.get ().s3d;
        entityFactory = BomberApp.get ().entityFactory;

        box = new h3d.prim.Cube (1.0, 1.0, 1.0);
        //box.translate (-0.5, -0.5, -0.5);
        box.addNormals ();
        box.addUVs ();

        var wallTex = hxd.Res.metalbox.toTexture ();
        wallMat = new h3d.mat.MeshMaterial (wallTex);
        wallMat.mainPass.enableLights = true;
        wallMat.shadows = true;
        
        var floorTex = hxd.Res.floor.toTexture ();
        floorMat = new h3d.mat.MeshMaterial (floorTex);
        floorMat.mainPass.enableLights = true;
        floorMat.shadows = true;

        createLevel ();
        var mob = entityFactory.recicleMob ();
        placeEntity (6,1, mob);

        var mob = entityFactory.recicleMob ();
        placeEntity (7,1, mob);

        var mob = entityFactory.recicleMob ();
        placeEntity (8,1, mob);

        var mob = entityFactory.recicleMob ();
        placeEntity (9,1, mob);
    }

    /**
     *  Return map pos for object
     *  @param x - 
     *  @param y - 
     */
    public function getMapPos (x : Float, y : Float) : { x : Int, y : Int } {
        return {
            x : Math.floor (x),
            y : Math.floor (y)
        }
    }

    /**
     *  Place moving entity
     *  @param entity - 
     */
    public function placeEntity (x : Float, y : Float, entity : Entity) : Void {
        if (Std.is (entity, StaticEntity)) {
            placeCellEntity (x, y, entity);
        } else {
            placeMoveEntity (x, y, entity);
        }
    }

    /**
     *  Get entity from map
     *  @param x - 
     *  @param y - 
     *  @return Entity
     */
    public function getEntity (x : Float, y : Float) : Entity {
        var mapPos = getMapPos (x, y);
        for (e in moveEntities) {
            var ps = e.getPos ();
            var mps = getMapPos (ps.x, ps.y);

            if ((mps.x == mapPos.x) && (mps.y == mapPos.y)) return e;
        }
        
        var ce = getCellEntity (mapPos.x, mapPos.y);
        if (ce != null) return ce;

        return null;
    }

    /**
     *  Remove entity from map
     *  @param entity - 
     */
    public function removeEntity (entity : Entity) : Void {
        if (Std.is (entity, StaticEntity)) {
            removeCellEntity (entity);
        } else {
            removeMoveEntity (entity);
        }

        entity.onDispose ();
    }

    /**
     *  Check is cell is undestructable wall
     *  @param x - 
     *  @param y - 
     *  @return Bool
     */
    public function isWall (x : Float, y : Float) : Bool {
        var mapPos = getMapPos (x, y);
        if ((x < 0) || (x >= mapWidth)) return true;
        if ((y < 0) || (y >= mapHeight)) return true;
        var wall = getWall (mapPos.x, mapPos.y);
        return wall != null;
    }


    /**
     *  Check collision for array of bounds. Fills the entry info. Does not create new array
     *  @param info - 
     *  @return Array<CollisionInfo>
     */
    public function isCollide (info : Array<CollisionInfo>) : Array<CollisionInfo> {
        for (b in info) {
            if (isWallCollide (b.bounds, b.side)) {
                b.isCollide = true;
                continue;
            }

            var ent = isEntityCollide (b.entity1, b.bounds, b.side, b.exceptEntity);

            if (ent != null) {
                b.entity2 = ent;
                b.isCollide = true;
            }
        }
        return info;
    }
}