package stx.arw.lift;

class LiftFutureToProvide{
  static public function toProvide<T>(fut:TinkFuture<T>):Provide<T>{
    return Provide.fromFunXFuture(
      () -> fut
    );
  }
}