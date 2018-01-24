package test.stx.arrowlet;

using stx.arrowlet;

class CallableTest{
  public function new(){

  }
  public function testForward(){
    var v : Arrowlet<Int,Int> = function(x) {return x;};
    v(3,haxe.Log.trace.bind(_,null));
  }
}
