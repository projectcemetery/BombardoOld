package gui;

import h2d.Scene;
import h2d.Sprite;
import h2d.Bitmap;
import h2d.col.Point;
import h2d.Font;

/**
 *  Dialog when player dies
 */
class GameOverDialog extends Sprite {

    /**
     *  Game context
     */
    var ctx : BomberApp;

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
     *  On update
     */
    function onUpdate (dt : Float) : Bool {
        if (!visible) return true;
        if (hxd.Key.isPressed (hxd.Key.MOUSE_LEFT)) {
            cursorPoint.x = ctx.s2d.mouseX;
            cursorPoint.y = ctx.s2d.mouseY;                
            if (retryButton.getBounds ().contains (cursorPoint)) {
                hide ();
            }
        }
        return false;
    }

    /**
     *  Constructor
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
        var tile = hxd.Res.gameover.toTile ();
        dialogImage = new Bitmap (tile, this);    

        var buttonTile = hxd.Res.retrybutton.toTile ();
        retryButton = new Bitmap (buttonTile, dialogImage);
        retryButton.x = (tile.width / 2) - buttonTile.width / 2;
        retryButton.y = tile.height - buttonTile.height + 10;        

        ctx.s2d.addChild (this);
        this.visible = false;        
        this.x = (ctx.s2d.width / 2) - tile.width / 2;

        cursorPoint = new Point ();        
    }

    /**
     *  Show dialog
     */
    public function show () : Void {
        if (visible) return;
        visible = true;
        ctx.waitEvent.waitUntil (onUpdate);
    }

    /**
     *  Hide dialog
     */
    public function hide () : Void {
        visible = false;
    }
}