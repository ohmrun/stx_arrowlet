package stx.arw.arrowlet.term;

class SplitFun<P,Ri,Rii,E> extends ArrowletCls<P,Couple<Ri,Rii>,E>{
  
  public var lhs(default,null):Internal<P,Ri,E>;
  public var rhs(default,null):P->Rii;

  public function new(lhs:Internal<P,Ri,E>,rhs:P->Rii){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public function apply(p:P):Couple<Ri,Rii>{
    return __.couple(lhs.apply(p),rhs(p));
  }
  override public function defer(p:P,cont:Terminal<Couple<Ri,Rii>,E>):Work{
    return lhs.defer(
      p,
      cont.joint(
        (outcome:Outcome<Ri,Defect<E>>) -> cont.issue(
          outcome.fold(
            (ok) -> __.success(__.couple(ok,rhs(p))),
            (no) -> __.failure(no)
          )
        ).serve()
      )
    );
  }
  override public function get_convention(){
    return this.lhs.convention;
  }
}