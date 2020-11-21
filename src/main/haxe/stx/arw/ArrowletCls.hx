package stx.arw;

abstract class ArrowletCls<P,O,E> implements ArrowletApi<P,O,E> extends TaskCls<O,E>{
	public function new(){
    super();
  }
  abstract public function apply(p:P):O;
  abstract public function defer(p:P,cont:Terminal<O,E>):Work;
  
  public var convention(get,default):Convention;
  public function get_convention():Convention{
    return ASYNC;
  }

  public function asArrowletDef():ArrowletDef<P,O,E> return this;
  
  override public function toString(){
    return std.Type.getClassName(__.definition(this)).split(".").last().defv('');
  }
  override public function pursue(){
    this.status = Secured;
  }
  
}