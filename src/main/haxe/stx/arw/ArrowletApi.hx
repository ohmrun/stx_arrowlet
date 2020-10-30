package stx.arw;

interface ArrowletApi<P,O,E> extends TaskApi<O,E>{
  public function apply(i:P):O;
  public function defer(p:P,t:Terminal<O,E>):Work;
  
  public var convention(get,default):Convention;
  public function get_convention():Convention;
  
  public function asArrowletDef():ArrowletDef<P,O,E>;
}