package stx.channel.pack;

import stx.channel.pack.reframe.Constructor;
//import stx.arrowlet.core.head.data.State     in StateT;

@:using(stx.channel.pack.reframe.Implementation)
@:forward abstract Reframe<I,O,E>(ReframeDef<I,O,E>) from ReframeDef<I,O,E> to ReframeDef<I,O,E>{
  static public inline function _() return Constructor.ZERO;

  public function new(self) this = self;

  static public function lift<I,O,E>(self:ReframeDef<I,O,E>):Reframe<I,O,E>  return _().lift(self);
  static public function pure<I,O,E>(o:O):Reframe<I,O,E>                     return _().pure(o);

  
  

  private var self(get,never):Reframe<I,O,E>;
  private function get_self():Reframe<I,O,E> return this;


  @:to public function toArw():Arrowlet<Res<I,E>,Res<Couple<O,I>,E>>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,O,E>(self:Arrowlet<Res<I,E>,Res<Couple<O,I>,E>>):Reframe<I,O,E>{
    return lift(self.asRecallDef());
  }

  @:to public function toChannel():Channel<I,Couple<O,I>,E>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromChannel<I,O,E>(self:Channel<I,Couple<O,I>,E>):Reframe<I,O,E>{
    return lift(self.asRecallDef());
  }
}