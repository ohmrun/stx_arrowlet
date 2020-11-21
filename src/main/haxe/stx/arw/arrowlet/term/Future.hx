package stx.arw.arrowlet.term;

import tink.core.Future in TinkFuture;
class Future<O,E> extends ArrowletCls<Noise,O,E>{
  var delegate : TinkFuture<O>;
  public function new(delegate:TinkFuture<O>){
    super();
    this.delegate = delegate;
  }
  override public function apply(i:Noise):O{
    return throw E_Arw_IncorrectCallingConvention;
  }
  override public function defer(i:Noise,cont:Terminal<O,E>):Work{
    var outcome = delegate.map(Success);
    return cont.later(outcome).serve();
  }
}