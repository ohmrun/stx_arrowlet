package stx.arrowlet.core.test;

@:access(stx) class TerminalTest extends utest.Test{

	// public function test(async:utest.Async){
  //   var term          = new Terminal();
  //   var order_correct = false;
	// 	var inner 				= term.inner();
	// 	inner.later((val:Outcome<Int,Dynamic>) -> {
	// 		order_correct = true;
	// 		trace(val);
	// 		term.issue(Success(1));
	// 	});
	// 	term.later(
	// 		(val:Outcome<Int,Dynamic>) -> {
	// 			trace(val);
	// 			Rig.isTrue(order_correct);
  //       async.done();
	// 		}
	// 	);
	// 	term.serve().submit();

	// 	var res = term.after(inner.issue(Success(2))
	// 	inner.issue(Success(2));
	// }
	// public function test_reversed_call(async:utest.Async){
  //   var term          = new Terminal();
  //   var order_correct = false;
	// 	var next = term.inner();
	// 			next.later(
	// 				(val:Outcome<Int,Dynamic>) -> {
	// 					order_correct = true;
	// 				}
	// 			);
	// 	term.later(
	// 		(val:Outcome<Int,Dynamic>) -> {
	// 			Rig.isTrue(order_correct);
  //       async.done();
	// 		}
	// 	);
	// 	term.serve().submit();
		
	// 	next.issue(Success(2));
	// 	term.issue(Success(1));
	// }
	// public function test_error_bubble(async:utest.Async){
	// 	var term : Terminal<Int,Err<ERROR_A>> = new Terminal();
	// 	var defer = Future.trigger();
	// 	var inner 				= term.inner(
	// 				(val:Outcome<Int,Err<ERROR_B>>) -> {
	// 					defer.trigger(Failure(error(__.fault().of(ERR_A))));
	// 					Act.Delay(200).upply(
	// 						() -> {
	// 							trace(Scheduler.ZERO.status());
	// 							Rig.pass();
	// 							async.done();
	// 						}
	// 					);
	// 				}
	// 			);
	// 	term.defer(defer).serve().submit();
	// 	inner.value(1);
	// }
	// public function test_serve_next(async:utest.Async){
	// 	var term          = new stx.run.pack.Terminal.TerminalApiBase();
	// 	var next 					= term.inner();
	// 			next.later(
	// 				(val:Outcome<Int,Dynamic>) -> {
						
	// 				}
	// 			);
	// 	term.later(
	// 		(val:Outcome<Int,Dynamic>) -> {
	// 			Rig.pass();
  //       async.done();
	// 		}
	// 	);
	// 	next.serve().submit();

	// 	term.issue(Success(1));
	// 	next.issue(Success(2));
	// }
	@Ignored
  public function test_composition(async:utest.Async){
    var t       = new Terminal();
    var r0      = t.value(1).later(
      (s) -> trace(s)
    );
    var inner   = t.inner(
      (outcome) -> {
        trace(outcome);
      }
    );
    var r1      = inner.value("str");
    var r2      = r0.after(r1.serve());


    function handler(v){
      trace(v);
      switch(v){
        case Hold(f)  : f().handle(handler);
        case Halt(_)  : 
          Rig.pass();
          async.done();
        default       :
      }
    }
    handler(r2);
  }
  public function test_inner(async:utest.Async){
    var t         = new Terminal();
    var deferI    = Future.trigger();
    var r0        = t.defer(deferI).later(
      (s) -> trace(s)
    );
    var inner     = t.inner(
      (s) -> {
        trace(s);
        deferI.trigger(s);
      }
    );
    var deferII   = Future.trigger();
    var r1        = inner.defer(deferII);
    var r2      = r0.after(r1.serve());
        deferII.trigger(__.success("hello"));

    function handler(v){
      trace(v);
      switch(v){
        case Hold(f)  : f().handle(handler);
        case Halt(_)  : 
          Rig.pass();
          async.done();
        default       :
      }
    }
    handler(r2);
  }
}
private enum ERROR_A{
	ERR_A;
}
private enum ERROR_B{
	ERR_B;
}