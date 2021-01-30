package stx.arw.reframe.term;

class CascadeReframe<P,O,E> extends ArrowletCls<Res<P,E>,Res<Couple<O,P>,E>,Noise>{
  var delegate : CascadeDef<P,O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  public function apply(p:Res<P,E>):Res<Couple<O,P>,E>{
    return delegate.apply(p).flat_map(
      (opt) -> p.map(__.couple.bind(opt)) 
    );
  }
  public function defer(p:Res<P,E>,cont:Terminal<Res<Couple<O,P>,E>,Noise>):Work{
    return Arrowlet.lift(delegate).toInternal().defer(
      p,
      cont.joint(
        (outcome:Outcome<Res<O,E>,Defect<Noise>>) -> cont.issue(
          outcome.map(
            res -> res.flat_map(ok -> p.map(__.couple.bind(ok)))
          )
        ).serve()
      )
    );
  } 
}