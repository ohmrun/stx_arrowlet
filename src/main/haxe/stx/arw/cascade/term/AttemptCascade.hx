package stx.arw.cascade.term;

class AttemptCascade<P,O,E> extends ArrowletCls<Res<P,E>,Res<O,E>,Noise>{
  var delegate : Attempt<P,O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function apply(p:Res<P,E>):Res<O,E>{
    return p.fold(
      ok -> delegate.apply(ok),
      no -> __.reject(no)
    );
  }
  override public function defer(p:Res<P,E>,cont:Terminal<Res<O,E>,Noise>):Work{
    return p.fold(
      ok -> Arrowlet.lift(delegate.toArrowlet()).toInternal().defer(ok,cont),
      no -> cont.value(__.reject(no)).serve()
    );
  }
}