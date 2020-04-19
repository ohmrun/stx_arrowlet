package stx.run.test;

@:access(stx) class TerminalTest extends utest.Test{

	public function test(async:utest.Async){
    var term          = new stx.run.pack.Terminal.TerminalApiBase();
    var order_correct = false;
		var inner 				= term.inner();
		inner.later((val:Outcome<Int,Dynamic>) -> {
			order_correct = true;
			trace(val);
			term.issue(Success(1));
		});
		term.later(
			(val:Outcome<Int,Dynamic>) -> {
				trace(val);
				Rig.isTrue(order_correct);
        async.done();
			}
		);
		$type(term).serve().submit();

		
		inner.issue(Success(2));
	}
	public function test_reversed_call(async:utest.Async){
    var term          = new stx.run.pack.Terminal.TerminalApiBase();
    var order_correct = false;
		var next = term.inner();
				next.later(
					(val:Outcome<Int,Dynamic>) -> {
						order_correct = true;
					}
				);
		term.later(
			(val:Outcome<Int,Dynamic>) -> {
				Rig.isTrue(order_correct);
        async.done();
			}
		);
		term.serve().submit();
		
		next.issue(Success(2));
		term.issue(Success(1));
	}
	public function test_error_bubble(async:utest.Async){
		var term : Terminal<Int,Err<ERROR_A>>           
			= new stx.run.pack.Terminal.TerminalApiBase();
		var inner 				= term.inner();
				inner.later(
					(val:Outcome<Int,Err<ERROR_B>>) -> {
						term.error(__.fault().of(ERR_A));
						Act.Delay(200).upply(
							() -> {
								trace(Scheduler.ZERO.status());
								Rig.pass();
								async.done();
							}
						);
					}
				);
		term.serve().submit();
		inner.value(1);
	}
	public function test_serve_next(async:utest.Async){
		var term          = new stx.run.pack.Terminal.TerminalApiBase();
		var next 					= term.inner();
				next.later(
					(val:Outcome<Int,Dynamic>) -> {
						
					}
				);
		term.later(
			(val:Outcome<Int,Dynamic>) -> {
				Rig.pass();
        async.done();
			}
		);
		next.serve().submit();

		term.issue(Success(1));
		next.issue(Success(2));
	}
}
private enum ERROR_A{
	ERR_A;
}
private enum ERROR_B{
	ERR_B;
}
