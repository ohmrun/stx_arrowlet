package stx.arrowlet.pack;

typedef ForwardDef<O> = ProcessDef<Noise,O>;

abstract Forward<O>(ForwardDef<O>) from ForwardDef<O> to ForwardDef<O>{
  public function new(self) this = self;
  static public function lift<O>(self:ForwardDef<O>):Forward<O> return new Forward(self);
  
  @:from static public function fromFunXR<O>(fn:Void->O):Forward<O>{
    return lift(
      Arrowlet.Anon(
        (i:Noise,cont:Terminal<O,Noise>) -> {
          return cont.value(fn()).serve();
        }
      )
    );
  }
  @:from static public function fromFunXFuture<O>(fn:Void->Future<O>):Forward<O>{
    return lift(
      Arrowlet.Anon(
        (i:Noise,cont:Terminal<O,Noise>) -> {
          var defer = Future.trigger();
          fn().map(Success).handle(defer.trigger);
          return cont.defer(defer).serve();
        }
      )
    );
  }
  @:to public function toArrowlet():Arrowlet<Noise,O,Noise>{
    return this;
  }
  public function prj():ForwardDef<O> return this;
  private var self(get,never):Forward<O>;
  private function get_self():Forward<O> return lift(this);
}