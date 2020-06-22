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
      new TestCascade(),
      new TestProcess()
    ].last()
     .toArray();
  }
}
class TestProcess extends utest.Test{
  function proc(){
    return Process.lift(
      Arrowlet.Sync(
        (x) -> {
          trace(x);
          return x + 1;
        }
      )
    );
  }
  @Ignored
  public function test_simple_case(){

    proc().environment(
      1,
      (s) -> {
        Rig.equals(2,s);
      }
    ).crunch();
  }
  @Ignored
  public function test_cascade(){
    var cascade = proc().toCascade();
    cascade.environment(
      1,
      (s) -> {
        Rig.equals(2,s);
      },
      __.raise  
    ).crunch();   
  }
  public function test_cascade_fail_through(){
    var cascade = proc().toCascade();
    var f       = Cascade.fromRes(__.failure(__.fault().of(Noise)));
    var all     = f.cascade(cascade);
    all.environment(
      __.success(1),
      __.log().sink(),
      (x) -> {
        Rig.pass();
      }
    ).crunch();
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