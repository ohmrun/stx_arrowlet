package stx.arrowlet.body;

@:forward @:callable abstract RightSwitch<A,B,C,D>(Arrowlet<Either<A,B>,Either<A,D>>) from Arrowlet<Either<A,B>,Either<A,D>> to Arrowlet<Either<A,B>,Either<A,D>>{
  public function new(arw:Arrowlet<B,Either<A,D>>){
    this = Lift.fromContinue(function (i:Either<A,B>,cont:Continue<Either<A,D>>){
      switch (i){
        case      Left(l)      : cont(Left(l));
        case      Right(r)     : arw(r,cont);
      }
    });
  }
}
