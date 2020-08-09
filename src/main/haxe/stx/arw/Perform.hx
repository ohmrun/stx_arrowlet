package stx.arw;

typedef PerformDef = ArrowletDef<Noise,Noise,Noise>;

abstract Perform(PerformDef) from PerformDef to PerformDef{
  public function new(self) this = self;
  static public function lift(self:PerformDef):Perform return new Perform(self);
  
  
  public function toArrowlet():Arrowlet<Noise,Noise,Noise> return this;
  public function toCascade<E>():Cascade<Noise,Noise,E>{
    return Cascade.lift(
      (_:Noise,cont:Terminal<Noise,Noise>) -> {
        return this.postfix(_ -> __.accept( _)).applyII(Noise,cont);
      }
    )
  }
  public function prj():PerformDef return this;
  private var self(get,never):Perform;
  private function get_self():Perform return lift(this);
}