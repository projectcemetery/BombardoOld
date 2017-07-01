package hud;

import h2d.Scene;
import h2d.Sprite;
import h2d.Bitmap;
import h2d.Font;

class Hud extends Sprite {

    /**
     *  Game context
     */
    var ctx : BomberApp;

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
     *  Set player score
     *  @param v - 
     *  @return Int
     */
    function setScore (v : Int) : Void {
        scoreTxt.text = Std.string (v);
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
        ctx = BomberApp.get ();

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
        ctx.s2d.addChild (this);

        ctx.dispatcher.addHandler (settings.PlayerSettings.SCORE, function (e) {
            setScore (e);
        });
    }
}