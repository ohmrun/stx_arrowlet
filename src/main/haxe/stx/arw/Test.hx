package stx.arw;

import stx.log.Facade;
import utest.Async;
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
        f.includes.push("stx.arw.test");
        f.includes.push("stx.arw");
        
    utest.UTest.run(
      [
        //new FlatMapTest(),
        new ProduceTest(),
        //new TerminalTest(),
        //new AfterRewriteTest(),
        //new TestCascade(),
        //new TestConvert()
      ]//.last().toArray();
    );
  }
}
class TestConvert extends utest.Test{
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