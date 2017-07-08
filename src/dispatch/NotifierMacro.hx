package dispatch;

import haxe.macro.Context;
import haxe.macro.Expr;

/**
 *  Build fields form ChangeNotifier child classes
 */
class NotifierMacro {                

    /**
     *  Add fields
     */
    macro public static function build():Array<Field> {        
        var fields = Context.getBuildFields();
        var className =Context.getLocalClass().toString ();
        var res = new Array<Field> ();
        var pos = Context.currentPos();

        for (f in fields) {            
            var isNotify = f.meta.filter (function (x) {
                if (x.name == ":notify") return true;
                return false;
            });

            if (isNotify.length > 0) {
                var fieldName = f.name;
                f.name = '_${fieldName}';
                f.access = [Access.APrivate];
                res.push (f);                

                var ct : Null<ComplexType> = null;
                switch (f.kind) {
                    case FVar(t, e):
                        ct = t;
                    default:
                }

                var value = macro $i{f.name};
                var getFunc:Function = {
                    expr: macro return $e{value},
                    ret: (ct),
                    args:[]
                }

                var propertyField:Field = {
                    name:  fieldName,
                    access: [Access.APublic],
                    kind: FieldType.FProp("get", "set", getFunc.ret), 
                    pos: Context.currentPos(),
                }; 

                var getterField:Field = {
                    name: "get_" + fieldName,
                    access: [Access.APrivate, Access.AInline],
                    kind: FieldType.FFun(getFunc),
                    pos: Context.currentPos(),
                };

                res.push (propertyField);
                res.push (getterField);

                var fullName = '$className.$fieldName';

                var setFunc:Function = {
                    expr: macro {
                        $e{value} = value;
                        app.GameContext.get ().dispatcher.notify ($v{fullName}, value);
                        return $e{value};
                    },
                    ret: (ct),
                    args:[{ name:'value', type:null } ]
                }

                var setterField:Field = {
                    name: "set_" + fieldName,
                    access: [Access.APrivate, Access.AInline],
                    kind: FieldType.FFun(setFunc),
                    pos: Context.currentPos(),
                };

                res.push (setterField);

                var constName = fieldName.toUpperCase ();
                var constField:Field = {
                    name: constName,
                    access: [Access.AStatic, Access.APublic, Access.AInline],
                    kind: FieldType.FVar(macro : String, macro $v{fullName}),
                    pos: Context.currentPos(),
                };
                res.push (constField);
            } else {
                res.push (f);
            }
        }

        return res;
    }
}