package stx.arw.arrowlet.term;

class Anon<I,O,E> extends ArrowletCls<I,O,E>{
  private var delegate : I->Terminal<O,E>->Work;

  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override inline public function defer(i:I,cont:Terminal<O,E>):Work{
    return delegate(i,cont);
  }
  //TODO, I could conceivably have this run in the thread if possible
  override inline public function apply(i:I):O{
    return throw E_Arw_IncorrectCallingConvention;
  }
  override public function toString(){
    return 'Anon(${this.delegate})';
  }
}
