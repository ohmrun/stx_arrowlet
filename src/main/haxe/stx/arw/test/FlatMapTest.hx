package stx.arw.test;

class FlatMapTest extends utest.Test{
  public function test_then(async:utest.Async){
    var a = Arrowlet.Sync(x -> x + 1);
    var b = Arrowlet.Sync(x -> x + 1);
    var c = a.then(b);
        c.environment(
          1,
          (x) -> {
            Rig.equals(3,x);
            async.done();
          },
          (y) -> {
            trace(y);
          }
        ).submit();
  }
}