package stx.arrowlet.core.pack;

import stx.channel.Package;
import utest.Async;
import utest.Assert;

class Test{
  public function new(){}
  public function deliver():Array<Dynamic>{
    //new TaskRebuildReloadTest(),
    //new Testing(),
    return [
      new FromTheGroundUpAgainTest()
    ];
  }
}
class FromTheGroundUpAgainTest extends utest.Test{
  @Ignored
  public function testFunctionArrowlet(){
    var value = None;

    var a = Arrowlets.fromFunction(
      (i:Int) -> return value = Some('booo $i')
    );
    var b = a.prepare(10,Continue.unit());
  
    b.crunch();
    Assert.same(Some('booo 10'),value);
  }
  @Ignored
  public function testCallbackArrowlet(){
    var value = None;
    var a = Arrowlets.fromCallbackSink(
      (i:Int,next:Int->Void) -> {
        value = Some(i);
        next(i);
      }
    ).prepare(10,Continue.unit());

    a.crunch();
    Assert.same(Some(10),value);
  }
  public function testCallbackArrowletAsync(async:utest.Async){
    var a = Arrowlets.fromCallbackSink(
      (i:Int,next:Int->Void) -> {
        Assert.pass();
        async.done();
        next(i);
      }
    ).prepare(10,Continue.unit());

    a.crunch();
  }
  public function testReleasedCallbackArrowletAsync(async:utest.Async){
    var a = Arrowlets.fromCallbackSink(
      (i:Int,next:Int->Void) -> {
        Assert.pass();
        async.done();
        next(i);
      }
    ).prepare(10,Continue.unit());

    a.submit();
  }
  public function testThen(async:Async){
    var fun = __.arw().fn()((int:Int) -> int + 1);
    var two = fun.then(fun);
    two.prepare(0,Continue.unit().command(
      __.tracer().fn()
        .then(
          __.command(
            (int) -> Assert.equals(2,int)
          )
        ).then(
        __.perform(async.done.bind(__.here()))
      ).enclose()
    )).crunch();
  }
  public function testReframe(){
    var a = __.channel().unit().postfix(
      (i) -> i + 1
    );
    a.prepare(1,Continue.unit()).crunch();
    var b = a.reframe();
    b.prepare(Val(1),Continue.unit()).crunch();
    Assert.pass();
  }
  function arw(){
    return __.arw().fn()(i -> i + 1);
  }
  public function test_broach(){
    //var a = __.channel().unit().postfix(i -> i + i).prj().broach();
    //a.prepare(1,Continue.unit()).crunch();
    //var b = __.arw().fn()(i -> i +1).broach();
  }
  public function test_fan(){
    var a = arw().fan();
    var b = arw().fan().then(Arrowlet.unit());
  }
  public function test_both(){
    var a = arw().both(arw());
    var b = a.prepare(tuple2(1,1),Continue.unit());
  }
  public function test_unit(){
    var a = Arrowlet.unit();
    var b = a.prepare(1,Continue.unit());
        b.crunch();
  }
  public function test_split(){
    //var a = arw().split(arw());
  }
  public function test_bound(){
    //var b = __.arw().fn()(i -> i +1).bound(__.arw().fn()(__.through()));
  }
  public function test_process(){
    var proc  = __.channel().process(arw());
    proc.prepare(Val(1),Continue.unit().command((x)-> trace(x))).crunch();
  }
}
