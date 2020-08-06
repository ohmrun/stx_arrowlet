package stx.arw;

typedef SequentDef<I,O,E> = ArrowletDef<Triple<O,I,Err<E>>,Triple<O,I,Err<E>>,Noise>;

abstract Sequent<I,O,E>(SequentDef<I,O,E>) from SequentDef<I,O,E> to SequentDef<I,O,E>{
  public function new(self) this = self;
  static public function lift<I,O,E>(self:SequentDef<I,O,E>):Sequent<I,O,E> return new Sequent(self);
  
  

  public function prj():SequentDef<I,O,E> return this;
  private var self(get,never):Sequent<I,O,E>;
  private function get_self():Sequent<I,O,E> return lift(this);
}