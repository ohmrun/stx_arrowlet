package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.data.Action in ActionT;

abstract Action(ActionT) from ActionT to ActionT{
  public function new(self:ActionT) this = self;
  static public function lift(self:ActionT):Action return new Action(self);

  public function prj():ActionT return this;
  private var self(get,never):Action;
  private function get_self():Action return lift(this);


  public function  forward():Automation{
    return this.prepare(Noise,Sink.unit());
  }
}