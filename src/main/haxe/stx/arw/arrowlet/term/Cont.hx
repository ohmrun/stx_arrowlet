package stx.arw.arrowlet.term;

class Cont<I,O,E> extends ArrowletCls<I,O,E>{
  private var delegate : I->(Work->Void)->(Outcome<O,E>->Void)->Void;

  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function apply(i:I):O{
    return throw E_Arw_IncorrectCallingConvention;
  }
  override public function defer(i:I,cont:Terminal<O,E>):Work{
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
