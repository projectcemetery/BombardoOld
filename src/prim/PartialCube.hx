package prim;

import h3d.prim.UV;
import h3d.col.Point;
import hxd.IndexBuffer;

/**
 *  Constructor of cube with hidden sides
 */
class PartialCube {

    /**
     *  Current index for idx
     */
    var index : Int = 0;

    /**
     *  UVs
     */
    var uvs : Array<UV>;

    /**
     *  Hidden sides
     */
    var sides : Map<CubeSide, CubeSideInfo>;

    /**
     *  Cube size
     */
    var size : Int; 

    /**
     *  Textures count
     */
    var texCount : Int; 

    /**
     *  Buffer
     */
    public var buffer (default, null) : hxd.FloatBuffer;

    /**
     *  Indexes
     */
    public var idx (default, null) : IndexBuffer;  

    /**
     *  Get poings for top
     *  @return Array<Point>
     */
    function getTop () : Array<Point> {
        return [
            new Point(0, 0, 0),
            new Point(size, 0, 0),
            new Point(size, size, 0),
            new Point(0, size, 0)
        ];
    }

    /**
     *  Get poings for left
     *  @return Array<Point>
     */
    function getLeft () : Array<Point> {
        return [
            new Point(0, 0, 0),
            new Point(0, size, 0),
            new Point(0, size, size),
            new Point(0, 0, size)
        ];
    }

    /**
     *  Get poings for right
     *  @return Array<Point>
     */
    function getRight () : Array<Point> {
        return [
            new Point(size, 0, size),
            new Point(size, size, size),            
            new Point(size, size, 0),   
            new Point(size, 0, 0),         
        ];
    }

    /**
     *  Get poings for up
     *  @return Array<Point>
     */
    function getUp () : Array<Point> {
        return [
            new Point(0, 0, size),
            new Point(size, 0, size),
            new Point(size, 0, 0),
            new Point(0, 0, 0),                                 
        ];
    }

    /**
     *  Get poings for down
     *  @return Array<Point>
     */
    function getDown () : Array<Point> {
        return [
            new Point(0, size, 0),
            new Point(size, size, 0),
            new Point(size, size, size),                        
            new Point(0, size, size),            
        ];
    }

    /**
     *  Get poings for bottom
     *  @return Array<Point>
     */
    function getBottom () : Array<Point> {
        return [
            new Point(0, size, size),
            new Point(size, size, size),            
            new Point(size, 0, size),            
            new Point(0, 0, size),            
        ];
    }

    /**
     *  Add points to buffer
     *  @param points - 
     */
    function addToBuffer (points : Array<Point>, textureIndex : Int) {
        var poly = new h3d.prim.Polygon (points);
        poly.addNormals ();

        var step = 1 / texCount;
        var u1 = step * textureIndex;
        var u2 = step * textureIndex + step;

        for (i in 0...points.length) {
            var p = points[i];
            buffer.push (p.x);
            buffer.push (p.y);
            buffer.push (p.z);

            var n = poly.normals[i];
            buffer.push (n.x);
            buffer.push (n.y);
            buffer.push (n.z);

            var uv = uvs[i];
            var ux = 0.0;
            if (uv.u < 1) {
                ux = u1;
            } else {
                ux = u2;
            }
            buffer.push (ux);
            buffer.push (uv.v);
        }
    }

    /**
     *  Add indexes for side
     */
    function addIndexes (?inverted : Bool) {
        var i0 = index++;
        var i1 = index++;
        var i2 = index++;
        var i3 = index++;

        if (!inverted) {
            idx.push(i2); idx.push(i1); idx.push(i0);
            idx.push(i3); idx.push(i2); idx.push(i0);
        } else {
            idx.push(i0); idx.push(i1); idx.push(i2);
            idx.push(i0); idx.push(i2); idx.push(i3);
        }        
    }

    /**
     *  Constructor
     */
    public function new (size : Int, textureCount : Int = 1) {
        this.size = size;
        this.texCount = textureCount;

        uvs = [
            new UV (0, 0),
            new UV (1, 0),
            new UV (1, 1),
            new UV (0, 1)
        ];

        sides = new Map<CubeSide, CubeSideInfo> ();
    }

    /**
     *  Fill full cube sides
     */
    public function full () : Void {
        sides[CubeSide.STop] = { side : CubeSide.STop, textureIndex : 0, isInverted : false };
        sides[CubeSide.SBottom] = { side : CubeSide.SBottom, textureIndex : 0, isInverted : false };
        sides[CubeSide.SUp] = { side : CubeSide.SUp, textureIndex : 0, isInverted : false };
        sides[CubeSide.SLeft] = { side : CubeSide.SLeft, textureIndex : 0, isInverted : false };
        sides[CubeSide.SRight] = { side : CubeSide.SRight, textureIndex : 0, isInverted : false };
        sides[CubeSide.SDown] = { side : CubeSide.SDown, textureIndex : 0, isInverted : false };
    }

    /**
     *  Invert normals for all sides
     */
    public function invert () : Void {
        for (s in sides) {
            s.isInverted = !s.isInverted;
        }
    }

    /**
     *  Set side info
     */
    public function setSideInfo (side : CubeSide, textureIndex : Int, isInverted : Bool = false) : Void {
        sides[side] = {
            side : side,
            textureIndex : textureIndex,
            isInverted : isInverted
        };
    }

    /**
     *  Remove side info
     *  @param side - 
     */
    public function removeSideInfo (side : CubeSide) : Void {
        sides.remove (side);
    }

    /**
     *  Prepare cube
     */
    public function prepare () {
        buffer = new hxd.FloatBuffer ();        
        idx = new IndexBuffer();
        index = 0;        

        for (s in sides) {
            switch (s.side) {
                case CubeSide.STop: addToBuffer (getTop (), s.textureIndex);                    
                case CubeSide.SBottom: addToBuffer (getBottom (), s.textureIndex);
                case CubeSide.SUp: addToBuffer (getUp (), s.textureIndex);
                case CubeSide.SLeft: addToBuffer (getLeft (), s.textureIndex);
                case CubeSide.SRight: addToBuffer (getRight (), s.textureIndex);
                case CubeSide.SDown: addToBuffer (getDown (), s.textureIndex);
                default:
            }
            addIndexes (s.isInverted);
        }
    }
}