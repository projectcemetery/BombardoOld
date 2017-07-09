package gui;

import h2d.Scene;
import h2d.Sprite;
import h2d.Bitmap;
import h2d.col.Point;
import h2d.Font;
import app.GameContext;

/**
 *  Dialog when player dies
 */
class GameOverDialog extends Sprite {

    /**
     *  Game context
     */
    var ctx : GameContext;

    /**
     *  Dialog image
     */
    var dialogImage : Bitmap;

    /**
     *  Button to retry game
     */
    var retryButton : Bitmap;    

    /**
     *  Point for cursor
     */
    var cursorPoint : Point;

    /**
     *  Text for player score
     */
    var scoreTxt : h2d.Text;

    /**
     *  Callback then restart button pressed
     */
    public var onRestart : Void -> Void;

    /**
     *  On update
     */
    function onUpdate (dt : Float) : Bool {
        if (!visible) return true;
        
        if (dialogImage.y < 0) {
            dialogImage.y += 30;
        }

        if (hxd.Key.isPressed (hxd.Key.MOUSE_LEFT)) {
            cursorPoint.x = ctx.scene2d.mouseX;
            cursorPoint.y = ctx.scene2d.mouseY;                
            if (retryButton.getBounds ().contains (cursorPoint)) {
                if (onRestart != null) onRestart ();
            }
        }
        return false;
    }

    /**
     *  Constructor
     */
    public function new () {
        super ();

        ctx = GameContext.get ();
        var font = hxd.Res.trueTypeFont.build(36);
        var tile = hxd.Res.gameover.toTile ();
        trace (tile.height);
        dialogImage = new Bitmap (tile, this);    

        scoreTxt = new h2d.Text(font, dialogImage);
		scoreTxt.textColor = 0xFFFFFF;
        scoreTxt.x = 200;
        scoreTxt.y = tile.height - 125;

        var buttonTile = hxd.Res.retrybutton.toTile ();
        retryButton = new Bitmap (buttonTile, dialogImage);
        retryButton.x = (tile.width / 2) - buttonTile.width / 2;
        retryButton.y = tile.height - buttonTile.height + 10;

        ctx.scene2d.addChild (this);
        this.visible = false;
        this.x = (ctx.scene2d.width / 2) - tile.width / 2;

        cursorPoint = new Point ();        
    }

    /**
     *  Show dialog
     */
    public function show () : Void {
        if (visible) return;
        visible = true;
        scoreTxt.text = Std.string (ctx.settings.player.score);
        ctx.waitEvent.waitUntil (onUpdate);
        var height = dialogImage.getBounds ().height;        
        dialogImage.y = -height;
    }

    /**
     *  Hide dialog
     */
    public function hide () : Void {
        visible = false;
    }
}