package stx.channel.pack;

import stx.channel.head.Channels;
import stx.channel.head.data.Channel in ChannelT;

@:forward(receive,prepare)abstract Channel<I,O,E>(ChannelT<I,O,E>) from ChannelT<I,O,E> to ChannelT<I,O,E>{
  public function new(self) this = self;
  static public var inj(default,never) = new Constructor();
  
  @:noUsing static public function lift<I,O,E>(self:ChannelT<I,O,E>)              return Channels.lift(self);
  @:noUsing static public function unit<I,E>():Channel<I,I,E>                     return Channels.unit();
  @:noUsing static public function pure<I,O,E>(v:Outcome<O,E>):Channel<I,O,E>     return Channels.pure(v);
  
  public function then<Z>(that:Channel<O,Z,E>):Channel<I,Z,E>           return Channels._.then(that,this);
  
  public function attempt<R>(that:Attempt<O,R,E>):Channel<I,R,E>        return then(that.toChannel());
  public function process<Z>(that:Arrowlet<O,Z>):Channel<I,Z,E>         return Channels._.process(that,this);
  public function or<II>(that:Channel<II,O,E>)                          return inj._.or(that,this);
  public function postfix<Z>(fn:O->Z)                                   return Channels._.postfix(fn,this);
  public function prefix<A>(fn:A->I)                                    return Channels._.prefix(fn,this);

  #if test
    public function fudge(i):Null<O>{
      var val = __.failure(__.fault().of(AutomationFailure.NoValueFound));
      function put(v:Outcome<O,E>){
        val = v.errata(_ -> _.map(AutomationFailure.UnknownAutomationError));
      }
      this.prepare(__.success(i),Sink.unit().command(put)).crunch();
      return val.fudge();
    }
  #end

  public function errata<EE>(fn:TypedError<E>->TypedError<EE>):Channel<I,O,EE>{
    return lift(
      __.arw().cont(
        (chunkN:Outcome<I,EE>,cont:Sink<Outcome<O,EE>>) -> chunkN.fold(
          (v) -> this.postfix(Outcome.inj._.errata.bind(fn)).prepare(__.success(v),cont),
          (e) -> cont(__.failure(e),Automation.unit())
        )
      )
    );
  }
  public function reframe():Reframe<I,O,E>{ 
    var fN = (ipt:Outcome<I,E>,cont:Sink<Outcome<Tuple2<O,I>,E>>) -> {
      return this.prepare(ipt,
        (opt:Outcome<O,E>,auto) -> cont(opt.zip(ipt),auto)
      );
    }
    return lift(__.arw().cont(fN));
  }
  public function forward(i:I):IO<O,E>{
    return IO.inj.fromIOT((auto)->(next:Outcome<O,E>->Void) ->
      return auto.concat(this.prepare(Right(i),Sink.unit().command(next)))
    );
  }
  public function prj():ChannelT<I,O,E> return this;
  public function toArrowlet():Arrowlet<Outcome<I,E>,Outcome<O,E>>{
    return this;
  }
}
class Constructor extends Clazz{
  public var _ = new stx.channel.pack.channel.Destructure();
}