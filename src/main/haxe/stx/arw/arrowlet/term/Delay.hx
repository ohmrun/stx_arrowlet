package stx.arw.arrowlet.term;

import haxe.Timer;
import haxe.MainLoop.MainEvent;


class Delay<I,E> extends ArrowletBase<I,I,E>{
  private var milliseconds : Int;
  public function new(milliseconds){
    super();
    this.milliseconds = milliseconds;
  }
  override public function applyII(i:I,cont:Terminal<I,E>):Work{
    var ft = TinkFuture.trigger();
    //trace('here:$milliseconds');
    Timer.delay(
      () -> {
        //trace("here");
        ft.trigger(Success(i));
      },
      milliseconds
    );
    return cont.defer(ft).serve();
  }
}