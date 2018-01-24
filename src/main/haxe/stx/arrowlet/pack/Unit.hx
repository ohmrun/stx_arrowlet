package stx.arrowlet.pack;

@:forward @:callable abstract Unit<I>(Arrowlet<I,I>) from Arrowlet<I,I> to Arrowlet<I,I>{
  public function new(){
    this = function(v:I,cont:Sink<I>){
      cont(v);
      return function(){}
    }
  }
}
