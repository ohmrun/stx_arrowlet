package stx.channel.pack;

import stx.channel.type.Execute in ExecuteT;

abstract Execute<E>(ExecuteT<E>) from ExecuteT<E> to ExecuteT<E>{
  public function new(self) this = self;
  static public function lift<E>(self:ExecuteT<E>):Execute<E> return new Execute(self);
  

  

  public function prj():ExecuteT<E> return this;
  private var self(get,never):Execute<E>;
  private function get_self():Execute<E> return lift(this);
}