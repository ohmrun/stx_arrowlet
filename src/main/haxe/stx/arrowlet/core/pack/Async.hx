package stx.arrowlet.core.pack;

class AsyncApi<P,O,E>{
	public function new(){

	}
	public function applyII(p:P,t:Terminal<O,E>):Response{
		var output = doApplyII(p,t);
		// if(!t.ready){
		// 	throw 'use the terminal before returning from function';
		// }
		return output;
	}
	private function doApplyII(p:P,t:Terminal<O,E>):Response{
		var err : Err<E> = __.fault().err(E_AbstractMethod);
    t.issue(__.failure(err));
    return t.serve();
  }
  public function asArrowletDef():ArrowletDef<P,O,E>{
    return this;
  }
}
typedef ArrowletDef<P,O,E>       = {
  public function applyII(p:P,t:Terminal<O,E>):Response;
  public function asArrowletDef():ArrowletDef<P,O,E>;
}