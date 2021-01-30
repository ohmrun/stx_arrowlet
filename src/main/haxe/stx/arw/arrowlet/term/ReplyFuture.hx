package stx.arw.arrowlet.term;

import tink.core.Future in TinkFuture;

class ReplyFuture<O,E> extends ArrowletCls<Noise,O,E>{
  var delegate : Void->TinkFuture<O>;
  public function new(delegate:Void->TinkFuture<O>){
    super();
    this.delegate = delegate;
  }
  public function apply(i:Noise):O{
    return throw E_Arw_IncorrectCallingConvention;
  }
  public function defer(i:Noise,cont:Terminal<O,E>):Work{
    var defer = Future.trigger();
    var handler   = (o:O) ->{
      defer.trigger(Success(o));
    }
    var canceller = delegate().handle(handler);
    return Work.Canceller(cont.later(defer).serve(),canceller);
  }
}