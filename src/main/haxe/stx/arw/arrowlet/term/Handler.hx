package stx.arw.arrowlet.term;

class Handler<O,E> extends ArrowletCls<Noise,O,E>{
  var delegate : (O->Void)->Void;
  public function new(delegate:(O->Void)->Void){
    super();
    this.delegate = delegate;
  }
  override public function apply(i:Noise):O{
    return throw E_Arw_IncorrectCallingConvention;
  }
  override public function defer(i:Noise,cont:Terminal<O,E>):Work{
    var defer = Future.trigger();
    delegate(
      (o) -> defer.trigger(Success(o))
    );
    return cont.later(defer).serve();
  }
}