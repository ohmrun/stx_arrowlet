package stx.arw.arrowlet.term;

class Broach<I,O,E> extends SplitArw<I,I,O,E>{
  public function new(inner:Internal<I,O,E>){
    super((x:I) -> x,inner);
  }
}