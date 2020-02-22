package stx.arrowlet.core.pack;

@:forward @:callable abstract Or<L, R, R0>(Arrowlet<Either<L,R>,R0>) from Arrowlet<Either<L,R>,R0> to Arrowlet<Either<L,R>,R0>{
  public function  new(l:Arrowlet<L,R0>,r:Arrowlet<R,R0>){
    this = __.arw().cont()(
      (i,cont) -> switch(i){
        case Left(v)  : l.prepare(v,cont);
        case Right(v) : r.prepare(v,cont);
      }
    );
  }
}