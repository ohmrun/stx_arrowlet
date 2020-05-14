package stx.arrowlet.pack;

typedef ProvideDef<O,E> = ArrowletDef<Noise,Chunk<O,E>,Noise>;

@:using(stx.arrowlet.pack.Provide.ProvideLift)
abstract Provide<O,E>(ProvideDef<O,E>) from ProvideDef<O,E> to ProvideDef<O,E>{
  static public var _(default,never) = ProvideLift;
  public function new(self) this = self;
  @:noUsing static public function lift<O,E>(self:ProvideDef<O,E>):Provide<O,E> return new Provide(self);
    
  @:noUsing static public function fromChunk<O,E>(chunk:Chunk<O,E>):Provide<O,E>{
    return lift(Arrowlet.pure(chunk));
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
}