package stx.arw.arrowlet.term;

import haxe.Timer;
import haxe.MainLoop.MainEvent;


class Delay<I,E> extends ArrowletBase<I,I,E>{
  private var milliseconds : Int;
  public function new(milliseconds){
    super();
    this.milliseconds = milliseconds;
  }
  override private function doApplyII(i:I,cont:Terminal<I,E>):Work{
    var ft = TinkFuture.trigger();
    Timer.delay(
      () -> {
        ft.trigger(Success(i));
      },
      milliseconds
    );
    return cont.defer(ft).serve();
  }
}