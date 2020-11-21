package stx.arw.attempt;

class AttemptArrange<P,O,Oi,E> extends ArrowletCls<P,Res<Oi,E>,Noise>{
  var lhs : Attempt<P,O,E>;
  var rhs : Arrange<O,P,Oi,E>;
  public function new(lhs:Attempt<P,O,E>,rhs:Arrange<O,P,Oi,E>){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public function defer(p:P,cont:Terminal<Res<Oi,E>,Noise>):Work{
    return lhs.prepare(p,cont.joint(
      (outcome:Outcome<Res<O,E>,Array<Noise>>) -> 
        outcome.fold(
          (res) -> res.fold(
            (lhs) -> rhs.defer(__.accept(__.couple(lhs,p)),cont),
            (e)   -> cont.value(__.reject(e)).serve()
          ),
          (_)   -> cont.error([Noise]).serve()
        )
    ));
  }
  override public function apply(p:P):Res<Oi,E>{
    return this.convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> lhs.apply(p).fold(
        (lhs) -> rhs.apply(__.accept(__.couple(lhs,p))),
        (e)   -> throw(e)
      )
    );
  }
  override public function get_convention(){
    return this.lhs.convention || this.rhs.convention;
  }
  override public function toString(){
    return '${this.name()}($lhs -> $rhs)';
  }
}