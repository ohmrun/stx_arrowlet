package stx.arw;

typedef PerformDef = ArrowletDef<Noise,Noise,Noise>;

abstract Perform(PerformDef) from PerformDef to PerformDef{
  public inline function new(self) this = self;
  static public function lift(self:PerformDef):Perform return new Perform(self);
  
  
  public function toArrowlet():Arrowlet<Noise,Noise,Noise> return this;
  public function toCascade<E>():Cascade<Noise,Noise,E>{
    return Cascade.lift(
      Arrowlet.Anon(
        (_:Res<Noise,E>,cont:Terminal<Res<Noise,E>,Noise>) -> {
          return Arrowlet._.postfix(this,(_:Noise) -> __.accept(_)).prepare(Noise,cont);
        }
      )
    );
  }
  public function prj():PerformDef return this;
  private var self(get,never):Perform;
  private function get_self():Perform return lift(this);
}