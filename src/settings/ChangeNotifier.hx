package settings;

/**
 *  Handler to notify changes
 */
typedef ChangeHandler = String -> Dynamic -> Void;

/**
 *  Object that notify about changes
 */
@:autoBuild(settings.NotifierMacro.build())
class ChangeNotifier {

    /**
     *  Handlers to notify changes
     */
    var handlers : Array<ChangeHandler>;

    /**
     *  Constructor
     */
    public function new () {
        handlers = new Array<ChangeHandler> ();
    }

    /**
     *  Notify about change
     *  @param name - 
     *  @param value - 
     */
    public function notify (name : String, value : Dynamic) : Void {
        for (h in handlers) {
            h (name, value);
        }
    }

    /**
     *  Add handler for change notify
     *  @param call - 
     */
    public function addHandler (call : ChangeHandler) : Void {
        handlers.push (call);
    }

    /**
     *  Remove handler
     *  @param call - 
     */
    public function removeHandler (call : ChangeHandler) : Void {
        handlers.remove (call);
    }
}