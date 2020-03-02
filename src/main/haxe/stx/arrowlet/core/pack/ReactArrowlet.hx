package stx.arrowlet.core.pack;

abstract ReactArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
  public function new(self:Recall<I,O,Noise>){
    this = __.arw().cont()(method.bind(self));
  } 
  static function method<I,O>(self:Recall<I,O,Noise>,i:I,cont:Sink<O>):Automation{
    return Automation.inj.interim(
      self(i).toReceiver().map(
        (o) -> cont(o,Automation.unit())
      )
    );
  }
  static public function lift<I,O>(self:Arrowlet<I,O>):ReactArrowlet<I,O> return self;
  

  
  

  public function prj():Arrowlet<I,O> return this;
  private var self(get,never):ReactArrowlet<I,O>;
  private function get_self():ReactArrowlet<I,O> return lift(this);
}