package loader;

import js.html.XMLHttpRequestResponseType;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.zip.Reader;
import haxe.zip.Entry;
import h3d.scene.Object;
import h3d.anim.Animation;
import h3d.mat.Texture;
import hxd.res.Loader;
import hxd.res.Font;
import hxd.res.Model;
import hxd.res.TiledMap;
import h2d.Tile;

/**
 *  Manage assets
 */
@:build(loader.FileTree.build())
class Assets {

    /**
     *  On assets loaded
     */
    public var onLoaded : Void -> Void;

    /**
     *  On pack loaded
     *  @param entries - 
     */
    function onLoad (entries : List<Entry>) : Void {        
        var root = new MemoryFolder ("root", null);
        var fs = new MemoryFileSystem (root);            

        for (e in entries) {
            var fl = new MemoryFile (e.fileName, e.data, root);
            root.childs.push (fl);
        }
        
        trace ("ASSETS LOAD");
        // Override current loader
        hxd.res.Loader.currentInstance = new hxd.res.Loader (fs);        
        if (onLoaded != null) {            
            onLoaded ();
        }
    }    

    /**
     *  Constructor
     */
    public function new () {
    }    

    /**
     *  Load package from server
     */
    public function loadPack (name : String) : Void {
        // Trying to cache pack from loader
        var dat = untyped js.Browser.document.packCache;
        var packName = "";
        var data : Dynamic = null;
        if (dat != null) {
            packName = untyped dat.name;
            data = untyped dat.data;
        }

        if (name == packName && data != null) {
            var dat = Bytes.ofData (data);
            var entries = Reader.readZip(new BytesInput (dat));            
            onLoad (entries);
        } else {
            var req = js.Browser.createXMLHttpRequest ();
            req.onloadend = function (e) {
                var dat = Bytes.ofData (req.response);
                var entries = Reader.readZip(new BytesInput (dat));
                onLoad (entries);
            };

            req.responseType = XMLHttpRequestResponseType.ARRAYBUFFER;
            req.open ("GET", name);
            req.send ();
        }        
    }
    
    /**
     *  Get texture
     *  @param name - 
     *  @return Texture
     */
    public function getTile (name : String) : Tile {
        var nm = name.split ("/").pop ();
        return Loader.currentInstance.load (nm).toTile ();
    }

    /**
     *  Get texture
     *  @param name - 
     *  @return Texture
     */
    public function getTexture (name : String) : Texture {
        var nm = name.split ("/").pop ();
        return Loader.currentInstance.load (nm).toTexture ();
    }

    /**
     *  Get animation
     *  @param name - 
     *  @return Animation
     */
    public function getAnimation (name : String) : Animation {
        var nm = name.split ("/").pop ();
        var tm = Loader.currentInstance.load (nm).toHmd ();
        return tm.loadAnimation ();
    }

    public function getModel (name : String) : Model {
        var nm = name.split ("/").pop ();
        return Loader.currentInstance.load (nm).toModel ();        
    }

    /**
     *  Get model object
     *  @param name - 
     *  @return Object
     */
    public function getObject (name : String) : Object {
        var nm = name.split ("/").pop ();
        var tm = Loader.currentInstance.load (nm).toHmd ();
        var obj = tm.makeObject (getTexture);
        return obj;
    }


    /**
     *  Get font
     *  @param name - 
     *  @return hxd.res.Font
     */
    public function getFont (name : String) : Font {
        trace (name);
        var nm = name.split ("/").pop ();
        return Loader.currentInstance.load (nm).toFont ();
    }

    /**
     *  Get tiled map
     *  @param name - 
     *  @return TiledMap
     */
    public function getMap (name : String) : TiledMapData {
        var nm = name.split ("/").pop ();
        return Loader.currentInstance.load (nm).toTiledMap ().toMap ();
    }
}