package stx.arw.command.term;

class ArrowletCommand<P,E> extends ArrowletCls<P,Report<E>,Noise>{
  var delegate : Arrowlet<P,Noise,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  public function apply(p:P):Report<E>{
    return try{
      this.delegate.toInternal().apply(p);
      Report.unit();
    }catch(e:Dynamic){
      Report.pure(e);
    }
  }
  public function defer(p:P,cont:Terminal<Report<E>,Noise>):Work{
    return this.delegate.toInternal().defer(
      p,
      cont.joint(joint.bind(_,cont))
    );
  }
  private function joint(oc:Outcome<Noise,Defect<E>>,cont:Terminal<Report<E>,Noise>){
    return oc.fold(
      (_) -> cont.value(Report.unit()).serve(),
      (e:Defect<E>) -> cont.value(Report.pure(Err.grow(e))).serve()
    );
  }
}