package stx.channel.pack;

import stx.channel.head.data.Resolve in ResolveT;

@:forward abstract Resolve<I,O,E>(ResolveT<I,O,E>) from ResolveT<I,O,E> to ResolveT<I,O,E>{
  public function new(self){
    this = self;
  }
  public function toChannel():Channel<I,O,E>{
    return Channels.fromResolve(this);
  }
  public function prj():ResolveT<I,O,E>{
    return this;
  }
} 