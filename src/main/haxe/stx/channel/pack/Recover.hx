package stx.channel.pack;

import stx.channel.head.data.Recover in RecoverT;

@:forward abstract Recover<I,E>(RecoverT<I,E>) from RecoverT<I,E> to RecoverT<I,E>{
  public function new(self){
    this = self;
  }
  public function toChannel():Channel<I,I,E>{
    return Channels.fromRecover(this);
  }
  public function prj():RecoverT<I,E>{
    return this;
  }
} 