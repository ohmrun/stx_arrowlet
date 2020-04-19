package stx.arrowlet.pack;

typedef ResolveDef<I,O,E>               = ArrowletDef<Res<I,E>,O,Noise>;

@:forward abstract Resolve<I,O,E>(ResolveDef<I,O,E>) from ResolveDef<I,O,E> to ResolveDef<I,O,E>{
  public function new(self){
    this = self;
  }
  static public function lift<I,O,E>(self:ResolveDef<I,O,E>){
    return new Resolve(self);
  }
  public function toCascade():Cascade<I,O,E>{
    return Cascade.lift(
      Arrowlet.lift(this).postfix(__.success)
    );
  }
  public function prj():ResolveDef<I,O,E>{
    return this;
  }
  @:to public function toArrowlet():Arrowlet<Res<I,E>,O,Noise>{
    return this;
  }
} 