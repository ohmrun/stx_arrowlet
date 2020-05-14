package stx.arrowlet.lift;

class LiftAction{
  static public function forward(self:Arrowlet<Noise,Noise>):Work{
    return self.prepare(Noise,Sink.unit());
  }
}