package map;

import h3d.scene.Mesh;
import h3d.col.Bounds;
import col.Side;
import col.CollisionInfo;
import h3d.col.Point;
import ent.Entity;
import ent.StaticEntity;
import ent.Player;
import prim.CubeSide;
import app.GameContext;
import ent.MovingEntity;
import ent.Bomb;
import ent.DestructableWall;
import ent.Explosion;
import ent.Mob;
import ent.PowerUp;

/**
 *  Game level
 */
class Level {
    
    /**
     *  Wall layer name
     */
    static inline var WALLS_LAYER = "Walls";

    /**
     *  Destructable wall layer name
     */
    static inline var DESTRUCTABLE_WALLS_LAYER = "DestructableWalls";

    /**
     *  Floor layer name
     */
    static inline var FLOOR_LAYER = "Floor";

    /**
     *  Mob spawn layer name
     */
    static inline var PLAYER_SPAWN_LAYER = "PlayerSpawn";

    /**
     *  Player spawn layer name
     */
    static inline var MOB_SPAWN_LAYER = "MobSpawn";    

    /**
     *  Game context
     */
    var ctx : GameContext;

    /**
     *  Box for walls and floor
     */
    var box : h3d.prim.Cube;

    /**
     *  Cube for indestructable wall
     */
    var wallCube : prim.PartialCube;

    /**
     *  Cube for floor
     */
    var floorCube : prim.PartialCube;

    /**
     *  Material for level
     */
    var levelMat : h3d.mat.MeshMaterial;

    /**
     *  Big primitive for level
     */
    var levelPrim : h3d.prim.BigPrimitive;

    /**
     *  Big mesh for level
     */
    var levelMesh : h3d.scene.Mesh;  

    /**
     *  Map width
     */
    var mapWidth : Int;

    /**
     *  Map height
     */
    var mapHeight : Int;

    /**
     *  Player spawn points
     */
    var playerSpawnPoints = new Array<Point> ();

    /**
     *  Mob spawn points
     */
    var mobSpawnPoints = new Array<Point> ();

    /**
     *  Map for walls
     */
    var wallMap = new Map<Int, Bounds> ();

    /**
     *  Static entities that does not move from cell
     */
    var cellEntities = new Map<Int, Array<Entity>> ();

    /**
     *  Moving entities
     */
    var moveEntities : Array<Entity> = new Array<Entity> ();    

    /**
     *  Get linear cell position
     *  @param x - 
     *  @param y - 
     *  @return Int
     */
    inline function getPos (x : Int, y : Int) : Int {
        return y * mapWidth + x;
    }

    /**
     *  Get mesh wall
     *  @return Mesh
     */
    function getWall (x : Int, y : Int) : Bounds {
        var pos = y * mapWidth + x;
        return wallMap[pos];
    }

    /**
     *  Add wall
     *  @param x - 
     *  @param y - 
     */
    function addWall (x : Int, y : Int) : Void {
        levelPrim.add (wallCube.buffer, wallCube.idx, x, y);
        var pos = getPos (x, y);        
        wallMap[pos] = Bounds.fromValues (x, y, 0, 1, 1, 1);
    }

    /**
     *  Add destructable wall
     *  @param x - 
     *  @param y - 
     */
    function addDestructableWall (x : Int, y : Int) : Void {
        var wall = recycleDestructableWall ();
        placeCellEntity (x, y, wall);
    }

    /**
     *  Add floor
     *  @param x - 
     *  @param y - 
     */

