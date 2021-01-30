package stx.arw.arrowlet.term;

/**
  The right hand arrowlet uses the result of the left hand one to generate 
  an arrowlet. This second arrowlet takes the the output of the first as
  it's input.
**/
class Inform<I,Oi,Oii,E> extends ArrowletCls<I,Oii,E>{
  var lhs : Internal<I,Oi,E>;
  var rhs : Internal<Oi,Arrowlet<Oi,Oii,E>,E>;
  public function new(lhs,rhs){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  public function apply(i:I):Oii{
    return throw E_Arw_IncorrectCallingConvention;
  }
  public function defer(i:I,cont:Terminal<Oii,E>):Work{
    return lhs.toArrowlet().flat_map(
      (oI) -> Arrowlet.Anon(
        (_:I,contI:Terminal<Oii,E>) -> rhs.toArrowlet().flat_map(
          (aOiOii) -> aOiOii
        ).toInternal().defer(oI,contI)
      )
    ).toInternal().defer(i,cont);
  }
}