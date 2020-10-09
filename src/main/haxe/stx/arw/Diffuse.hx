package stx.arw;

typedef DiffuseDef<I,O,E> = ArrowletDef<Chunk<I,E>,Chunk<O,E>,Noise>;

@:using(stx.arw.Diffuse.DiffuseDef)
abstract Diffuse<I,O,E>(DiffuseDef<I,O,E>) from DiffuseDef<I,O,E> to DiffuseDef<I,O,E>{
  static public var _(default,never) = DiffuseLift;
  public function new(self) this = self;
  static public function lift<I,O,E>(self:DiffuseDef<I,O,E>):Diffuse<I,O,E> return new Diffuse(self);

  
  @:from static public function fromFunIOptionR<I,O,E>(fn:I->Option<O>):Diffuse<I,O,E>{
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
  @:from static public function fromOptionIR<I,O,E>(fn:Option<I>->O):Diffuse<I,O,E>{
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
  public function prj():DiffuseDef<I,O,E> return this;
  private var self(get,never):Diffuse<I,O,E>;
  private function get_self():Diffuse<I,O,E> return lift(this);

  public function toArrowlet():Arrowlet<Chunk<I,E>,Chunk<O,E>,Noise>{
    return Arrowlet.lift(this);
  }
}
class DiffuseLift{
  static private inline function lift<I,O,E>(self:DiffuseDef<I,O,E>):Diffuse<I,O,E> return Diffuse.lift(self);
}