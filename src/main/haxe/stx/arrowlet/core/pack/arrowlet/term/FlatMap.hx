package stx.arrowlet.core.pack.arrowlet.term;

class FlatMap<I,Oi,Oii,E> extends ArrowletApi<I,Oii,E>{
  var self : Arrowlet<I,Oi,E>;
  var func : Oi -> Arrowlet<I,Oii,E>;

	public function new(self,func){
		super();
		this.self = self;
		this.func = func;
	}
  override private function doApplyII(i:I,cont:Terminal<Oii,E>):Response{
    var outer_task_future 	= TinkFuture.trigger();
    var inner_task_future   = TinkFuture.trigger();
    
		var automation_future	= inner_task_future.flatMap(
			(task0:Task) -> outer_task_future.map(
				(task1:Task) -> task0.seq(task1)
			)
		);
		var inner = cont.inner();
				inner.later(
					(oI:Outcome<Oi,E>) -> {
						var inner = cont.inner();
								inner.later(
									(oII:Outcome<Oii,E>) -> cont.issue(oII)
								);
						var inner_task = oI.fold(
							(v) -> func(v).prepare(i,inner),
							(e) -> {
								cont.error(e);
								return cont.serve();
							}
						);
						cont.after(inner_task);
						inner_task_future.trigger(inner_task.toTask());
					}
				);
		var outer_task 				= self.prepare(i,inner);

		outer_task_future.trigger(outer_task.toTask());
		
		cont.after(outer_task);
		return cont.serve();
  }
}