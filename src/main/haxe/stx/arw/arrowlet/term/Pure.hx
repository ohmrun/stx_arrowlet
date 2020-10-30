package stx.arw.arrowlet.term;

class Pure<I,O,E> extends stx.async.task.term.Pure<O,E> implements ArrowletApi<I,O,E>{

  public inline function apply(i:I):O{ 
    return this.result;
  };
  
  public inline function defer(i:I,cont:Terminal<O,E>):Work{
    return cont.lense(this).serve();
  }
  public function asArrowletDef():ArrowletDef<I,O,E>{
    return this;
  }
  override public function toString(){
    return 'Pure($result)';
  }
  public var convention(get,default):Convention;
  public function get_convention():Convention{
    return SYNC;
  }
}