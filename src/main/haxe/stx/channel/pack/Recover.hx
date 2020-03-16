package stx.channel.pack;

@:forward abstract Recover<I,E>(RecoverDef<I,E>) from RecoverDef<I,E> to RecoverDef<I,E>{
  public function new(self){
    this = self;
  }
  public function toChannel():Channel<I,I,E>{
    return Channel.fromRecover(Arrowlet.lift(this));
  }
  public function prj():RecoverDef<I,E>{
    return this;
  }
} 