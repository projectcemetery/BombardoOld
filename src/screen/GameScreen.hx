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
        ctx.settings.mobCount = 0;
        ctx.settings.player.reset ();
        level.restart ();
        player = new Player ();
        level.placePlayer (player);
    }

    /**
     *  Place powerup
     */
    function placePowerup (x : Int, y : Int) {
        var chance = Math.random () * 100;
        var typeChance = PowerUpType.createByIndex (Math.floor (Math.random () * 3));

        //if (ctx.settings.player.powerUpChance > 100 - chance) {
            var poverUp = level.recyclePowerUp (typeChance);
            level.placeEntity (x, y, poverUp);
        //}        
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
     *  When player get power up
     *  @param e - 
     */
    public function onPowerUp (e : PowerUp) : Void {
        switch (e.type) {
            case PowerUpType.Bomb:
                ctx.settings.player.maxBombCount += 1;
            case PowerUpType.Boom:
                ctx.settings.player.boomLength += 1;
            case PowerUpType.Speed:
                ctx.settings.player.speed += 1;
            default:
        }        
    }

    /**
     *  Notify that mob was killed
     */
    public function onMobKilled () : Void {
        ctx.settings.player.score += 5;
        ctx.settings.mobCount -= 1;

        if (ctx.settings.mobCount < 1) {
            gameOverDialog.setTitle ("You Win");
            level.removeEntity (player);
            gameOverDialog.show ();
        }
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
        gameOverDialog.setTitle ("Game Over");
        gameOverDialog.show ();
    }
}