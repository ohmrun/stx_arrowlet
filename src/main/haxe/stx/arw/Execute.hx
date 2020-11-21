package stx.arw;

typedef ExecuteDef<E>                   = ArrowletDef<Noise,Report<E>,Noise>;

@:using(stx.arw.Execute.ExecuteLift)
abstract Execute<E>(ExecuteDef<E>) from ExecuteDef<E> to ExecuteDef<E>{
  public inline function new(self) this = self;
  @:noUsing static public inline function lift<E>(self:ExecuteDef<E>):Execute<E> return new Execute(self);
  @:noUsing static public inline function pure<E>(e:Err<E>):Execute<E> return lift(Arrowlet.pure(Report.pure(e)));
  @:noUsing static public inline function unit<E>():Execute<E> return lift(Arrowlet.pure(Report.unit()));

  @:noUsing static public function bind_fold<T,E>(fn:T->Report<E>->Execute<E>,arr:Array<T>):Execute<E>{
    return arr.lfold(
      (next:T,memo:Execute<E>) -> Execute.lift(Provide._.flat_map(
        memo,
        (report) -> lift(fn(next,report))
      )),
      unit()
    );
  }  
  @:noUsing static public function sequence<T,E>(fn:T->Execute<E>,arr:Array<T>):Execute<E>{
    return arr.lfold(
      (next:T,memo:Execute<E>) -> Execute.lift(
        memo.fold_mod(
          (report:Report<E>) -> report.fold(
            (e)-> Execute.pure(e),
            () -> fn(next)
          )
        )
      ),
      unit()
    );
  }
  @:to public function toProvide():Provide<Report<E>>{
    return this;
  }
  public inline function toArrowlet():Arrowlet<Noise,Report<E>,Noise>{
    return this;
  }
  @:from static public function fromFunXR<E>(fn:Void->Report<E>):Execute<E>{
    return lift(Arrowlet.fromFunXR(fn));
  }
  @:from static public function fromFunXExecute<E>(fn:Void->Execute<E>):Execute<E>{
    return fn();
  }
  public function prj():ExecuteDef<E> return this;
  private var self(get,never):Execute<E>;
  private function get_self():Execute<E> return lift(this);

  @:noUsing static public function fromOption<E>(err:Option<Err<E>>):Execute<E>{
    return fromFunXR(() -> new Report(err));
  }
  @:noUsing static public function fromErr<E>(err:Err<E>):Execute<E>{
    return fromFunXR(() -> Report.pure(err));
  }
  public inline function environment(success:Void->Void,failure:Err<E>->Void){
    return Arrowlet._.environment(
      this,
      Noise,
      (report) -> report.fold(
        failure,
        success
      ),
      __.crack
    );
  }
}
class ExecuteLift{
  static public function errata<E,EE>(self:Execute<E>,fn:Err<E>->Err<EE>):Execute<EE>{
    return Execute.lift(self.toArrowlet().then(
      Arrowlet.Sync((report:Report<E>) -> report.errata(fn))
    ));
  }
  static public function errate<E,EE>(self:Execute<E>,fn:E->EE):Execute<EE>{
    return Execute.lift(self.toArrowlet().then(
      Arrowlet.Sync((report:Report<E>) -> report.errata(
        (e:Err<E>) -> e.map(fn)
      ))
    ));
  }
  static public inline function prepare<E>(self:Execute<E>,term:Terminal<Report<E>,Noise>):Work{
    return self.toArrowlet().prepare(Noise,term);
  }
  static public function deliver<E>(self:Execute<E>,fn:Report<E>->Void):Fiber{
    return Arrowlet.Then(
      self,
      Arrowlet.Sync(
        (report) -> {
          fn(report);
          return Noise;
        }
      )
    );
  }
  static public function crack<E>(self:Execute<E>):Fiber{
    return deliver(self,
      (report) -> report.fold(
        __.crack,
        () -> {}
      )
    );
  }
  static public function then<E,O>(self:Execute<E>,that:Arrowlet<Report<E>,O,Noise>):Provide<O>{
    return Provide.lift(Arrowlet.Then(
      self,
      that
    ));
  }
  static public function execute<E,O>(self:Execute<E>,next:Execute<E>):Execute<E>{
    return Execute.lift(Arrowlet.Then(
      self,
      Arrowlet.Anon(
        (ipt:Report<E>,cont:Terminal<Report<E>,Noise>) -> ipt.fold(
          (e) -> cont.value(Report.pure(e)).serve(),
          ()  -> next.prepare(cont)
        )
      )
    ));
  }
  static public function produce<E,O>(self:Execute<E>,next:Produce<O,E>):Produce<O,E>{
    return Produce.lift(
      Arrowlet.Then(
        self,
        Arrowlet.Anon(
          (ipt:Report<E>,cont:Terminal<Res<O,E>,Noise>) -> ipt.fold(
            (e) -> cont.value(__.reject(e)).serve(),
            ()  -> next.prepare(cont)
          )
        )
      )
    );
  }
  static public function propose<E,O>(self:Execute<E>,next:Propose<O,E>):Propose<O,E>{
    return Propose.lift(
      Arrowlet.Then(
        self,
        Arrowlet.Anon(
          (ipt:Report<E>,cont:Terminal<Chunk<O,E>,Noise>) -> ipt.fold(
            (e) -> cont.value(End(e)).serve(),
            ()  -> next.prepare(cont)
          )
        )
      )
    );
  }
  static public function fold_mod<E,EE,O>(self:Execute<E>,fn:Report<E>->Execute<EE>):Execute<EE>{
    return Execute.lift(
      Arrowlet.FlatMap(
        self.toArrowlet(),
        (report:Report<E>) -> fn(report).toArrowlet()
      )
    );
  }
  static public function and<E>(self:Execute<E>,that:Execute<E>):Execute<E>{
    return self.execute(that);
  }
}