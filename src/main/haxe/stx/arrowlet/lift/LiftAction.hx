package stx.arrowlet.lift;

class LiftAction{
  static public function forward(Self:Arrowlet<Noise,Noise>):Automation{
    return self.prepare(Noise,Sink.unit());
  }
}