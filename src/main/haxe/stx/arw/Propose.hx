package stx.arw;

typedef ProposeDef<O,E> = ArrowletDef<Noise,Chunk<O,E>,Noise>;

@:using(stx.arw.Propose.ProposeLift)
abstract Propose<O,E>(ProposeDef<O,E>) from ProposeDef<O,E> to ProposeDef<O,E>{
  static public var _(default,never) = ProposeLift;
  public function new(self) this = self;
  @:noUsing static public function lift<O,E>(self:ProposeDef<O,E>):Propose<O,E> return new Propose(self);
    
  @:noUsing static public function fromChunk<O,E>(chunk:Chunk<O,E>):Propose<O,E>{
    return lift(Arrowlet.pure(chunk));
  }
  @:noUsing static public function fromOption<O,E>(self:Option<O>):Propose<O,E>{
    return lift(Arrowlet.pure(self.fold((o) -> Val(o),()->Tap)));
  }
  @:noUsing static public function make<O,E>(o:Null<O>):Propose<O,E>{
    return fromChunk(__.chunk(o));
  }
  @:noUsing static public function pure<O,E>(o:O):Propose<O,E>{
    return fromChunk(Val(o));
  }
  @:noUsing static public function fromErr<O,E>(e:Err<E>):Propose<O,E>{
    return fromChunk(End(e));
  }
  @:noUsing static public function unit<O,E>():Propose<O,E>{
    return lift(Arrowlet.pure(Tap));
  }
  @:from @:noUsing static public function fromChunkThunk<O,E>(thunk:Thunk<Chunk<O,E>>):Propose<O,E>{
    return lift(
      Arrowlet.Sync(
        (_:Noise) -> thunk()
      )
    );
  }
  public function toArrowlet():Arrowlet<Noise,Chunk<O,E>,Noise>{
    return this;
  }
  public function elide():Propose<Any,E>{
    return cast this;
  }
  private var self(get,never):Propose<O,E>;
  private function get_self():Propose<O,E> return lift(this);
  @:noUsing static public function bind_fold<T,O,E>(fn:T->O->Propose<O,E>,iterable:Iterable<T>,seed:O):Option<Propose<O,E>>{
    return iterable.toIter().foldl(
      (next:T,memo:Propose<O,E>) -> Propose.lift(
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
      Propose.pure(seed)
    );
  }
  public function flat_map<Oi>(fn:O->ProposeDef<Oi,E>):Propose<Oi,E>{
    return _.flat_map(self,fn);
  }
}
class ProposeLift{
  static public function flat_map<O,Oi,E>(self:Propose<O,E>,fn:O->ProposeDef<Oi,E>):Propose<Oi,E>{
    return Propose.lift(Arrowlet.FlatMap(self.toArrowlet(),
      (chunk:Chunk<O,E>) -> 
        chunk.fold(
          (o) -> fn(o),
          (e) -> Propose.fromChunk(End(e)),
          ()  -> Propose.fromChunk(Tap)
        )
    ));
  }
  static public function convert<O,Oi,E>(self:Propose<O,E>,next:Convert<O,Oi>):Propose<Oi,E>{
    return Propose.lift(Arrowlet.Then(
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
  static public function attempt<O,Oi,E>(self:Propose<O,E>,next:Attempt<O,Oi,E>):Propose<Oi,E>{
    return Propose.lift(Arrowlet.Then(
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
  /*
  static public function exudate<O,Oi,E>(self:Propose<O,E>,next:Exudate<O,Oi,E>):Propose<Oi,E>{
    return Propose.lift(
      Arrowlet.Then(
        self,
        next.toArrowlet()
      )
    );
  }*/
  static public function or<O,E>(self:Propose<O,E>,or:Void->Propose<O,E>):Propose<O,E>{
    return Propose.lift(
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
  //static public function def<O,E>(self:Propose<O,E>,or:)
  static public function prepare<O,E>(self:Propose<O,E>,cont:Terminal<Chunk<O,E>,Noise>):Work{
    return Arrowlet._.prepare(
      Arrowlet.lift(self),
      Noise,
      cont
    );
  }
  static public function toProduce<O,E>(self:Propose<O,E>):Produce<Option<O>,E>{
    return Produce.lift(
      self.toArrowlet().then(
        Chunk._.fold.bind(_,
          (o) -> __.accept(Some(o)),
          (e) -> __.reject(e),
          ()  -> __.accept(None)
        )
      )
    );
  }
  static public function materialise<O,E>(self:Propose<O,E>):Propose<Option<O>,E>{
    return Propose.lift(
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
  static public function and<O,Oi,E>(self:Propose<O,E>,that:Propose<Oi,E>):Propose<Couple<O,Oi>,E>{
    return Propose.lift(
      Arrowlet.Then(
        self,
        Arrowlet.Anon(
          (ipt:Chunk<O,E>,cont:Terminal<Chunk<Couple<O,Oi>,E>,Noise>) -> ipt.fold(
            (o) -> that.convert(__.couple.bind(o)).prepare(cont),
            (e) -> cont.value(End(e)).serve(),
            ()  -> cont.value(Tap).serve()
          )
        )
      )
    );
  }
  static public function command<O,E>(self:Propose<O,E>,that:Command<O,E>):Execute<E>{
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
  static public function before<O,E>(self:Propose<O,E>,fn:Void->Void):Propose<O,E>{
    return Propose.lift(
      Arrowlet.Then(
        Arrowlet.Sync(__.passthrough((_) -> fn())),
        self
      )
    );
  }
  static public function after<O,E>(self:Propose<O,E>,fn:Chunk<O,E>->Void):Propose<O,E>{
    return Propose.lift(
      Arrowlet.Then(
        self,
        Arrowlet.Sync(__.passthrough(fn))
      )
    );
  }
  static public function environment<O,E>(self:Propose<O,E>,success:Option<O>->Void,failure:Err<E>->Void){
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
  static public function postfix<O,Oi,E>(self:Propose<O,E>,then:O->Oi){
    return Propose.lift(
      Arrowlet.Then(
        self,
        Arrowlet.Sync(Chunk._.fold.bind(_,then.fn().then(Val),End,()->Tap))
      )
    );
  }
}