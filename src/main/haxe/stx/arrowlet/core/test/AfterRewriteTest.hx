package stx.arrowlet.core.test;

class AfterRewriteTest extends utest.Test{
  public function testSync(async:utest.Async){
    Arrowlet.Sync(
      (i) -> i + 1
    ).context(
      1,
      (v) -> {
        Rig.equals(2,v);
        async.done();
      },
      (e) -> {}
    ).submit();
  }
  public function testAsync(async:utest.Async){
    Arrowlet.fromFunSink(
      (i,cb) -> {
        cb(++i);
      } 
    ).context(
      1,
      (v) -> {
        Rig.equals(2,v);
        async.done();
      },
      (_)->{}
    ).submit();
  }
  public function test_after_tick(async:utest.Async){
    Arrowlet.fromFunSink(
      (i,cb) -> {
        Act.Defer().upply(
          () -> cb(++i)
        );
      }
    ).context(
      1,
      (v) -> {
        Rig.equals(2,v);
        async.done();
      },
      (_) -> {}
    ).submit();
  }
  public function test_arrowlet_to_channnel(async:utest.Async){
    Cascade.fromArrowlet(
      Arrowlet.Sync((i) -> i+1)
    ).context(
      Success(1),
      (v) -> {
        Rig.same(Success(2),v);
        async.done();
      },
      (_) -> {

      }
    ).submit();
  }
  public function test_arrowlet_error(async:utest.Async){
    Arrowlet.Anon(
      (i,cont) -> {
        cont.issue(
          Failure(__.fault().err(E_UnexpectedNullValueEncountered))
        );
        return cont.serve();
      }
    ).context(
      1,
      (_) -> {},
      (e:Err<String>) -> {
        Rig.same(Some(ERR(E_UnexpectedNullValueEncountered)),e.data);
        async.done();
      }
    ).submit();
  }
}