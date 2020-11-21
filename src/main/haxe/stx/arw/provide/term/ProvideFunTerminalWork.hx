package stx.arw.provide.term;

class ProvideFunTerminalWork<O> extends ArrowletCls<Noise,O,Noise>{
  var delegate : Terminal<O,Noise>->Work;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override inline public function apply(p:Noise):O{
    return throw E_Arw_IncorrectCallingConvention;
  }
  override inline public function defer(p:Noise,cont:Terminal<O,Noise>):Work{
    return delegate(cont);
  }
}