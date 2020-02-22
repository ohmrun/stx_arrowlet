package stx.channel.pack;

import stx.channel.head.data.Command in CommandT;

@:forward abstract Command<I,E>(CommandT<I,E>) from CommandT<I,E> to CommandT<I,E>{
  public function new(self){
    this = self;
  }
  static public function lift<I,E>(self:CommandT<I,E>):Command<I,E>{
    return new Command(self);
  }
  public function toChannel():Channel<I,I,E>{
    return Channels.fromCommand(this);
  }
  public function prj():CommandT<I,E>{
    return this;
  }
  public function and(that:Command<I,E>):Command<I,E>{
    return this.split(that).postfix(
      (tp) -> tp.fst().zip(tp.snd()).map(
        e -> e.fst().next(e.snd())
      ).or(tp.snd)
    );
  }
  public function forward(i:I):EIO<E>{
    return EIO.lift(
      (auto) -> 
        Receiver.lift(
          (next) ->
            this.prepare(i,Continue.unit().command(next))
       )
    );
  }
  public function errata<EE>(fn:TypedError<E>->TypedError<EE>){
    return this.then(Options._.map.bind(fn));
  }
} 