package stx.arrowlet.core.pack.arrowlet.term;

import tink.core.Future in TinkFuture;

class Fun1Future<I,O> extends stx.run.pack.recall.term.Base<I,O,Automation>{
  var delegate : I->TinkFuture<O>;
  public function new(delegate:I -> TinkFuture<O>){
    super();
    this.delegate = delegate;
  }
  override public function duoply(i:I,cont:O->Void):Automation{
    var rcv = Receiver.inj().fromFuture(delegate(i));
    return rcv.duoply(Noise,cont);
  }
}