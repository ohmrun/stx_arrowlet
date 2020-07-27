package stx.arw.lift;

class LiftFutureToForward{
  static public function toForward<T>(fut:TinkFuture<T>):Forward<T>{
    return Forward.fromFunXFuture(
      () -> fut
    );
  }
}