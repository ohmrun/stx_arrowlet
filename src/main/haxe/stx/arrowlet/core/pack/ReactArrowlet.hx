package stx.arrowlet.core.pack;

abstract ReactArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
  public function new(self:RecallDef<I,O,Void>){
    this = __.arw().cont(method.bind(self));
  } 
  static function method<I,O>(self:RecallDef<I,O,Void>,i:I,cont:Sink<O>):Automation{
    return Automation.inj().interim(
      self.fulfill(i).map(
        (o:O) -> {
          cont(o);
          return Automation.unit();
        }
      )
    );
  }
  static public function lift<I,O>(self:Arrowlet<I,O>):ReactArrowlet<I,O> return self;
  

  
  

  public function prj():Arrowlet<I,O> return this;
  private var self(get,never):ReactArrowlet<I,O>;
  private function get_self():ReactArrowlet<I,O> return lift(this);
}