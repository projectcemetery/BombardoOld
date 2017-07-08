package screen;

import gui.Hud;
import gui.GameOverDialog;
import map.Level;
import ent.Player;

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
     *  On enter screen
     */
    override public function onEnter () : Void {
        level = new Level ();
        hud = new Hud ();
        gameOverDialog = new GameOverDialog ();        
        gameOverDialog.onRestart = function () {
            gameOverDialog.hide ();
            restart ();
        };
        restart ();
    }

    /**
     *  Notify that mob was killed
     */
    public function onMobKilled () : Void {
        ctx.settings.player.score += 5;
    }

    /**
     *  Notify that player died
     */
    public function onPlayerDied () : Void {
        gameOverDialog.show ();
    }
}