package stx.arw.cascade.term;

class ConvertCascade<P,O,E> extends ArrowletCls<Res<P,E>,Res<O,E>,Noise>{
  var delegate : Convert<P,O>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function apply(p:Res<P,E>):Res<O,E>{
    return p.fold(
      ok -> __.accept(Arrowlet.lift(delegate).toInternal().apply(ok)),
      no -> __.reject(no)
    );
  }
  override public function defer(p:Res<P,E>,cont:Terminal<Res<O,E>,Noise>):Work{
    return p.fold(
      ok -> Arrowlet.lift(delegate).toInternal().defer(ok,cont.joint(
        (outcome:Outcome<O,Defect<Noise>>) -> cont.value(
          outcome.fold(
            ok                  -> __.accept(ok),
            (no:Defect<Noise>)  -> __.reject((LiftDefectNoiseToErr.toErr(no):Err<E>))
          )
        ).serve()
      )),
      no -> cont.value(__.reject(no)).serve()
    );
  }
  override public function get_convention(){
    return Arrowlet.lift(this.delegate).toInternal().convention;
  }
}