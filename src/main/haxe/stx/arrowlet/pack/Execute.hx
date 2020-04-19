package stx.arrowlet.pack;

typedef ExecuteDef<E>                   = ArrowletDef<Noise,Report<E>,Noise>;

@:using(stx.arrowlet.pack.Execute.ExecuteLift)
abstract Execute<E>(ExecuteDef<E>) from ExecuteDef<E> to ExecuteDef<E>{
  public function new(self) this = self;
  static public function lift<E>(self:ExecuteDef<E>):Execute<E> return new Execute(self);
  static public function pure<E>(e:Err<E>) return lift(Arrowlet.pure(Report.pure(e)));
  static public function unit<E>() return lift(Arrowlet.pure(Report.unit()));

  @:noUsing static public function bind_fold<T,E>(fn:T->Report<E>->Execute<E>,arr:Array<T>):Execute<E>{
    return arr.lfold(
      (next:T,memo:Execute<E>) -> Execute.lift(Provide._.flat_map(
        memo,
        (report) -> lift(fn(next,report))
      )),
      unit()
    );
  }  
  @:to public function toProvide():Provide<Report<E>>{
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
}
class ExecuteLift{
  static public function errata<E,EE>(self:Execute<E>,fn:Err<E>->Err<EE>):Execute<EE>{
    return Execute.lift(self.toArrowlet().then(
      Arrowlet.Sync((report:Report<E>) -> report.errata(fn))
    ));
  }
  static public function prepare<E>(self:Execute<E>,term:Terminal<Report<E>,Noise>):Response{
    return self.toArrowlet().prepare(Noise,term);
  }
}