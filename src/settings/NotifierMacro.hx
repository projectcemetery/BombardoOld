package settings;

import haxe.macro.Context;
import haxe.macro.Expr;

/**
 *  Build fields form ChangeNotifier child classes
 */
class NotifierMacro {            

    #if macro

    /**
     *  Add fields
     */
    macro public static function build () : Array<Field>  {
        var fields = Context.getBuildFields();
        var res = new Array<Field> ();                 

        for (f in fields) {
            var isNotify = f.meta.filter (function (x) {
                if (x.name == ":notify") return true;
                return false;
            });
            if (isNotify.length > 0) {                
                var getFunc:Function = {
                    expr: macro return 1,  // actual value
                    ret: (macro: Int), // ret = return type
                    args:[] // no arguments here
                } 

                var getterField:Field = {
                    name: "get" + f.name.substr(0,1).toUpperCase () + f.name.substr (1, f.name.length-1),
                    access: [Access.APublic, Access.AInline],
                    kind: FieldType.FFun(getFunc),
                    pos: Context.currentPos (),
                };
                res.push (getterField);
            } else {
                res.push (f);
            }
        }

        return res;
    }

    #end
}