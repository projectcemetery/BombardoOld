package screen;

import gui.Hud;
import gui.GameOverDialog;
import map.Level;
import ent.Player;
import ent.PowerUp;

/**
 *  Game controller
 */
class GameScreen extends Screen {    

    /**
     *  Player mesh
     */
    var player : Player;

    /**
     *  Screen name
     */
    public static inline var NAME = "GameScreen";

    /**
     *  Player hud     
     */
    public var hud (default, null) : Hud;

    /**
     *  Gameover dialog
     */
    public var gameOverDialog (default, null) : GameOverDialog;

    /**
     *  Current game level
     */
    public var level (default, null) : Level;
    
    /**
     *  Restart game
     */
    function restart () : Void {
        level.restart ();
        player = new Player ();
        level.placePlayer (player);
    }

    /**
     *  Place powerup
     */
    function placePowerup (x : Int, y : Int) {
        var chance = Math.random () * 100;
        trace (chance);
        if (ctx.settings.player.powerUpChance > 100 - chance) {
            var poverUp = level.recyclePowerUp ();
            level.placeEntity (x, y, poverUp);
        }        
    }
    
    /**
     *  On enter screen
     */
    override public function onEnter () : Void {
        level = new Level ();
        hud = new Hud ();
        hud.init ();
        gameOverDialog = new GameOverDialog ();
        gameOverDialog.onRestart = function () {
            gameOverDialog.hide ();
            restart ();
        };
        restart ();
    }

    /**
     *  When player get power up
     *  @param e - 
     */
    public function onPowerUp (e : PowerUp) : Void {
        ctx.settings.player.maxBombCount += 1;
    }

    /**
     *  Notify that mob was killed
     */
    public function onMobKilled () : Void {
        ctx.settings.player.score += 5;
    }

    /**
     *  On wall destroyed
     */
    public function onWallDesctroyed (x : Int, y : Int) : Void {
        ctx.settings.player.score += 1;
        
        placePowerup (x, y);
    }

    /**
     *  Notify that player died
     */
    public function onPlayerDied () : Void {
        gameOverDialog.show ();
    }
}