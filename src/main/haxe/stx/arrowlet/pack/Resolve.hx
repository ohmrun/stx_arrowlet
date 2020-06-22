package stx.arrowlet.pack;
        
typedef ResolveDef<I,E> = ArrowletDef<Err<E>,Chunk<I,E>,Noise>;

/**
  Chunk.Tap signifies no resolution has been found.
**/
@:using(stx.arrowlet.pack.Resolve.ResolveLift)
abstract Resolve<I,E>(ResolveDef<I,E>) from ResolveDef<I,E> to ResolveDef<I,E>{
  public function new(self) this = self;
  static public function lift<I,E>(self:ResolveDef<I,E>):Resolve<I,E> return new Resolve(self);
  
  @:from static public function fromResolveProvide<I,E>(arw:Arrowlet<Err<E>,Provide<I,E>,Noise>):Resolve<I,E>{
    return lift(
      arw.then(
        Arrowlet.Anon(
          (i:Provide<I,E>,cont:Terminal<Chunk<I,E>,Noise>) -> Arrowlet._.prepare(i.toArrowlet(),Noise,cont)
        )
      )
    );
  }
  @:from static public function fromFunErrProvide<I,E>(arw:Err<E>->Provide<I,E>):Resolve<I,E>{
    return lift(
      Arrowlet.Sync(arw).then(
        Arrowlet.Anon(
          (i:Provide<I,E>,cont:Terminal<Chunk<I,E>,Noise>) -> Arrowlet._.prepare(i.toArrowlet(),Noise,cont)
        )
      )
    );
  }
  @:noUsing static public function unit<I,E>():Resolve<I,E>{
    return lift(Arrowlet.Sync((e:Err<E>) -> Tap));
  }

  public function prj():ResolveDef<I,E> return this;
  private var self(get,never):Resolve<I,E>;
  private function get_self():Resolve<I,E> return lift(this);
  @:to public function toArrowlet():Arrowlet<Err<E>,Chunk<I,E>,Noise>{
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
            (e) -> {
              var next = Arrowlet._.then(self,
                (chk:Chunk<I,E>) -> chk.fold(
                  (i) -> __.success(i),
                  (e) -> __.failure(e),
                  ()  -> __.failure(e)//<-----
                )               
              );
              return Arrowlet._.prepare(next,e,cont);
            }
          )
      )
    );
  }
}