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
  @:noUsing static public function fromOption<O,E>(self:Option<O>):Provide<O,E>{
    return lift(Arrowlet.pure(self.fold((o) -> Val(o),()->Tap)));
  }
  @:noUsing static public function make<O,E>(o:Null<O>):Provide<O,E>{
    return fromChunk(__.chunk(o));
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
  @:noUsing static public function bind_fold<T,O,E>(fn:T->O->Provide<O,E>,iterable:Iterable<T>,seed:O):Option<Provide<O,E>>{
    return iterable.toIter().foldl(
      (next:T,memo:Provide<O,E>) -> Provide.lift(
        memo.toArrowlet().then(
          Arrowlet.Anon(
            (res:Chunk<O,E>,cont:Terminal<Chunk<O,E>,Noise>) -> res.fold(
              (o) -> fn(next,o).prepare(cont),
              (e) -> cont.value(End(e)).serve(),
              ()  -> cont.value(Tap).serve()
            )
          )
        )
      ),
      Provide.pure(seed)
    );
  }
  public function flat_map<Oi>(fn:O->ProvideDef<Oi,E>):Provide<Oi,E>{
    return _.flat_map(self,fn);
  }
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
  static public function exudate<O,Oi,E>(self:Provide<O,E>,next:Exudate<O,Oi,E>):Provide<Oi,E>{
    return Provide.lift(
      Arrowlet.Then(
        self,
        next.toArrowlet()
      )
    );
  }
  static public function or<O,E>(self:Provide<O,E>,or:Void->Provide<O,E>):Provide<O,E>{
    return Provide.lift(
      Arrowlet.Then(
        self,
        Arrowlet.Anon(
          (ipt:Chunk<O,E>,cont:Terminal<Chunk<O,E>,Noise>) -> ipt.fold(
            (o) -> cont.value(Val(o)).serve(),
            (e) -> cont.value(End(e)).serve(),
            ()  -> or().prepare(cont)
          )
        )
      )
    );
  }
  //static public function def<O,E>(self:Provide<O,E>,or:)
  static public function prepare<O,E>(self:Provide<O,E>,cont:Terminal<Chunk<O,E>,Noise>):Work{
    return Arrowlet._.prepare(
      Arrowlet.lift(self),
      Noise,
      cont
    );
  }
  static public function toProceed<O,E>(self:Provide<O,E>):Proceed<Option<O>,E>{
    return Proceed.lift(
      self.toArrowlet().then(
        Chunk._.fold.bind(_,
          (o) -> __.accept(Some(o)),
          (e) -> __.reject(e),
          ()  -> __.accept(None)
        )
      )
    );
  }
  static public function materialise<O,E>(self:Provide<O,E>):Provide<Option<O>,E>{
    return Provide.lift(
      Arrowlet.Then(
        self.toArrowlet(),
        Arrowlet.Sync(
          (ipt:Chunk<O,E>) -> ipt.fold(
            (o) -> Val(__.option(o)),
            (e) -> End(e),
            ()  -> Val(None)
          )
        )
      )
    );
  }
  static public function and<O,Oi,E>(self:Provide<O,E>,that:Provide<Oi,E>):Provide<Couple<O,Oi>,E>{
    return Provide.lift(
      Arrowlet.Then(
        self,
        Arrowlet.Anon(
          (ipt:Chunk<O,E>,cont:Terminal<Chunk<Couple<O,Oi>,E>,Noise>) -> ipt.fold(
            (o) -> that.process(__.couple.bind(o)).prepare(cont),
            (e) -> cont.value(End(e)).serve(),
            ()  -> cont.value(Tap).serve()
          )
        )
      )
    );
  }
  static public function command<O,E>(self:Provide<O,E>,that:Command<O,E>):Execute<E>{
    return Execute.lift(
      Arrowlet.Then(
        self,
        Arrowlet.Anon(
          (ipt:Chunk<O,E>,cont:Terminal<Report<E>,Noise>) -> ipt.fold(
            o     -> that.prepare(o,cont),
            e     -> cont.value(Report.pure(e)).serve(),
            ()    -> cont.value(Report.unit()).serve()
          )
        )
      )
    );
  }
  static public function before<O,E>(self:Provide<O,E>,fn:Void->Void):Provide<O,E>{
    return Provide.lift(
      Arrowlet.Then(
        Arrowlet.Sync(__.passthrough((_) -> fn())),
        self
      )
    );
  }
  static public function environment<O,E>(self:Provide<O,E>,success:Option<O>->Void,failure:Err<E>->Void){
    return Arrowlet._.environment(
      self.toArrowlet(),
      Noise,
      (chunk) -> chunk.fold(
        (o) -> success(Some(o)),
        (e) -> failure(e),
        ()  -> success(None)
      ),
      (e) -> throw e
    );
  }
  static public function postfix<O,Oi,E>(self:Provide<O,E>,then:O->Oi){
    return Provide.lift(
      Arrowlet.Then(
        self,
        Arrowlet.Sync(Chunk._.fold.bind(_,then.fn().then(Val),End,()->Tap))
      )
    );
  }
}