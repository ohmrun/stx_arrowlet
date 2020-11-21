package stx.arw.test;

class ProduceTest extends utest.Test{
  public function test_lift_thunk(async:utest.Async){
    //__.log()("test_lift_thunk:0");
    var produce = (() -> true).cascade();
    produce.environment(
      (v) -> {
        //__.log()("test_lift_thunk:1");
        Rig.isTrue(v);
        async.done();
      },
      (_) -> {}
    ).submit();
  }
  public function test_from_arrowlet(async:utest.Async){
    //__.log()("test_from_arrowlet:0");
    var arrowlet  = Arrowlet.Sync((_:Noise) -> 1);
    var produce   = Produce.fromArrowlet(arrowlet);
    produce.environment(
      (v) -> {
        //__.log()("test_from_arrowlet:1");
        Rig.equals(1,v);
        async.done();
      },
      (_) -> {}
    ).submit();
  }
}