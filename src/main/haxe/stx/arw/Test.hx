package stx.arw;

import stx.log.Facade;
import utest.Async;
import utest.Assert.*;
import stx.Test.LoggedTest;

import utest.Assert in Rig;

import stx.arw.test.*;

class Test{
  static public function log(wildcard:Wildcard){
    return new stx.Log().tag("stx.arw.test");
  }
  public function new(){}
  static public function main(){
    var f = Facade.unit();
        //f.includes.push("stx.async");
        //f.includes.push("stx.async.Loop");
        //f.includes.push("stx.async.loop.term.Thread");
        f.includes.push("stx.arw.test");
        f.includes.push("stx.arw");
        f.includes.push(stx.async.Terminal.identifier());
        //f.level = INFO;
        var L   = stx.Log._.Logic();

        f.logic = f.logic.and(
          L.always()//L.type(stx.async.task.term.FutureOutcome.identifier()).not()
        ).and(
          L.type(stx.async.task.term.ThroughBind.identifier()).not()
        );
    var test = [
      new AaaTest(),
      new Aaa2Test(),
      new OptimisedTest(),
      new FlatMapTest(),
      new ProduceTest(),
      new TerminalTest(),
      new AfterRewriteTest(),
      new TestCascade(),
      new TestConvert(),
      new ThenFunTest(),
      new RawTest(),
    ];
    //stx.Test.test(test,[OptimisedTest,FlatMapTest,ProduceTest,TerminalTest,AfterRewriteTest]);
    //stx.Test.test(test,[FlatMapTest,ProduceTest,AfterRewriteTest]);
    stx.Test.test(test,[TerminalTest]);
  }
}
class Aaa2Test extends AaaTest{

}
class AaaTest extends utest.Test{
  public function test_after_tick(async:utest.Async){
    Arrowlet.fromFunSink(
      (i:Int,cb) -> {
        haxe.Timer.delay(
          () -> {
            //__.log().debug('calling callback: $i');
            cb(++i);
          },
          10
        );
      }
    ).environment(
      1,
      (v) -> {
        Rig.equals(2,v);
        async.done();
      },
      (e) -> {
        throw(e);
      }
    ).submit();
  }
}
class OptimisedTest extends stx.LoggedTest{
  public function test_unit_crunch(){
    var l = Arrowlet.unit();
    l.environment(
      1,
      (x) -> {
        equals(1,x);
      },
      __.crack
    ).crunch();
  }
}
class TestConvert extends stx.LoggedTest{
  function proc(){
    return Convert.lift(
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
      __.log().printer(),
      (x) -> {
        
        Rig.pass();
      }
    ).crunch();
  }
}