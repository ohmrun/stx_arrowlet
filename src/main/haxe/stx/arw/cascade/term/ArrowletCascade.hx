package stx.arw.cascade.term;

class ArrowletCascade<P,O,E> extends ArrowletCls<Res<P,E>,Res<O,E>,Noise>{
  var delegate : Internal<P,O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  public function apply(p:Res<P,E>):Res<O,E>{
    return p.fold(
      ok -> __.accept(delegate.apply(ok)),
      no -> __.reject(no)
    );
  }
  public function defer(p:Res<P,E>,cont:Terminal<Res<O,E>,Noise>):Work{
    return p.fold(
      ok -> delegate.defer(
        ok,
        cont.joint(joint.bind(_,cont))
      ),
      no  -> cont.value(__.reject(no)).serve()
    );
  }
  private function joint(outcome:Outcome<O,Defect<E>>,cont:Terminal<Res<O,E>,Noise>){
    return cont.value(
      outcome.fold(
        __.accept,
        (e) -> __.reject(Err.grow(e))
      )
    ).serve();
  }
  override public function toString(){
    return 'Cascade($delegate)';
  }
}