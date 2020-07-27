package stx.arw;

import utest.Async;
import utest.Assert in Rig;

import stx.arw.test.*;

class Test{
  public function new(){}
  static public function main(){
    utest.UTest.run(
      [
        new FlatMapTest(),
        //new ProceedTest(),
        //new TerminalTest(),
        //new AfterRewriteTest(),
        //new TestCascade(),
        //new TestProcess()
      ]//.last().toArray();
    );
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
  //@Ignored
  public function test_simple_case(){

    proc().environment(
      1,
      (s) -> {
        Rig.equals(2,s);
      }
    ).crunch();
  }
  //@Ignored
  public function test_cascade(){
    var cascade = proc().toCascade();
    cascade.environment(
      1,
      (s) -> {
        Rig.equals(2,s);
      },
      __.crack  
    ).crunch();   
  }
  public function test_cascade_fail_through(){
    var cascade = proc().toCascade();
    var f       = Cascade.fromRes(__.reject(__.fault().of(Noise)));
    var all     = f.cascade(cascade);
    all.environment(
      __.accept(1),
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
      __.crack
    ).submit();
  }
}