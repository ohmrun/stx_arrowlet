package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Or<Ii,Iii,O> extends Base<Either<Ii,Iii>,O,Automation>{
  private var lhs:Arrowlet<Ii,O>;
  private var rhs:Arrowlet<Iii,O>;

  public function new(lhs,rhs){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public function duoply(i:Either<Ii,Iii>,cont:Sink<O>):Automation{
    return i.fold(
      (iI)  -> lhs.prepare(iI,cont),
      (iII) -> rhs.prepare(iII,cont)
    );
  }
}