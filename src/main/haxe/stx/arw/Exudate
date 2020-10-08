package stx.arw;

typedef ExudateDef<I,O,E> = ArrowletDef<Chunk<I,E>,Chunk<O,E>,Noise>;

@:using(stx.arw.Exudate.ExudateDef)
abstract Exudate<I,O,E>(ExudateDef<I,O,E>) from ExudateDef<I,O,E> to ExudateDef<I,O,E>{
  static public var _(default,never) = ExudateLift;
  public function new(self) this = self;
  static public function lift<I,O,E>(self:ExudateDef<I,O,E>):Exudate<I,O,E> return new Exudate(self);

  
  @:from static public function fromFunIOptionR<I,O,E>(fn:I->Option<O>):Exudate<I,O,E>{
    return lift(
      Arrowlet.Anon(
        (ipt:Chunk<I,E>,cont:Terminal<Chunk<O,E>,Noise>) -> {
          return ipt.fold(
            (o) -> cont.value(fn(o).fold(
              (o) -> Val(o),
              ()  -> Tap
            )).serve(),
            (e) -> cont.value(End(e)).serve(),
            ()  -> cont.value(Tap).serve()
          );
        }
      )
    );
  }
  @:from static public function fromOptionIR<I,O,E>(fn:Option<I>->O):Exudate<I,O,E>{
    return lift(
      Arrowlet.Anon(
        (ipt:Chunk<I,E>,cont:Terminal<Chunk<O,E>,Noise>) -> {
          return ipt.fold(
           (i)  -> cont.value(Val(fn(Some(i)))).serve(),
           (e)  -> cont.value(End(e)).serve(),
           ()   -> cont.value(Val(fn(None))).serve()
          );
        }
      )
    );
  }
  public function prj():ExudateDef<I,O,E> return this;
  private var self(get,never):Exudate<I,O,E>;
  private function get_self():Exudate<I,O,E> return lift(this);

  public function toArrowlet():Arrowlet<Chunk<I,E>,Chunk<O,E>,Noise>{
    return Arrowlet.lift(this);
  }
}
class ExudateLift{
  static private inline function lift<I,O,E>(self:ExudateDef<I,O,E>):Exudate<I,O,E> return Exudate.lift(self);
}