package stx.arw.test;

class ThenFunTest<I,O> extends utest.Test{
  public function test(){
     var a = Arrowlet.Sync(
       (i) -> i + 1
     );
     //$type(a);
     var b = a.next(
      (i) -> i * 10
     );
     //$type(b);
     var c = b.next(
       __.log().through()
     );
     trace(c);
     c.environment(
       1,
       (x) -> equals(20,x),
       __.crack
     ).crunch();
  }
}