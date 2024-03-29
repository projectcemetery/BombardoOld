package map;

import loader.Assets;
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
     *  Id of tower
     */
    static inline var TOWER_MAP_ID = 113;

    /**
     *  Id of wall
     */
    static inline var WALL_MAP_ID = 305;

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
     *  Level world
     */
    var world : h3d.scene.World;

    /**
     *  Wall model
     */
    var wallModel : h3d.scene.World.WorldModel;

    /**
     *  Tower model
     */
    var towerModel : h3d.scene.World.WorldModel;

    /**
     *  Floor model
     */
    var floorModel : h3d.scene.World.WorldModel;

    /**
     *  Background model
     */
    var backModel : h3d.scene.World.WorldModel;

    /**
     *  Tree model
     */
    var treeModel : h3d.scene.World.WorldModel;

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
    function addWall (id : Int, x : Int, y : Int) : Void {        
        switch (id) {
            case TOWER_MAP_ID: 
                world.add (towerModel, x + 0.5, y + 0.5, 0.0, 0.0086, 0);
            case WALL_MAP_ID: 
                world.add (wallModel, x + 0.5, y + 0.5, 0.0, 0.0086, 0);
            default: 
        }
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
        world.add (floorModel, x + 0.5, y + 0.5, 0.01, 0.005, 0);
    }

    /**
     *  Fill level background
     */
    function fillBackground () {
        var xlen = 20 + mapWidth;
        var ylen = 20 + mapHeight;

        for (x in 0...xlen) {
            for (y in 0...ylen) {
                var mx = -10 + x;
                var my = -10 + y;
                if ((mx < 1 || mx > mapWidth) || (my < 1 || my > mapHeight)) {
                    world.add (backModel, mx - 0.5 , my - 0.5, 0.01, 0.005, 0);
                }                
            }
        }

        world.add (treeModel, -3, -3, 0.0, 0.025, 0);
        world.add (treeModel, -2, 0, 0.0, 0.025, 0);
        world.add (treeModel, -3.5, 4, 0.0, 0.025, 0);
        world.add (treeModel, -1.5, 8, 0.0, 0.025, 0);

        world.add (treeModel, 17, -3, 0.0, 0.025, 0);
        world.add (treeModel, 19, 0, 0.0, 0.025, 0);
        world.add (treeModel, 17, 4, 0.0, 0.025, 0);
        world.add (treeModel, 18, 8, 0.0, 0.025, 0);

        world.add (treeModel, 2, -3, 0.0, 0.025, 0);
        world.add (treeModel, 6, -2, 0.0, 0.025, 0);
        world.add (treeModel, 9, -4, 0.0, 0.025, 0);
        world.add (treeModel, 14, -3, 0.0, 0.025, 0);

        world.add (treeModel, 2, 12, 0.0, 0.025, 0);
        world.add (treeModel, 6, 13, 0.0, 0.025, 0);
        world.add (treeModel, 9, 12, 0.0, 0.025, 0);
        world.add (treeModel, 14, 11, 0.0, 0.025, 0);
    }

    /**
     *  Create level
     */
    function createLevel () {
        var tiled = ctx.assets.getMap (Assets.map2_tmx);
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
                        case WALLS_LAYER : addWall (dat, x, y);
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

        fillBackground ();
    }

    /**
     *  Place mobs in map
     */
    function placeMobs () {
        for (p in mobSpawnPoints) {
            var mob = recicleMob ();
            placeEntity (p.x, p.y, mob);
            ctx.settings.mobCount += 1;
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
    public function recyclePowerUp (type : PowerUpType) : PowerUp {
        return new PowerUp (type);
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

        ctx.scene3d.removeChild (world);

        world = new h3d.scene.World(64, 128);
        wallModel = world.loadModel(ctx.assets.getModel (Assets.wall2_hmd));
        towerModel = world.loadModel(ctx.assets.getModel (Assets.tower1_hmd));
        floorModel = world.loadModel(ctx.assets.getModel (Assets.back1_hmd));
        backModel = world.loadModel(ctx.assets.getModel (Assets.back1_hmd));
        treeModel = world.loadModel(ctx.assets.getModel (Assets.tree1_hmd));

        createLevel ();

        world.done ();
        //world.setPos (-10, -10, -0.01);
        ctx.scene3d.addChild (world);
        
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