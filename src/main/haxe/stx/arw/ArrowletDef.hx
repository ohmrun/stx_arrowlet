package stx.arw;

typedef ArrowletDef<P,O,E>       = TaskDef<O,E> & {
  public function apply(p:P):O;
  public function defer(p:P,t:Terminal<O,E>):Work;
  
  public var convention(get,default):Convention;
  public function get_convention():Convention;

  public function asArrowletDef():ArrowletDef<P,O,E>;


  //toInternal // (apply // defer)
  //toTask     // If exists 
}