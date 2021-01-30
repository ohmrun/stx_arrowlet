package stx.arw;
        
typedef RecoverDef<I,E>                 = ArrowletDef<Err<E>,I,Noise>;

@:using(stx.arw.arrowlet.Lift)
@:forward abstract Recover<I,E>(RecoverDef<I,E>) from RecoverDef<I,E> to RecoverDef<I,E>{
  public inline function new(self) this = self;
  @:noUsing static public inline function lift<I,E>(self:RecoverDef<I,E>) return new Recover(self);

  @:from static public function fromFunErrR<I,E>(fn:Err<E>->I):Recover<I,E>{
    return lift(Arrowlet.Sync(fn));
  }
  public function toCascade():Cascade<I,I,E> return new RecoverCascade(this);
  public function toRectify():Rectify<I,I,E> return new RecoverRectify(this);

  public inline function prj():RecoverDef<I,E>{
    return this;
  }
  public inline function toArrowlet():Arrowlet<Err<E>,I,Noise>{
    return Arrowlet.lift(this);
  }
} 
class RecoverRectify<I,E> extends ArrowletCls<Res<I,E>,I,Noise>{
  var delegate : Recover<I,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  public function defer(p:Res<I,E>,cont:Terminal<I,Noise>){
    return p.fold(
      ok -> cont.value(ok).serve(),
      no -> delegate.prepare(
        no,
        cont.joint(
          (outcome:Reaction<I>) -> outcome.fold(
            (ok) -> cont.value(ok).serve(),
            (no) -> cont.error(no).serve()
          )
        )
      )
    );
  }
  public function apply(p:Res<I,E>):I{
    return p.fold(
      ok -> ok,
      no -> delegate.toArrowlet().toInternal().apply(no)
    );
  }
}
class RecoverCascade<I,E> extends ArrowletCls<Res<I,E>,Res<I,E>,Noise>{
  var delegate : Recover<I,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  public function defer(p:Res<I,E>,cont:Terminal<Res<I,E>,Noise>){
    return p.fold(
      (i) -> {
        return cont.value(__.accept(i)).serve();
      },
      (e:Err<E>) -> {
        return delegate.prepare(
          e,
          cont.joint(
            (outcome:Outcome<I,Array<Noise>>) -> 
              cont.value(
                outcome.fold(
                  (i) -> __.accept(i),
                  (_) -> __.reject(__.fault().err(FailCode.E_ResourceNotFound))
                )
              ).serve()
          )
        );
      }
    );
  }
  public function apply(p:Res<I,E>){
    return p.fold(
      ok -> __.accept(ok),
      no -> __.accept(delegate.toArrowlet().toInternal().apply(no))
    );
  }
}