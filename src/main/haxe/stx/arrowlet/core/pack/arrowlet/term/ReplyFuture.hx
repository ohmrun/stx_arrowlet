package stx.arrowlet.core.pack.arrowlet.term;

import tink.core.Future in TinkFuture;

class ReplyFuture<O,E> extends ArrowletApi<Noise,O,E>{
  var delegate : Void->TinkFuture<O>;
  public function new(delegate:Void->TinkFuture<O>){
    super();
    this.delegate = delegate;
  }
  override private function doApplyII(i:Noise,cont:Terminal<O,E>):Work{
    var defer = Future.trigger();
    var handler   = (o:O) ->{
      defer.trigger(Success(o));
    }
    var canceller = delegate().handle(
      handler
    );//TODO
    return cont.defer(defer).serve();
  }
}