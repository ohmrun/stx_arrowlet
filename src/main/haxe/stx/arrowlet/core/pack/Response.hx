package stx.arrowlet.core.pack;

import stx.run.pack.task.term.Base;
import stx.run.pack.task.term.Both;
import stx.run.pack.task.term.Deferred;
import stx.run.pack.task.term.Wrap;

@:forward(complete) @:allow(stx) abstract Response(ResponseApi) from ResponseApi{
	private function new(deferred){
		this = new ResponseApi(deferred);
	}
	@:noUsing static public function until<E>(task:Task):Response{
		return new Response(task);
	}
	@:noUsing static public function error<E>(e:Err<E>):Response{
		return until(new stx.run.pack.task.term.Error(e));
	}
	public function submit(?scheduler:Scheduler){
		scheduler = __.option(scheduler).defv(Scheduler.ZERO);
		scheduler.add(this);
		scheduler.run();//TODO ideally somewhere else
	}
	private function toTask():Task{
		return this;
	}
}
class ResponseApi extends Wrap{

}