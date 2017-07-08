package ent;

import screen.GameScreen;
import map.Level;

/**
 *  Entity that exists only in game level
 */
class LevelEntity extends Entity {

    /**
     *  Game screen
     */
    public var gameScreen (default, null) : GameScreen;

    /**
     *  Game level
     */
    public var level (default, null) : Level;

    /**
     *  Constructor
     */
    public function new () {
        super ();
        gameScreen = cast (ctx.screen, GameScreen);
        level = gameScreen.level;
    }    
}