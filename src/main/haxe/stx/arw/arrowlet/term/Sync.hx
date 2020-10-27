package stx.arw.arrowlet.term;

class Sync<I,O,E> extends ArrowletBase<I,O,E>{
  private var input    : I;
  private var delegate : I->O;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public inline function apply(v:I){
    return this.delegate(v);
  }
  override public inline function pursue():Void{
    throw('do not use this like this');
  }
  override public inline function applyII(i:I,cont:Terminal<O,E>):Work{
    throw('do not use this like this');
  }
}