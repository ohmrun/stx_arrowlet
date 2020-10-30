package stx.arw.arrowlet.term;

/**
  The right hand arrowlet uses the result of the left hand one to generate 
  an arrowlet. This second arrowlet takes the the output of the first as
  it's input.
**/
class Inform<I,Oi,Oii,E> extends ArrowletCls<I,Oii,E>{
  var lhs : Arrowlet<I,Oi,E>;
  var rhs : Arrowlet<Oi,Arrowlet<Oi,Oii,E>,E>;
  public function new(lhs,rhs){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public function apply(i:I):Oii{
    return throw E_Arw_IncorrectCallingConvention;
  }
  override public function defer(i:I,cont:Terminal<Oii,E>):Work{
    return lhs.flat_map(
      (oI) -> Arrowlet.Anon(
        (_:I,contI:Terminal<Oii,E>) -> rhs.flat_map(
          (aOiOii) -> aOiOii
        ).defer(oI,contI)
      )
    ).defer(i,cont);
  }
}