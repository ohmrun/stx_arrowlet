package stx.arw;

typedef ExecuteDef<E>                   = ArrowletDef<Noise,Report<E>,Noise>;

@:using(stx.arw.Execute.ExecuteLift)
abstract Execute<E>(ExecuteDef<E>) from ExecuteDef<E> to ExecuteDef<E>{
  public function new(self) this = self;
  @:noUsing static public function lift<E>(self:ExecuteDef<E>):Execute<E> return new Execute(self);
  @:noUsing static public function pure<E>(e:Err<E>):Execute<E> return lift(Arrowlet.pure(Report.pure(e)));
  @:noUsing static public function unit<E>():Execute<E> return lift(Arrowlet.pure(Report.unit()));

  @:noUsing static public function bind_fold<T,E>(fn:T->Report<E>->Execute<E>,arr:Array<T>):Execute<E>{
    return arr.lfold(
      (next:T,memo:Execute<E>) -> Execute.lift(Forward._.flat_map(
        memo,
        (report) -> lift(fn(next,report))
      )),
      unit()
    );
  }  
  @:to public function toForward():Forward<Report<E>>{
    return this;
  }
  public function toArrowlet():Arrowlet<Noise,Report<E>,Noise>{
    return this;
  }
  @:noUsing static public function fromFunXR<E>(fn:Void->Report<E>):Execute<E>{
    return lift(Arrowlet.fromFunXR(fn));
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
  public function environment(success:Void->Void,failure:Err<E>->Void){
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
  static public function prepare<E>(self:Execute<E>,term:Terminal<Report<E>,Noise>):Work{
    return self.toArrowlet().prepare(Noise,term);
  }
  static public function deliver<E>(self:Execute<E>,fn:Report<E>->Void):Thread{
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
  static public function report<E>(self:Execute<E>):Thread{
    return deliver(self,__.report);
  }
  static public function then<E,O>(self:Execute<E>,that:Arrowlet<Report<E>,O,Noise>):Forward<O>{
    return Forward.lift(Arrowlet.Then(
      self,
      that
    ));
  }
}