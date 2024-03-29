package dispatch;

/**
 *  Handler for event
 */
typedef EventHandler = Dynamic -> Void;

/**
 *  Dispatch events
 */
class Dispatcher {   

    /**
     *  Handlers to notify changes
     */
    var handlers : Map<String, Array<EventHandler>>;

    /**
     *  Constructor
     */
    public function new () {
        handlers = new Map<String, Array<EventHandler>> ();
    }

    /**
     *  Notify about event
     *  @param name - event name
     *  @param value - 
     */
    public function notify (name : String, value : Dynamic) : Void {
        var hs = handlers[name];        
        if (hs == null) return;        

        for (h in hs) {
            h (value);
        }
    }

    /**
     *  Add handler for event
     *  @param string - 
     *  @param call - 
     */
    public function addHandler (name : String, call : EventHandler) : Void {
        var hs = handlers[name];
        if (hs == null) {
            hs = new Array<EventHandler> ();
            handlers[name] = hs;
        }
        hs.push (call);
    }

    /**
     *  Remove handler
     *  @param call - 
     */
    public function removeHandler (name : String, call : EventHandler) : Void {
        var hs = handlers[name];
        if (hs == null) return;
        hs.remove (call);
    }
}