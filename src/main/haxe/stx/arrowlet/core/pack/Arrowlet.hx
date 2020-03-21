package stx.arrowlet.core.pack;

import stx.arrowlet.core.pack.arrowlet.Constructor;

@:allow(stx.arrowlet.core.pack.arrowlet)
@:using(stx.arrowlet.core.pack.arrowlet.Implementation)
@:forward(applyII,asRecallDef)
abstract Arrowlet<I,O>(ArrowletDef<I,O>) from ArrowletDef<I,O> to ArrowletDef<I,O>{
  private function new(self:ArrowletDef<I,O>) this  = self;
  static public inline function _() return Constructor.ZERO;

  static public function lift<I,O>(self:ArrowletDef<I,O>):Arrowlet<I,O>                           return new Arrowlet(self);
  static public function unit<I>():Arrowlet<I,I>                                                  return _().unit();
  static public function pure<I,O>(o:O):Arrowlet<I,O>                                             return _().pure(o);

  static public function fromRecallFun<I,O>(f1OR):Arrowlet<I,O>                                   return _().fromRecallFun(f1OR);

  static public function Apply<I,O>():Arrowlet<Couple<Arrowlet<I,O>,I>,O>                         return _().Apply();


  @:from static public function fromFunXR<O>(fxr:Void->O):Arrowlet<Noise,O>                       return _().fromFunXR(fxr);
  @:from static public function fromFun2R<Ii,Iii,O>(f2r:Ii->Iii->O):Arrowlet<Couple<Ii,Iii>,O>    return _().fromFun2R(f2r);
  @:from static public function fromFun1R<I,O>(f1r:I->O):Arrowlet<I,O>                            return _().fromFun1R(f1r);
  //@:from static public function fromFunXX
  //@:from static public function fromFun1X

}