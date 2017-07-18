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
     *  Text for score
     */
    var scoreTxt : h2d.Text;

    /**
     *  Bomb count text
     */
    var bombCountTxt : h2d.Text;

    /**
     *  Boom length text
     */
    var boomTxt : h2d.Text;

    /**
     *  Player speed text
     */
    var speedTxt : h2d.Text;

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
     *  Set player bomb count text
     *  @param v - 
     */
    function setBombCount (v : Int) : Void {
        bombCountTxt.text = Std.string (v);
    }

    /**
     *  Set player bomb boom length
     *  @param v - 
     */
    function setBoomLength (v : Int) : Void {
        boomTxt.text = Std.string (v);
    }

    /**
     *  Set player speed text
     *  @param v - 
     */
    function setSpeed (v : Int) : Void {
        speedTxt.text = Std.string (v);
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

        ctx = GameContext.get ();

        var font = hxd.Res.trueTypeFont.build(24);
        
        // Bomb
        var bombTile = hxd.Res.hbomb.toTile();
        var bombImage = new h2d.Bitmap(bombTile, this);

        bombCountTxt = new h2d.Text(font, bombImage);
		bombCountTxt.textColor = 0x000000;
        bombCountTxt.x = bombImage.getSize ().xMax - 24;        
        bombCountTxt.y = 5;
        bombCountTxt.text = Std.string (ctx.settings.player.maxBombCount);

        // Explosion
        var explosionTile = hxd.Res.hexplosion.toTile();
        var explosionImage = new h2d.Bitmap(explosionTile, this);
        explosionImage.x = bombImage.getBounds ().xMax + spacing;

        boomTxt = new h2d.Text(font, explosionImage);		
		boomTxt.textColor = 0x000000;
        boomTxt.x = explosionImage.getSize ().xMax - 24;        
        boomTxt.y = 5;
        boomTxt.text = Std.string (ctx.settings.player.boomLength);

        // Speed
        var speedTile = hxd.Res.hspeed.toTile ();
        var speedImage = new h2d.Bitmap(speedTile, this);
        speedImage.x = explosionImage.getBounds ().xMax + spacing;

        speedTxt = new h2d.Text(font, speedImage);
        speedTxt.textColor = 0x000000;
        speedTxt.x = speedImage.getSize ().xMax - 20;
        speedTxt.y = 5;
        speedTxt.text = Std.string (ctx.settings.player.speed);

        // Score
        var scoreTile = hxd.Res.hscores.toTile();
        var scoreImage = new h2d.Bitmap(scoreTile, this);
        scoreImage.x = speedImage.getBounds ().xMax + spacing;

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

        ctx.dispatcher.addHandler (settings.PlayerSettings.MAXBOMBCOUNT, function (e) {
            setBombCount (e);
        });

        ctx.dispatcher.addHandler (settings.PlayerSettings.BOOMLENGTH, function (e) {
            setBoomLength (e);
        });

        ctx.dispatcher.addHandler (settings.PlayerSettings.SPEED, function (e) {
            setSpeed (e);
        });

        ctx.waitEvent.waitUntil (onUpdate);
    }
}