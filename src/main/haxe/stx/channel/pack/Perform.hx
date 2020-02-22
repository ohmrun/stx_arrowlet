package stx.channel.pack;

import stx.channel.type.Perform in PerformT;

abstract Perform(PerformT) from PerformT to PerformT{
  public function new(self) this = self;
  static public function lift(self:PerformT):Perform return new Perform(self);
  

  

  public function prj():PerformT return this;
  private var self(get,never):Perform;
  private function get_self():Perform return lift(this);
}