package stx.arw;

typedef ProvideDef<O,E> = ArrowletDef<Noise,Chunk<O,E>,Noise>;

@:using(stx.arw.Provide.ProvideLift)
abstract Provide<O,E>(ProvideDef<O,E>) from ProvideDef<O,E> to ProvideDef<O,E>{
  static public var _(default,never) = ProvideLift;
  public function new(self) this = self;
  @:noUsing static public function lift<O,E>(self:ProvideDef<O,E>):Provide<O,E> return new Provide(self);
    
  @:noUsing static public function fromChunk<O,E>(chunk:Chunk<O,E>):Provide<O,E>{
    return lift(Arrowlet.pure(chunk));
  }
  @:noUsing static public function pure<O,E>(o:O):Provide<O,E>{
    return fromChunk(Val(o));
  }
  @:noUsing static public function fromErr<O,E>(e:Err<E>):Provide<O,E>{
    return fromChunk(End(e));
  }
  @:noUsing static public function unit<O,E>():Provide<O,E>{
    return lift(Arrowlet.pure(Tap));
  }
  @:from @:noUsing static public function fromChunkThunk<O,E>(thunk:Thunk<Chunk<O,E>>):Provide<O,E>{
    return lift(
      Arrowlet.Sync(
        (_:Noise) -> thunk()
      )
    );
  }
  public function toArrowlet():Arrowlet<Noise,Chunk<O,E>,Noise>{
    return this;
  }
  public function elide():Provide<Any,E>{
    return cast this;
  }
  private var self(get,never):Provide<O,E>;
  private function get_self():Provide<O,E> return lift(this);
}
class ProvideLift{
  static public function flat_map<O,Oi,E>(self:Provide<O,E>,fn:O->ProvideDef<Oi,E>):Provide<Oi,E>{
    return Provide.lift(Arrowlet.FlatMap(self.toArrowlet(),
      (chunk:Chunk<O,E>) -> 
        chunk.fold(
          (o) -> fn(o),
          (e) -> Provide.fromChunk(End(e)),
          ()  -> Provide.fromChunk(Tap)
        )
    ));
  }
  static public function process<O,Oi,E>(self:Provide<O,E>,next:Process<O,Oi>):Provide<Oi,E>{
    return Provide.lift(Arrowlet.Then(
      self,
      Arrowlet.Anon(
        (ipt:Chunk<O,E>,cont:Terminal<Chunk<Oi,E>,Noise>) -> ipt.fold(
          (o) -> next.then(Val).prepare(o,cont),
          (e) -> cont.value(End(e)).serve(),
          ()  -> cont.value(Tap).serve()
        )
      )
    ));
  }
  static public function attempt<O,Oi,E>(self:Provide<O,E>,next:Attempt<O,Oi,E>):Provide<Oi,E>{
    return Provide.lift(Arrowlet.Then(
      self,
      Arrowlet.Anon(
        (ipt:Chunk<O,E>,cont:Terminal<Chunk<Oi,E>,Noise>) -> ipt.fold(
          (o) -> next.toArrowlet().postfix((res:Res<Oi,E>) -> res.toChunk()).prepare(o,cont),
          (e) -> cont.value(End(e)).serve(),
          ()  -> cont.value(Tap).serve()
        )
      )
    ));
  }
}