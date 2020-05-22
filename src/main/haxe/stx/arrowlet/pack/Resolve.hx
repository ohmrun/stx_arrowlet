package stx.arrowlet.pack;

typedef ResolveDef<I,E> = ArrowletDef<Err<E>,Res<I,E>,Noise>;

@:using(stx.arrowlet.pack.Resolve.ResolveLift)
abstract Resolve<I,E>(ResolveDef<I,E>) from ResolveDef<I,E> to ResolveDef<I,E>{
  public function new(self) this = self;
  static public function lift<I,E>(self:ResolveDef<I,E>):Resolve<I,E> return new Resolve(self);
  

  

  public function prj():ResolveDef<I,E> return this;
  private var self(get,never):Resolve<I,E>;
  private function get_self():Resolve<I,E> return lift(this);
  @:to public function toArrowlet():Arrowlet<Err<E>,Res<I,E>,Noise>{
    return this;
  }
}
class ResolveLift{
  static public function toCascade<I,E>(self:Resolve<I,E>):Cascade<I,I,E>{
    return Cascade.lift(
      Arrowlet.Anon(
        (i:Res<I,E>,cont:Terminal<Res<I,E>,Noise>) -> 
          i.fold(
            (s) -> cont.value(__.success(s)).serve(),
            (e) -> cont.waits(Arrowlet._.prepare(self,e,cont))
          )
      )
    );
  }
}