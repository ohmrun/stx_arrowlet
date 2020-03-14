package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

import tink.core.Future in TinkFuture;

class ReplyFuture<O> extends Base<Noise,O,Automation>{
  var delegate : Void->TinkFuture<O>;
  public function new(delegate:Void->TinkFuture<O>){
    super();
    this.delegate = delegate;
  }
  override public function duoply(i:Noise,cont:O->Void):Automation{
    var rcv = Receiver.inj().fromFuture(delegate());
    return rcv.duoply(i,cont);
  }
}