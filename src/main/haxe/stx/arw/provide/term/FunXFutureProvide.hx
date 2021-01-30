package stx.arw.provide.term;

class FunXFutureProvide<O> extends ArrowletCls<Noise,O,Noise>{
  var delegate : Void->Future<O>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  inline public function apply(p:Noise):O{
    return throw E_Arw_IncorrectCallingConvention;
  }
  inline public function defer(p:Noise,cont:Terminal<O,Noise>):Work{
    return cont.later(delegate().map(__.success)).serve();
  }
}