package stx.arrowlet.core.pack.arrowlet.term;

class Cont<I,O,E> extends ArrowletBase<I,O,E>{
  private var delegate : I->(Work->Void)->(Outcome<O,E>->Void)->Void;

  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override private function doApplyII(i:I,cont:Terminal<O,E>):Work{
    var defer = Future.trigger();
    var work  = Work.unit();
    delegate(
      i,
      (w) -> {
        work = work.seq(w);
      },
      (v) -> {
        defer.trigger(v);
      }
    );
    return cont.defer(defer).after(work);
  }
}
