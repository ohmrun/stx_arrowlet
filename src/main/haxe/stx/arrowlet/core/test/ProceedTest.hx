package stx.arrowlet.core.test;

class ProceedTest extends utest.Test{
  @Ignored
  public function test_lift_thunk(async:utest.Async){
    var proceed = (() -> true).cascade();
    proceed.context(
      (v) -> {
        Rig.isTrue(v);
        async.done();
      },
      (_) -> {}
    ).submit();
  }
  public function test_from_arrowlet(async:utest.Async){
    var arrowlet  = Arrowlet.Sync((_:Noise) -> 1);
    var proceed   = Proceed.fromArrowlet(arrowlet);
    proceed.context(
      (v) -> {
        Rig.equals(1,v);
        async.done();
      },
      (_) -> {}
    ).submit();
  }
}