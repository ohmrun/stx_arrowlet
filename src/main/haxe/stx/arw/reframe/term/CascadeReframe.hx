package stx.arw.reframe.term;

class CascadeReframe<P,O,E> extends ArrowletCls<Res<P,E>,Res<Couple<O,P>,E>,Noise>{
  var delegate : CascadeDef<P,O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function apply(p:Res<P,E>):Res<Couple<O,P>,E>{
    return delegate.apply(p).flat_map(
      (opt) -> p.map(__.couple.bind(opt)) 
    );
  }
  override public function defer(p:Res<P,E>,cont:Terminal<Res<Couple<O,P>,E>,Noise>):Work{
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
// return Reframe.lift(Arrowlet.Anon((ipt:Res<I, E>, cont:Terminal<Res<Couple<O, I>, E>, Noise>) -> {
//   // trace(ipt);
//   var defer = Future.trigger();
//   var inner = cont.inner((opt:Outcome<Res<O, E>, Array<Noise>>) -> {
//     // trace(opt);
//     defer.trigger(opt.map(res -> res.zip(ipt)));
//   });
//   return cont.later(defer).after(self.prepare(ipt, inner));
// }));