package stx.arrowlet.pack;

typedef ProvideDef<O> = ArrowletDef<Noise,O,Noise>;

@:using(stx.arrowlet.pack.Provide.ProvideLift)
abstract Provide<O>(ProvideDef<O>) from ProvideDef<O> to ProvideDef<O>{
  static public var _(default,never) = ProvideLift;
  public function new(self) this = self;
  static public function lift<O>(self:ProvideDef<O>):Provide<O> return new Provide(self);
  
  public function toArrowlet():Arrowlet<Noise,O,Noise>{
    return this;
  }
  private var self(get,never):Provide<O>;
  private function get_self():Provide<O> return lift(this);
}
class ProvideLift{
  static public function flat_map<O,Oi>(self:Provide<O>,fn:O->ProvideDef<Oi>):Provide<Oi>{
    return Provide.lift(Arrowlet.FlatMap(self.toArrowlet(),fn));
  }
}