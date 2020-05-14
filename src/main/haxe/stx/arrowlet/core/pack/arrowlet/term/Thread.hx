package stx.arrowlet.core.pack.arrowlet.term;

abstract Thread(Arrowlet<Noise,Noise,Noise>) from Arrowlet<Noise,Noise,Noise>{
  public function submit(?scheduler):Void{
    this.prepare(
      Noise,
      Terminal.ZERO
    ).submit(
      scheduler
    );
  }
  public function crunch(?scheduler):Void{
    this.prepare(
      Noise,
      Terminal.ZERO
    ).crunch(
      scheduler
    );
  }
}