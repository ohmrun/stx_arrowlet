package stx.channel.pack;

import stx.channel.head.Channels;
import stx.channel.head.data.Channel in ChannelT;

@:forward(receive,prepare)abstract Channel<I,O,E>(ChannelT<I,O,E>) from ChannelT<I,O,E> to ChannelT<I,O,E>{
  public function new(self) this = self;

  
  @:noUsing static public function lift<I,O,E>(self:ChannelT<I,O,E>)    return Channels.lift(self);
  @:noUsing static public function unit<I,E>():Channel<I,I,E>           return Channels.unit();
  @:noUsing static public function pure<I,O,E>(v:Chunk<O,E>):Channel<I,O,E>      return Channels.pure(v);
  
  public function then<Z>(that:Channel<O,Z,E>):Channel<I,Z,E>           return Channels._.then(that,this);
  
  public function attempt<R>(that:Attempt<O,R,E>):Channel<I,R,E>        return then(that.toChannel());
  public function process<Z>(that:Arrowlet<O,Z>):Channel<I,Z,E>         return Channels._.process(that,this);

  public function postfix<Z>(fn:O->Z)                                   return Channels._.postfix(fn,this);
  public function prefix<A>(fn:A->I)                                    return Channels._.prefix(fn,this);

  #if test
    public function crunch(i):Null<O>{
      var val = Tap.core();
      function put(v){
        val = v;
      }
      this.prepare(Val(i),Continue.unit().command(put)).crunch();
      return val.force();
    }
  #end

  public function errata<EE>(fn:TypedError<E>->TypedError<EE>):Channel<I,O,EE>{
    var fun = (chk:Chunk<O,E>) -> chk.fold(
      (v) -> Val(v),
      (e) -> End(fn(e)),
      ()  -> Tap
    );
    return lift(
      __.arw().cont()(
        (chunkN:Chunk<I,EE>,cont:Continue<Chunk<O,EE>>) -> {
          return switch(chunkN){
            case Val(v)   : this.postfix(fun).prepare(Val(v),cont);
            case End(ee)  : cont(End(ee),Automation.unit());
            case Tap      : cont(Tap,Automation.unit());
          }
        }
      )
    );
  }
  public function reframe():Reframe<I,O,E>{ 
    var fN = (ipt:Chunk<I,E>,cont:Continue<Chunk<Tuple2<O,I>,E>>) -> {
      return this.prepare(ipt,
        (opt:Chunk<O,E>,auto) -> cont(opt.zip(ipt),auto)
      );
    }
    return lift(__.arw().cont()(fN));
  }
  public function forward(i:I):IO<O,E>{
    return IOs.fromIOT((auto)->(next:Chunk<O,E>->Void) ->
      return auto.concat(this.prepare(Val(i),Continue.unit().command(next)))
    );
  }
  public function prj():ChannelT<I,O,E> return this;
  public function toArrowlet():Arrowlet<Chunk<I,E>,Chunk<O,E>>{
    return this;
  }
}