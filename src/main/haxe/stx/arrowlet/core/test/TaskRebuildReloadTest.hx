package stx.arrowlet.test;

class TaskRebuildReloadTest extends utest.Test{
  var log : Log = __.log();

  public function testVanilla(async:Async){
    var arrowlet = new FunctionArrowlet(
      (x) -> {
        log.debug('function arrowlet function called');
        return x;
      }
    );
    var auto = arrowlet.deliver(1,
      (x) -> {
        Assert.pass();
        async.done();
      }
    );
    log.debug('function finished');
  }
  public function testAyncThenCalls(async:Async){
    var a = __.arw().fn()(c -> c);
    var b = __.arw().fn()((c) -> c++);
    var c = a.then(b);
    var auto = c.deliver(10,
      (x) -> {
        log.debug(x);
        async.done();
      }
    );

  }
}