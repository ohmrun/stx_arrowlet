package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class FlatMap<I,Oi,Oii> extends Base<I,Oii,Automation>{
  var self : Arrowlet<I,Oi>;
  var func : Oi -> Arrowlet<I,Oii>;

	public function new(self,func){
		super();
		this.self = self;
		this.func = func;
	}
  override public function applyII(i:I,cont:Sink<Oii>):Automation{
    var outer_task_future = __.future();
    var inner_task_future = __.future();
    
		var automation_future	= inner_task_future.snd().flatMap(
			(task0:Task) -> outer_task_future.snd().map(
				(task1:Task) -> task0.seq(task1)
			)
		);
		var outer_task 				= self.applyII(
			i,
			(oI) -> {
				var next = func(oI);
        var inner_task = next.applyII(i,
          (oII) -> cont(oII)
        );
        inner_task_future.fst().trigger(inner_task);
			}
		);
		outer_task_future.fst().trigger(outer_task);

		return Task.fromFuture(automation_future);
  }
}