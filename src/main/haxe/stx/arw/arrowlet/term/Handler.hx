package stx.arw.arrowlet.term;

class Handler<O,E> extends ArrowletBase<Noise,O,E>{
  var delegate : (O->Void)->Void;
  public function new(delegate:(O->Void)->Void){
    super();
    this.delegate = delegate;
  }
  override public function applyII(i:Noise,cont:Terminal<O,E>):Work{
    var defer = Future.trigger();
    delegate(
      (o) -> defer.trigger(Success(o))
    );
    return cont.defer(defer).serve();
  }
}