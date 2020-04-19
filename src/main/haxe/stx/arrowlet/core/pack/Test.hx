package stx.arrowlet.core.pack;

import utest.Async;
import utest.Assert in Rig;

class Test{
  public function new(){}
  public function deliver():Array<Dynamic>{
    return [
      //new AfterRewriteTest()
      new ProceedTest(),
      new FlatMapTest(),
    ].last()
     .toArray();
  }
}
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
class FlatMapTest extends utest.Test{
  public function test_then(async:utest.Async){
    var a = Arrowlet.Sync(x -> x + 1);
    var b = Arrowlet.Sync(x -> x + 1);
    var c = a.then(b);
        c.context(
          1,
          (x) -> {
            Rig.equals(3,x);
            async.done();
          },
          (_) -> {}
        ).submit();
  }
}