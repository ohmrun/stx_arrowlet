package stx.channel.pack.reframe;

import stx.arrowlet.core.pack.arrowlet.Implementation in Arw;
import stx.channel.pack.channel.Implementation in Chnl;

class Implementation{
  private static function _() return Reframe._()._;

  static public function process<I,O,Oi,E>(self:Reframe<I,O,E>,that:Arrowlet<Tuple2<O,I>,Oi>):Channel<I,Oi,E>                 return Chnl.process(self,that);

  static public function prepare<I,O,E>(self:Reframe<I,O,E>,i:Outcome<I,E>,cont:Sink<Outcome<Tuple2<O,I>,E>>):Automation      return Arw.prepare(Arrowlet.lift(self.asRecallDef()),i,cont);
  static public function then<I,O,Oi,E>(self:Reframe<I,O,E>,that:Arrowlet<Outcome<Tuple2<O,I>,E>,Oi>):Arrowlet<Outcome<I,E>,Oi>                   return Arw.then(self,that);

  static public function attempt<I,O,Oi,E>(self:Reframe<I,O,E>,that:Attempt<O,Oi,E>):Reframe<I,Oi,E>                          return _().attempt(that,self);
  static public function arrange<I,O,Oi,E>(self:Reframe<I,O,E>,that:Arrange<O,I,Oi,E>):Reframe<I,Oi,E>                        return _().arrange(that,self);
  static public function rearrange<I,Ii,O,Oi,E>(self:Reframe<I,O,E>,that:O->Arrange<Ii,I,Oi,E>):Attempt<Tuple2<Ii,I>,Oi,E>    return _().rearrange(that,self);
  static public function commander<I,O,E>(self:Reframe<I,O,E>,fN:O->Command<I,E>):Reframe<I,O,E>                              return _().commander(fN,self);
  static public function evaluation<I,O,E>(self:Reframe<I,O,E>):Channel<I,O,E>                                                return _().evaluation(self);
  static public function execution<I,O,E>(self:Reframe<I,O,E>):Channel<I,I,E>                                                 return _().execution(self);
}