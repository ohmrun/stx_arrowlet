package stx.arrowlet.pack;

@:forward @:callable abstract Or<L, R, R0>(Arrowlet<Either<L,R>,R0>) from Arrowlet<Either<L,R>,R0> to Arrowlet<Either<L,R>,R0>{
  public function new(l:Arrowlet<L,R0>,r:Arrowlet<R,R0>){
    this = Lift.fromSink(function(i:Either<L,R>,cont:R0->Void){
      switch (i) {
        case Left(v)  : l(v,cont);
        case Right(v) : r(v,cont);
      }
    });
  }
}
