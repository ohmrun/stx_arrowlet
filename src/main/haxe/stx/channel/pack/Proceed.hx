package stx.channel.pack;

import stx.channel.head.data.Proceed in ProceedT;
import stx.channel.head.Proceeds;

@:forward(then) abstract Proceed<T,E>(ProceedT<T,E>) from ProceedT<T,E> to ProceedT<T,E>{
  public function new(self:ProceedT<T,E>) this = self;

  @:noUsing static public function lift<T,E>(arw:ProceedT<T,E>):Proceed<T,E>    return Proceeds.lift(arw);
  @:noUsing static public function pure<T,E>(v:T):Proceed<T,E>                return Proceeds.pure(v);

  @:noUsing static public function fromThunkT<T,E>(v:Void->T):Proceed<T,E>    return Proceeds.fromThunkT(v);
  @:noUsing static public function fromIO<T,E>(io:IO<T,E>):Proceed<T,E>       return Proceeds.fromIO(io);



  public function forward():IO<T,E> return Proceeds._.forward(lift(this));
  public function postfix(fn)       return Proceeds._.postfix(lift(this),fn);
  public function errata(fn)        return Proceeds._.errata(lift(this),fn);
}