    function addFloor (x : Int, y : Int) {
        levelPrim.add (floorCube.buffer, floorCube.idx, x, y, -1);
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
                        case WALLS_LAYER : addWall (x, y);
                        case DESTRUCTABLE_WALLS_LAYER: addDestructableWall (x, y);
                        case FLOOR_LAYER : addFloor (x, y);
                        case PLAYER_SPAWN_LAYER: 
                            playerSpawnPoints.push (new Point (x,y));
                        case MOB_SPAWN_LAYER: 
                            mobSpawnPoints.push (new Point (x,y));
                        default:
                    }
                }   
                
                x += 1;
            }
        }
    }

    /**
     *  Place mobs in map
     */
    function placeMobs () {
        for (p in mobSpawnPoints) {
            var mob = recicleMob ();
            placeEntity (p.x, p.y, mob);
        }
    }

    /**
     *  Place static cell entity to map
     *  @param x - 
     *  @param y - 
     *  @param entity - 
     */
    function placeCellEntity (x : Float, y : Float, entity : StaticEntity) : Void {
        var mapPos = getMapPos (x, y);
        var pos = mapPos.y * mapWidth + mapPos.x;
        entity.mapX = mapPos.x;
        entity.mapY = mapPos.y;
        var entArr = cellEntities[pos];
        if (entArr == null) {
            entArr = new Array<Entity> ();
            cellEntities[pos] = entArr;
        }
        entArr.push (entity);
        ctx.scene3d.addChild (entity.model);
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
        var entArr = cellEntities[pos];
        if (entArr != null) {
            entArr.remove (entity);
            if (entArr.length < 1) cellEntities.remove (pos);
        }
        ctx.scene3d.removeChild (entity.model);
    }

    /**
     *  Return entity from map, by map cell position
     *  return null if not exists
     *  @param x - 
     *  @param y - 
     *  @return Entity
     */
    function getCellEntity (x : Int, y : Int) : Array<Entity> {
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
        ctx.scene3d.addChild (entity.model);
        moveEntities.push (entity);
    }

    /**
     *  Remove moving entity
     *  @param entity - 
     */
    function removeMoveEntity (entity : Entity) : Void {
        moveEntities.remove (entity);
        ctx.scene3d.removeChild (entity.model);
    }

    /**
     *  TODO: profile collisions check
     *  
     *  Is collide with entity
     *  @param bounds - 
     *  @param side - 
     */
    function isEntityCollide (entity : Entity, bounds : Bounds, side : Side, ?except : Entity) : Array<Entity> {        
        inline function checkTopLeft () : Array<Entity> {
            var topY = Std.int (bounds.yMin);
            var leftX = Std.int (bounds.xMin);
            return getEntity (leftX, topY);            
        }

        inline function checkTopRight () : Array<Entity> {
            var topY = Std.int (bounds.yMin);
            var rightX = Std.int (bounds.xMax);
            return getEntity (rightX, topY);            
        }

        inline function checkBottomRight () : Array<Entity> {
            var bottomY = Std.int (bounds.yMax);
            var rightX = Std.int (bounds.xMax);
            return getEntity (rightX, bottomY);            
        }
        
        inline function checkBottomLeft () : Array<Entity> {
            var bottomY = Std.int (bounds.yMax);
            var leftX = Std.int (bounds.xMin);
            return getEntity (leftX, bottomY);
        }

        var entArr : Array<Entity> = null;

        switch (side) {
            case Side.Top:
                entArr = checkTopLeft ();
                if (entArr == null) entArr = checkTopRight ();
            case Side.Right:
                entArr = checkTopRight ();
                if (entArr == null) entArr = checkBottomRight ();
            case Side.Bottom:
                entArr = checkBottomRight ();
                if (entArr == null) entArr = checkBottomLeft ();
            case Side.Left:
                entArr = checkBottomLeft ();
                if (entArr == null) entArr = checkTopLeft ();
            default: {}
        }
        if (entArr == null || entArr.length < 1) return null;
        entArr.remove (entity);
        if (except != null) entArr.remove (except);
        return if (entArr == null || entArr.length < 1) return null else return entArr;
    }

    /**
     *  Check if entity collide with level from bounds side
     *  @return Bool
     */
    function isWallCollide (bounds : h3d.col.Bounds, side : Side) : Bool {

        inline function checkCollide (m : Bounds) : Bool {
            return bounds.collide (m);
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
    public function new () {
        ctx = GameContext.get ();

        wallCube = new prim.PartialCube (1, 2);
        wallCube.full ();
        wallCube.prepare ();

        floorCube = new prim.PartialCube (1, 2);
        floorCube.setSideInfo (CubeSide.SBottom, 1);
        floorCube.prepare ();

        var levelTex = hxd.Res.level.toTexture ();
        levelMat = new h3d.mat.MeshMaterial (levelTex);
        levelMat.mainPass.enableLights = true;
        levelMat.shadows = true;
    }

    /**
     *  Recycle bomb
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

    /**
     *  Recycle powerup
     *  @return PowerUp
     */
    public function recyclePowerUp () : PowerUp {
        return new PowerUp ();
    }

     /**
     *  Init after create
     */
    public function restart () {
        // Preload
        var bomb = recycleBomb ();        
        bomb.onDispose ();

        playerSpawnPoints = new Array<Point> ();
        mobSpawnPoints = new Array<Point> ();
        wallMap = new Map<Int, Bounds> ();

        var entities = new Array<Entity> ();
        for (cells in cellEntities) {
            for (e in cells) entities.push (e);
        }
        for (e in entities) removeEntity (e);
        cellEntities = new Map<Int, Array<Entity>> ();        
                
        for (e in moveEntities) entities.push (e);
        for (e in entities) removeEntity (e);
        moveEntities = new Array<Entity> ();   

        ctx.scene3d.removeChild (levelMesh);

        levelPrim = new h3d.prim.BigPrimitive (8);
        levelMesh = new h3d.scene.Mesh (levelPrim, levelMat);

        createLevel ();
        ctx.scene3d.addChild (levelMesh);
        
        // TODO settings about mobs in player settings
        placeMobs ();
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
     *  Place player in free spawn point
     *  @param player - 
     */
    public function placePlayer (player : Player) : Void {        
        var rndIndex = Math.floor (Math.random () * playerSpawnPoints.length);
        if (rndIndex >= playerSpawnPoints.length) rndIndex = playerSpawnPoints.length - 1;
        var point = playerSpawnPoints[rndIndex];
        placeEntity (point.x, point.y, player);
        
        var to = point.clone ();
        to.z = 0;

        point.y += 13;
        point.z = 20;

        ctx.scene3d.camera.lookAt (point, to);
    }

    /**
     *  Place moving entity
     *  @param entity - 
     */
    public function placeEntity (x : Float, y : Float, entity : Entity) : Void {
        if (Std.is (entity, StaticEntity)) {
            placeCellEntity (x, y, cast entity);
        } else {
            placeMoveEntity (x, y, entity);
        }
    }

    /**
     *  Get entities from map
     *  @param x - 
     *  @param y - 
     *  @return Entity
     */
    public function getEntity (x : Float, y : Float) : Array<Entity> {
        var res = [];
        var mapPos = getMapPos (x, y);
        for (e in moveEntities) {
            var ps = e.getPos ();
            var mps = getMapPos (ps.x, ps.y);

            if ((mps.x == mapPos.x) && (mps.y == mapPos.y)) {
                res.push (e);
            }
        }
        
        var ce = getCellEntity (mapPos.x, mapPos.y);
        if (ce != null) {
            for (e in ce) res.push (e);
        }

        return if (res.length < 1) return null else return res;
    }

    /**
     *  Remove entity from map
     *  @param entity - 
     */
    public function removeEntity (entity : Entity) : Void {
        if (Std.is (entity, StaticEntity)) {
            removeCellEntity (entity);
        } else if (Std.is (entity, MovingEntity)) {            
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

            var entArr = isEntityCollide (b.parentEntity, b.bounds, b.side, b.exceptEntity);
            if (entArr != null && entArr.length > 0) {
                b.entities = entArr;
                b.isCollide = true;
            }
        }
        return info;
    }
}