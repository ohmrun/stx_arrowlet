package stx.arw.test;

class AfterRewriteTest extends utest.Test{
  //@Ignored
  public function testSync(async:utest.Async){
    Arrowlet.Sync(
      (i) -> i + 1
    ).environment(
      1,
      (v) -> {
        Rig.equals(2,v);
        async.done();
      },
      (e) -> {}
    ).submit();
  }
  //@Ignored
  public function testAsync(async:utest.Async){
    Arrowlet.fromFunSink(
      (i,cb) -> {
        cb(++i);
      } 
    ).environment(
      1,
      (v) -> {
        Rig.equals(2,v);
        async.done();
      },
      (_)->{}
    ).submit();
  }
  //@:timeout(2000)
  @:timeout(70)
  //@Ignored
  public function test_after_tick(async:utest.Async){
    Arrowlet.fromFunSink(
      (i,cb) -> {
        haxe.Timer.delay(
          () -> cb(++i),
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
  //@Ignored
  public function test_arrowlet_error(async:utest.Async){
    Arrowlet.Anon(
      (i,cont) -> {
        return cont.issue(
          Failure(__.fault().err(E_UnexpectedNullValueEncountered))
        ).serve();
      }
    ).environment(
      1,
      (_) -> {},
      (e:Err<String>) -> {
        Rig.same(Some(ERR(E_UnexpectedNullValueEncountered)),e.data);
        async.done();
      }
    ).submit();
  }
}