package ent;

/**
 *  Settings for bomb
 */
typedef BombSettings = {

    /**
     *  Time before boom
     */
    var lifetime : Float;

    /**
     *  Length of explosion in map cells
     */
    var length : Int;
}