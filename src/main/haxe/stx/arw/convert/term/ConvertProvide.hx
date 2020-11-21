package stx.arw.convert.term;

class ConvertProvide<P,O,E> extends ArrowletCls<P,O,Noise>{
  var delegate : Convert<P,Provide<O>>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override inline public function apply(p:P):O{
    return Arrowlet.lift(Arrowlet.lift(delegate).toInternal().apply(p)).toInternal().apply(Noise);
  }
  override inline public function defer(p:P,cont:Terminal<O,Noise>):Work{
    return Arrowlet.lift(delegate).toInternal()
      .defer(
        p,
        cont.joint(
          (outcome:Outcome<Provide<O>,Defect<Noise>>) -> outcome.fold(
            ok -> ___lift(ok).toInternal().defer(Noise,cont),
            no -> cont.error(no).serve()
          )
        )
      );
  }
}