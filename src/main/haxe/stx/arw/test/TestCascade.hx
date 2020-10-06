package stx.arw.test;

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