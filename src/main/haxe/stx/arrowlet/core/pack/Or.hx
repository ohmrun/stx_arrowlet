package stx.arrowlet.core.pack;

@:forward @:callable abstract Or<L, R, R0>(Arrowlet<Either<L,R>,R0>) from Arrowlet<Either<L,R>,R0> to Arrowlet<Either<L,R>,R0>{
  public function new(l:Arrowlet<L,R0>,r:Arrowlet<R,R0>){
    this = function(i:Either<L,R>,cont:Sink<R0>){
      switch (i) {
        case Left(v)  : l.withInput(v,cont);
        case Right(v) : r.withInput(v,cont);
      }
      return () -> {};
    };
  }
}
