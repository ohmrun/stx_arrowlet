package stx.arw;

/**
  false || true     // ASYNC
  true  || false    // ASYNC
  true  || true     // ASYNC
  false || false    // SYNC
**/
enum abstract ConventionSum(Bool) from Bool{
  var SYNC  = false;
  var ASYNC = true;

  private function new(self:Bool) this = self;

  @:allow(stx.arw.Convention) private function prj():Bool{
    return this;
  }
  @:allow(stx.arw.Convention) static private function lift(self:Bool):Convention{
    return new Convention(self);
  }
}
abstract Convention(ConventionSum) from ConventionSum to ConventionSum{
  public function new(self) this = self;
  static public function lift(self:ConventionSum):Convention return new Convention(self);

  @:op(A || A)
  public function or(that:Convention):Convention{
    var result = this.prj() || that.prj().prj();
    return Convention.lift(result);
  }
  public function fold<Z>(is_async:Void->Z,is_sync:Void->Z):Z{
    return this.prj().if_else(
      is_async,
      is_sync
    );
  }
  public function prj():ConventionSum return this;
  private var self(get,never):Convention;
  private function get_self():Convention return lift(this);
}