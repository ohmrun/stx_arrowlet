package stx.arw.arrowlet.term;

@:using(stx.arw.arrowlet.term.Fiber.FiberLift)
@:forward abstract Fiber(Arrowlet<Noise,Noise,Noise>) from Arrowlet<Noise,Noise,Noise>{
  static public var _(default,never) = FiberLift;
  static public inline function lift(self:Arrowlet<Noise,Noise,Noise>):Fiber{
    return self;
  }
  public inline function submit(?scheduler):Void{
    this.prepare(
      Noise,
      @:privateAccess new Terminal()
    ).submit(
      scheduler
    );
  }
  public inline function crunch(?scheduler):Void{
    this.prepare(
      Noise,
      @:privateAccess new Terminal()
    ).crunch(
      scheduler
    );
  }
  public function prj():ArrowletDef<Noise,Noise,Noise>{
    return this;
  }
}
class FiberLift{
  static public function then<O>(self:Fiber,that:Provide<O>):Provide<O>{
    return Provide.lift(Arrowlet.Then(
      self.prj(),
      that
    ));
  }
}