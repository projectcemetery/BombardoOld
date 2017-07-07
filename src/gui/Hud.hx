package gui;

import h2d.Scene;
import h2d.Sprite;
import h2d.Bitmap;
import h2d.Font;
import app.GameContext;

class Hud extends Gui {

    /**
     *  Space between items
     */
    var spacing : Int = 10;

    /**
     *  Image for bomb count
     */
    var bombImage : Bitmap;

    /**
     *  Image for explosion length
     */
    var explosionImage : Bitmap;

    /**
     *  Image for scores
     */
    var scoreImage : Bitmap;

    /**
     *  Text for score
     */
    var scoreTxt : h2d.Text;

    /**
     *  Bomb count that player can place
     */
    public var bombCount (default, set) : Int;    
    function set_bombCount (v : Int) : Int {
        return 0;
    }

    /**
     *  Draw call text
     */
    var drawCallTxt : h2d.Text;

    /**
     *  Triangle count
     */
    var triangleTxt : h2d.Text;

    /**
     *  FPS
     */
    var fpsTxt : h2d.Text;

    /**
     *  Is debug
     */
    var isDebug : Bool = false;
        
    /**
     *  Set player score
     *  @param v - 
     *  @return Int
     */
    function setScore (v : Int) : Void {
        scoreTxt.text = Std.string (v);
    }

    /**
     *  Show debug info
     */
    function showDebug () {
        if (isDebug) return;
        var font = hxd.Res.trueTypeFont.build(16);
        drawCallTxt = new h2d.Text(font, ctx.scene2d);		
		drawCallTxt.textColor = 0xFFFFFF;
        drawCallTxt.x = ctx.scene2d.width - 200;
        drawCallTxt.y = 10;
        drawCallTxt.text = "";
        
        triangleTxt = new h2d.Text(font, ctx.scene2d);		
		triangleTxt.textColor = 0xFFFFFF;
        triangleTxt.x = ctx.scene2d.width - 200;
        triangleTxt.y = 30;

        fpsTxt = new h2d.Text(font, ctx.scene2d);		
		fpsTxt.textColor = 0xFFFFFF;
        fpsTxt.x = ctx.scene2d.width - 200;
        fpsTxt.y = 50;

        isDebug = true;
    }

    /**
     *  On player logic update
     *  @param dt - 
     */
    function onUpdate (dt : Float) : Bool {
        if (hxd.Key.isPressed (hxd.Key.F9)) {
            showDebug ();
        }

        if (isDebug) {
            drawCallTxt.text = 'DRAW CALLS: ${ctx.engine.drawCalls}';
            triangleTxt.text = 'TRIANGLES: ${ctx.engine.drawTriangles}';
            fpsTxt.text = 'FPS: ${ctx.engine.fps}';
        }

        return false;
    }

    /**
     *  Constuctor
     */
    public function new () {
        super ();
    }

    /**
     *  On post create
     */
    public function init () {
        ctx = GameContext.get ();

        var font = hxd.Res.trueTypeFont.build(24);
        
        var bombTile = hxd.Res.hbomb.toTile();
        bombImage = new h2d.Bitmap(bombTile, this);

        var btxt = new h2d.Text(font, bombImage);		
		btxt.textColor = 0x000000;
        btxt.x = bombImage.getSize ().xMax - 24;        
        btxt.y = 5;
        btxt.text = Std.string (ctx.settings.player.maxBombCount);

        var explosionTile = hxd.Res.hexplosion.toTile();
        explosionImage = new h2d.Bitmap(explosionTile, this);
        explosionImage.x = bombImage.getBounds ().xMax + spacing;

        var etxt = new h2d.Text(font, explosionImage);		
		etxt.textColor = 0x000000;
        etxt.x = explosionImage.getSize ().xMax - 24;        
        etxt.y = 5;
        etxt.text = "2";

        var scoreTile = hxd.Res.hscores.toTile();
        scoreImage = new h2d.Bitmap(scoreTile, this);
        scoreImage.x = explosionImage.getBounds ().xMax + spacing;

        scoreTxt = new h2d.Text(font, scoreImage);
		scoreTxt.textColor = 0x000000;
        scoreTxt.x = scoreImage.getSize ().xMax - 68;        
        scoreTxt.y = 5;
        
        setScore (ctx.settings.player.score);

        this.x = 10;
        this.y = 10;
        ctx.scene2d.addChild (this);

        ctx.dispatcher.addHandler (settings.PlayerSettings.SCORE, function (e) {
            setScore (e);
        });

        ctx.waitEvent.waitUntil (onUpdate);
    }    
}