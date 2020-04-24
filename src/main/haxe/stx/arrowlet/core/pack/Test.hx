package stx.arrowlet.core.pack;

import utest.Async;
import utest.Assert in Rig;

class Test{
  public function new(){}
  public function deliver():Array<Dynamic>{
    return [
      //new ProceedTest(),
      //new FlatMapTest(),
      //new AfterRewriteTest()
      new TerminalTest()
    ].last()
     .toArray();
  }
}
class TerminalTest extends utest.Test{
  @Ignored
  public function test_composition(async:utest.Async){
    var t       = new Terminal();
    var r0      = t.value(1).later(
      (s) -> trace(s)
    );
    var inner   = t.inner();
    var r1      = inner.value("str").later(
      (s) -> trace(s)
    );
    var r2      = r0.after(r1.serve());


    function handler(v){
      trace(v);
      switch(v){
        case Hold(f)  : f().handle(handler);
        case Halt(_)  : 
          Rig.pass();
          async.done();
        default       :
      }
    }
    handler(r2);
  }
  public function test_inner(async:utest.Async){
    var t         = new Terminal();
    var deferI    = Future.trigger();
    var r0        = t.defer(deferI).later(
      (s) -> trace(s)
    );
    var inner     = t.inner();
    var deferII   = Future.trigger();
    var r1        = inner.defer(deferII).later(
      (s) -> {
        trace(s);
        deferI.trigger(__.success(1));
      }
    );
    var r2      = r0.after(r1.serve());
        deferII.trigger(__.success("hello"));

    function handler(v){
      trace(v);
      switch(v){
        case Hold(f)  : f().handle(handler);
        case Halt(_)  : 
          Rig.pass();
          async.done();
        default       :
      }
    }
    handler(r2);
  }
}