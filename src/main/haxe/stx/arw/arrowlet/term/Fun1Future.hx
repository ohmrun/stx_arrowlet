package stx.arw.arrowlet.term;

import tink.core.Future in TinkFuture;

class Fun1Future<I,O,E> extends ArrowletCls<I,O,E>{
  var delegate : I->TinkFuture<O>;
  public function new(delegate:I -> TinkFuture<O>){
    super();
    this.delegate = delegate;
  }
  override public function apply(i:I):O{
    return throw E_Arw_IncorrectCallingConvention;
  }
  override inline public function defer(i:I,cont:Terminal<O,E>):Work{
    var defer = Future.trigger();
    var handler   = (o:O) ->defer.trigger(Success(o));
    var canceller = delegate(i).handle(handler);

    return Work.Canceller(cont.defer(defer).serve(),canceller);
  }
}