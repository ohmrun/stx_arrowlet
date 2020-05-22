package stx.arrowlet.core.pack.arrowlet.term;

abstract Thread(Arrowlet<Noise,Noise,Noise>) from Arrowlet<Noise,Noise,Noise>{
  static public function lift(self:Arrowlet<Noise,Noise,Noise>):Thread{
    return self;
  }
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