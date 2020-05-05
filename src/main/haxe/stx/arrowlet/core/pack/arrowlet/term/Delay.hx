package stx.arrowlet.core.pack.arrowlet.term;


class Delay<I,E> extends ArrowletApi<I,I,E>{
  private var milliseconds : Int;
  public function new(milliseconds){
    super();
    this.milliseconds = milliseconds;
  }
  override private function doApplyII(i:I,cont:Terminal<I,E>):Response{
    var ft = TinkFuture.trigger();
    Act.Delay(milliseconds)
    .reply()
    .handle(
      (_) -> {
        ft.trigger(Success(i));
      }
    );
    return cont.defer(ft).serve();
  }
}