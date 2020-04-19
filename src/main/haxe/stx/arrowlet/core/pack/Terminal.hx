package stx.arrowlet.core.pack;

import haxe.Timer;

import stx.run.pack.task.term.All;
import stx.run.pack.task.term.Seq;
import stx.run.pack.task.term.Both;
import stx.run.pack.task.term.Count;
import stx.run.pack.task.term.Base;
import stx.run.pack.task.term.On;
import stx.run.pack.task.term.When;

// enum TerminalInputSum<O,E>{
//   Issue(o:O);
//   Wrong(err:Err<AutomationFailure<E>>);
  
//   Serve(sink:Sink<O>);
//   Split<U>(sink:Sink<O>,await:TerminalInputSum<U,E>);
//   Until(task:Task);
// }
// typedef TerminalDef = Continuation<Response,TerminalInputSum>;

@:allow(stx) class TerminalApiBase<O,E> extends Both{
  var handlers        : Array<Void->Void>;
  var stored          : Outcome<O,E>;
  var future          : Future<Outcome<O,E>>;
  var trigger         : FutureTrigger<Outcome<O,E>>;
  var canceller       : CallbackLink;
  var depends         : Array<Response>;

  private function new(?parent){
    this.handlers  = [];
    this.trigger   = Future.trigger();
    this.depends   = [];
    this.future    = trigger.asFuture();

    super(
      new TerminalDepend(cast this.depends),
      new TerminalWait(trigger)
    );
    
  
    if(parent!=null){
      parent.after(this.serve());
    }
  }
  override private function do_escape(){
    //canceller.invoke();  
  }
  override private function do_pursue(){
    if(stored == null){
      if(canceller == null) {
        canceller = trigger.handle(
          (s) -> stored = s
        );
      }else{
        canceller = canceller & trigger.handle(
          (s) -> stored = s
        );
      }
    }else{
      internal();
      trigger.trigger(stored);
    }
    return if(super.do_pursue()){
      true;
    }else{
      var trigger0 = Future.trigger();
      future.handle(
        (_) -> trigger0.trigger(Noise)
      );
      progression(Waiting(trigger0.asFuture()));
      true;
    }
  }
  public function serve():Response{
    return Response.until(this);
  }
  public function issue(res:Outcome<O,E>):Void{
    stored = res;
	}
	public function after(response:Response):Void{
    this.depends.push(response);
  }
  public function later(cb:Outcome<O,E> -> Void):Void{
    var handle = null;
        handle = () -> {
          cb(this.stored);
          this.handlers.remove(handle);
        };
    this.handlers.push(handle);
  }
  public function inner<T,EE>():Terminal<T,EE>{
    var inner = new TerminalApiBase(this);
    return inner.asTerminalDef();
  }
	public function asTerminalDef():TerminalDef<O,E>{
		return this;
  }
  private function internal(){
    for(handler in handlers){
      handler();
    }
  }
}
class TerminalWait<O,E> extends When<Outcome<O,E>>{

}
class TerminalDepend extends All{

}
typedef TerminalDef<O,E> = {

  public function serve():Response;

  public function issue(res:Outcome<O,E>):Void;

  public function after(response:Response):Void;
  public function later(cb:Outcome<O,E>->Void):Void;

  public function inner<T,EE>():Terminal<T,EE>;

	public function asTerminalDef():TerminalDef<O,E>;
}
@:forward abstract Terminal<O,E>(TerminalDef<O,E>) from TerminalDef<O,E> to TerminalDef<O,E>{
  static public var ZERO : Terminal<Noise,Noise> = new TerminalApiBase().asTerminalDef();
	static public function unit<O,E>():Terminal<O,E>{
		return new TerminalApiBase().asTerminalDef();
  }
  public function value(o:O){
    this.issue(Success(o));
  }
  public function error(e:E){
    this.issue(Failure(e));
  }
}
 