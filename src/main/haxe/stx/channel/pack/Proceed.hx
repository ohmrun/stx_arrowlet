package stx.channel.pack;

import stx.channel.pack.proceed.Constructor;

@:using(stx.arrowlet.core.pack.arrowlet.Implementation)
@:forward(then) abstract Proceed<O,E>(ProceedDef<O,E>) from ProceedDef<O,E> to ProceedDef<O,E>{
  static public inline function _() return Constructor.ZERO;

  public function new(self:ProceedDef<O,E>) this = self;


  @:noUsing static public function lift<O,E>(arw:ProceedDef<O,E>):Proceed<O,E>    return _().lift(arw);
  @:noUsing static public function pure<O,E>(v:O):Proceed<O,E>                    return _().pure(v);

  @:noUsing static public function fromThunkT<O,E>(v:Void->O):Proceed<O,E>        return _().fromThunkT(v);
  @:noUsing static public function fromIO<O,E>(io:IO<O,E>):Proceed<O,E>           return _().fromIO(io);



  public function forward():IO<O,E> return _()._.forward(self);
  public function postfix(fn)       return _()._.postfix(self,fn);
  public function errata(fn)        return _()._.errata(self,fn);
  
  private var self(get,never):Proceed<O,E>;
  private function get_self():Proceed<O,E> return this;

  @:to public function toArw():Arrowlet<Noise,Outcome<O,E>>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,O,E>(self:Arrowlet<Noise,Outcome<O,E>>):Proceed<O,E>{
    return lift(self.asRecallDef());
  }
}
