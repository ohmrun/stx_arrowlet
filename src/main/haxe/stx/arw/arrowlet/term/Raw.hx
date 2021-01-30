package stx.arw.arrowlet.term;

class Raw<I,O,E> extends ArrowletCls<I,O,E>{
  private var delegate : I->(Outcome<O,Defect<E>>->Void)->Void;

  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  public function apply(i:I):O{
    return throw E_Arw_IncorrectCallingConvention;
  }
  public inline function defer(i:I,cont:Terminal<O,E>):Work{
    //__.log().debug('defer');
    return cont.later(Future.irreversible(
      (cb) -> {
        //__.log().debug('defer: called');
        delegate(i,cb);
      }
    )).serve();
  }
}
