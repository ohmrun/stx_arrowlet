package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

import tink.core.Future in TinkFuture;

class Future<O> extends Base<Noise,O,Automation>{
  var delegate : TinkFuture<O>;
  public function new(delegate:TinkFuture<O>){
    super();
    this.delegate = delegate;
  }
  override public function duoply(i:Noise,cont:O->Void):Automation{
    var rcv = Receiver.fromFuture(delegate);
    return rcv.duoply(i,cont);
  }
}