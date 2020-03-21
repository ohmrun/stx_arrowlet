package stx.channel.pack;


@:forward abstract Resolve<I,O,E>(ResolveDef<I,O,E>) from ResolveDef<I,O,E> to ResolveDef<I,O,E>{
  public function new(self){
    this = self;
  }
  static public function lift<I,O,E>(self:ResolveDef<I,O,E>){
    return new Resolve(self);
  }
  public function toChannel():Channel<I,O,E>{
    return Channel.fromResolve(Arrowlet.lift(this));
  }
  public function prj():ResolveDef<I,O,E>{
    return this;
  } 
  
  
  @:to public function toArw():Arrowlet<Res<I,E>,O>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,O,E>(self:Arrowlet<Res<I,E>,O>):Resolve<I,O,E>{
    return lift(self.asRecallDef());
  }
} 