package stx.channel.pack;

abstract Execute<E>(ExecuteDef<E>) from ExecuteDef<E> to ExecuteDef<E>{
  public function new(self) this = self;
  static public function lift<E>(self:ExecuteDef<E>):Execute<E> return new Execute(self);
  

  

  public function prj():ExecuteDef<E> return this;
  private var self(get,never):Execute<E>;
  private function get_self():Execute<E> return lift(this);
}