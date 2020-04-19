package stx.arrowlet.core.pack.arrowlet.term;

abstract Thread(Arrowlet<Noise,Noise,Noise>) from Arrowlet<Noise,Noise,Noise>{
  public function submit(?scheduler:Scheduler):Void{
    this.prepare(
      Noise,
      Terminal.ZERO
    ).submit(
      scheduler
    );
  }
}