package stx.arrowlet.core.test;

class ChannelTest{
  @Ignored
  public function test_arrowlet_to_channnel(async:utest.Async){
    Cascade.fromArrowlet(
      Arrowlet.Sync((i) -> i+1)
    ).environment(
      Success(1),
      (v) -> {
        Rig.same(Success(2),v);
        async.done();
      },
      (_) -> {

      }
    ).submit();
  }
}