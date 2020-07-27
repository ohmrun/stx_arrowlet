package stx.arw.test;

class ProceedTest extends utest.Test{
  public function test_lift_thunk(async:utest.Async){
    var proceed = (() -> true).cascade();
    proceed.environment(
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
    proceed.environment(
      (v) -> {
        Rig.equals(1,v);
        async.done();
      },
      (_) -> {}
    ).submit();
  }
}