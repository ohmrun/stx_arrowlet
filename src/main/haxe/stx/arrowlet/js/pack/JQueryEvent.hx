package stx.arrowlet.js;

using stx.arrowlet;
using stx.Tuple;

#if (!nodejs && js)
import js.jquery.Event in JqEvent;
import js.jquery.JQuery in TJQuery;


@:callable abstract JQueryEvent(Arrowlet<String,JqEvent>) from Arrowlet<String,JqEvent> to Arrowlet<String,JqEvent>{
  public function new(j:js.jquery.JQuery){
    this =
      function withInput(?i: String, cont : JqEvent -> Void){
        var cancel    = null;
        var listener  =
          function(x:js.jquery.Event){
            //trace('call: $event');
            cont(x);
          };
        j.one(
          i,
          listener
        );
        return function(){};
      }
  }
}
#end
