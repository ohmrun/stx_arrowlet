package stx.arrowlet.core.pack;

import utest.Async;
import utest.Assert in Rig;

import stx.arrowlet.core.test.*;

class Test{
  public function new(){}
  public function deliver():Array<Dynamic>{
    return [
      new ProceedTest(),
      new FlatMapTest(),
      new TerminalTest(),
      new AfterRewriteTest(),
      new TestCascade()
    ].last()
     .toArray();
  }
}
class TestCascade extends utest.Test{
  public function test_cascade(async:utest.Async){
    var a = Cascade.fromArrowlet(
      Arrowlet.Sync(
        (x) -> x + 1
      )
    );
    a.environment(
      1,
      (x) -> {
        Rig.pass();
        async.done();
      },
      __.raise
    ).submit();
  }
}