package stx.arw.cascade.term;

class ProduceCascade<O,E> extends ArrowletCls<Res<Noise,E>,Res<O,E>,Noise>{
  var delegate : ProduceDef<O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  //Arrowlet.Anon((i:Res<Noise, E>, cont:Terminal<Res<O, E>, Noise>) -> i.fold((_) -> arw.prepare(_, cont), typical_fail_handler(cont)))
  public inline function apply(p:Res<Noise,E>):Res<O,E>{
    return p.fold(
      ok -> delegate.apply(ok),
      no -> __.reject(no)
    );
  }
  public inline function defer(p:Res<Noise,E>,cont:Terminal<Res<O,E>,Noise>):Work{
    return p.fold(
      ok -> Arrowlet.lift(delegate).toInternal().defer(ok,cont),
      no -> cont.value(__.reject(no)).serve()
    );
  }
}