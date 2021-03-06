package stx.arw.arrowlet.term;

class Unit<I,E> extends ArrowletCls<I,I,E>{
  public function defer(i:I,cont:Terminal<I,E>):Work{
    return cont.value(i).serve();
  }
  public function apply(i:I):I{
    return throw E_Arw_IncorrectCallingConvention;
  }
}