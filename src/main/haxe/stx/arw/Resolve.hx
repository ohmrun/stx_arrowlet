package stx.arw;
        
typedef ResolveDef<I,E> = ArrowletDef<Err<E>,Chunk<I,E>,Noise>;

/**
  Chunk.Tap signifies no resolution has been found.
**/
@:using(stx.arw.Resolve.ResolveLift)
abstract Resolve<I,E>(ResolveDef<I,E>) from ResolveDef<I,E> to ResolveDef<I,E>{
  public inline function new(self) this = self;
  static public inline function lift<I,E>(self:ResolveDef<I,E>):Resolve<I,E> return new Resolve(self);
  
  @:from static public function fromResolvePropose<I,E>(arw:Arrowlet<Err<E>,Propose<I,E>,Noise>):Resolve<I,E>{
    return lift(
      arw.then(
        Arrowlet.Anon((i:Propose<I,E>,cont:Terminal<Chunk<I,E>,Noise>) -> Arrowlet._.prepare(i.toArrowlet(),Noise,cont))
      )
    );
  }
  @:from static public function fromFunErrPropose<I,E>(arw:Err<E>->Propose<I,E>):Resolve<I,E>{
    return lift(
      Arrowlet.ThenArw(
        arw,
        Arrowlet.Anon((i:Propose<I,E>,cont:Terminal<Chunk<I,E>,Noise>) -> Arrowlet._.prepare(i.toArrowlet(),Noise,cont))
      )
    );
  }
  @:from static public function fromErrChunk<I,E>(fn:Err<E>->Chunk<I,E>):Resolve<I,E>{
    return lift(Arrowlet.Sync(fn));
  }
  @:noUsing static public function unit<I,E>():Resolve<I,E>{
    return lift(Arrowlet.Sync((e:Err<E>) -> Tap));
  }

  public function prj():ResolveDef<I,E> return this;
  private var self(get,never):Resolve<I,E>;
  private function get_self():Resolve<I,E> return lift(this);
  @:to public inline function toArrowlet():Arrowlet<Err<E>,Chunk<I,E>,Noise>{
    return this;
  }
}
class ResolveLift{
  static public function toCascade<I,E>(self:Resolve<I,E>):Cascade<I,I,E>{
    return Cascade.lift(
      Arrowlet.Anon(
        (i:Res<I,E>,cont:Terminal<Res<I,E>,Noise>) -> 
          i.fold(
            (s) -> cont.value(__.accept(s)).serve(),
            (e) -> {
              var next = Arrowlet._.then(self,
                (chk:Chunk<I,E>) -> chk.fold(
                  (i) -> __.accept(i),
                  (e) -> __.reject(e),
                  ()  -> __.reject(e)//<-----
                )               
              );
              return Arrowlet._.prepare(next,e,cont);
            }
          )
      )
    );
  }
}