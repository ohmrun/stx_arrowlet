package stx.arw;

typedef ConvertDef<I,O> = ArrowletDef<I,O,Noise>;

/**
  An Arrowlet with no fail case
**/
@:using(stx.arw.Convert.ConvertLift)
abstract Convert<I,O>(ConvertDef<I,O>) from ConvertDef<I,O> to ConvertDef<I,O>{
  static public var _(default,never) = ConvertLift;
  public inline function new(self) this = self;
  @:noUsing static public inline function lift<I,O>(self:ConvertDef<I,O>):Convert<I,O> return new Convert(self);
  @:noUsing static public inline function unit<I>():Convert<I,I> return lift(Arrowlet.Sync((i:I)->i));

  @:noUsing static public function fromFun1Provide<I,O>(self:I->Provide<O>):Convert<I,O>{
    return fromConvertProvide(self);
  }
  @:noUsing static public function fromConvertProvide<I,O>(self:Convert<I,Provide<O>>):Convert<I,O>{
    return lift(new stx.arw.convert.term.ConvertProvide(self));
  }
  
  public inline function toArrowlet():ArrowletDef<I,O,Noise>{
    return this;
  }
  private var self(get,never):Convert<I,O>;
  private function get_self():Convert<I,O> return lift(this);

  public function toCascade<E>():Cascade<I,O,E>{
    return Cascade.lift(new stx.arw.cascade.term.ConvertCascade(this));
  }
  @:from static public function fromFun1R<I,O>(fn:I->O):Convert<I,O>{
    return lift(new stx.arw.convert.term.Fun1R(fn));
  }
  
  @:from static public function fromArrowlet<I,O>(arw:Arrowlet<I,O,Noise>){
    return lift(arw);
  }
  public inline function environment(i:I,success:O->Void):Fiber{
    return Arrowlet._.environment(
      this,
      i,
      success,
      __.crack
    );
  }
}
class ConvertLift{
  static public function then<I,O,Oi>(self:ConvertDef<I,O>,that:Convert<O,Oi>):Convert<I,Oi>{
    return Convert.lift(Arrowlet.Then(
      self,
      that
    ));
  }
  static public function provide<I,O,Oi>(self:ConvertDef<I,O>,i:I):Provide<O>{
    return Provide.lift(Arrowlet._.fulfill(self,i));
  }
  static public function convert<I,O,Oi>(self:ConvertDef<I,O>,that:ConvertDef<O,Oi>):Convert<I,Oi>{
    return Convert.lift(
      Arrowlet.Then(
        self,
        that
      )
    );
  }
  static public function first<I,Ii,O>(self:Convert<I,O>):Convert<Couple<I,Ii>,Couple<O,Ii>>{
    return Convert.lift(Arrowlet._.first(self.toArrowlet()));
  }
  static public function guess<I,O>(self:Convert<I,O>):Provide<O>{
    return Provide.lift(
      Arrowlet.Anon(
        (_:Noise,cont:Terminal<O,Noise>) -> Arrowlet._.prepare(self.toArrowlet(),null,cont)
      )
    );
  }
  static public inline function prepare<I,O>(self:Convert<I,O>,ipt:I,cont:Terminal<O,Noise>):Work{
    return Arrowlet._.prepare(self.toArrowlet(),ipt,cont);
  }
}