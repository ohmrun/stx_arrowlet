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
  function wrap(tests,async:Async){
    return Automation.execute(() -> {
      tests();
      async.done();
      return None;
    });
  }
  public function testFun1Arrowlet(async:Async){
    var value = None;

    var a = Arrowlet.fromFun1R(
      (i:Int) -> return value = Some('booo $i')
    );
    var b = a.prepare(10,Sink.unit());
        b = b.snoc(
          wrap(
            () -> Assert.same(Some('booo 10'),value),
            async
          )
        );
    b.submit();
    
  }
  public function testCallbackArrowlet(async:Async){
    var value = None;
    var a = Arrowlet.fromRecallFun(
      (i:Int,next:Int->Void) -> {
        value = Some(i);
        next(i);
      }
    ).prepare(10,Sink.unit())
     .snoc(
       wrap(
        () -> Assert.same(Some(10),value),
        async
       )
     );

    a.submit();
  }
  //@Ignored
  public function testCallbackArrowletAsync(async:utest.Async){
    var a = Arrowlet.fromRecallFun(
      (i:Int,next:Int->Void) -> {
        Assert.pass();
        async.done();
        next(i);
      }
    ).prepare(10,Sink.unit());

    a.submit();
  }
  //@Ignored
  public function testReleasedCallbackArrowletAsync(async:utest.Async){
    var a = Arrowlet.fromRecallFun(
      (i:Int,next:Int->Void) -> {
        Assert.pass();
        async.done();
        next(i);
      }
    ).prepare(10,Sink.unit());

    a.submit();
  }
  //@Ignored
  public function testPure(async:Async){
    var r = Arrowlet.pure(1);
        r.prepare(5,
          (x) -> {
            Assert.equals(1,x);
            async.done();
          }
        ).submit();
  }
  public function testThen(async:Async){
    var fun = Arrowlet.fromFun1R((int:Int) -> int + 1);
    var two = fun.then(fun);
    two.prepare(0,(int) -> {
      Assert.equals(2,int);
        async.done();
    }).submit();
  }
  /*
  public function testReframe(){
    var a = Channel.unit().postfix(
      (i) -> i + 1
    );
    a.prepare(__.success(1),Sink.unit()).crunch();
    var b = a.reframe();
    b.prepare(__.success(1),Sink.unit()).crunch();
    Assert.pass();
  }*/
  function arw():Arrowlet<Int,Int>{
    return Arrowlet.fromFun1R(i -> i + 1);
  }
  //@Ignored
  public function test_broach(){
    //var a = __.channel().unit().postfix(i -> i + i).prj().broach();
    //a.prepare(1,Sink.unit()).crunch();
    //var b = __.arw().fn(i -> i +1).broach();
  }
  //@Ignored
  public function test_fan(){
    var a = arw().fan();
    var b = arw().fan().then(Arrowlet.unit());
  }
  //@Ignored
  public function test_both(){
    var a = arw().both(arw());
    var b = a.prepare(tuple2(1,1),Sink.unit());
  }
  //@Ignored
  public function test_unit(async){
    var a = Arrowlet.unit();
    var b = a.prepare(1,Sink.unit());
        b.snoc(
          wrap(
            () -> {},
            async
          )
        ).submit();
  }
  //@Ignored
  public function test_split(){
    //var a = arw().split(arw());
  }
  @Ignored
  public function test_bound(){
    //var b = __.arw().fn(i -> i +1).bound(__.arw().fn(__.through()));
  }
  //@Ignored
  // public function test_process(){
  //   var proc  = Channel.fromArrowlet(arw());
  //   proc.prepare(__.success(1),(x)-> trace(x)).crunch();
  // }
}
