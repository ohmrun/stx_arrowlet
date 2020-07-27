package stx.arw.body.js;

abstract Event1<O>(Arrowlet<EventTarget,O>){
  public function new(event:String){
    this = new Arrowlet(
      function withInput(?i: EventTarget, cont : Dynamic -> Void){
        var cancel    = null;
        var listener  =
          function(x:Dynamic){
            //trace('call: $event');
            cancel();
            cont(x);
          }
        cancel =
          function(){
            i.removeEventListener(event,listener);
          };
        i.addEventListener(
          event,
          listener
        );
      }
    );
  }
}