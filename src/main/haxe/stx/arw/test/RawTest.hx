package stx.arw.test;

class RawTest extends utest.Test{
  public function test(async:utest.Async){
    var a = Arrowlet.fromFunSink(
      (i,cont) -> {
        //__.log().debug("here");
        cont(__.success(i));
      }
    );
    a.environment(
      1,
      (x) -> {
        pass();
        async.done();
      },
      __.crack
    ).submit();
  }
}