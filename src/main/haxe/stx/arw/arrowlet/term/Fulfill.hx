package stx.arw.arrowlet.term;

class Fulfill<I,O,E> implements ArrowletApi<Noise,O,E> extends stx.arw.Task<O,E>{
  var input    : I;
  var arrow    : Internal<I,O,E>;

  public function new(arrow:Internal<I,O,E>,input:I,?pos:Pos){
    super(pos);
    this.arrow    = arrow;
    this.input    = input;
  }
  public inline function defer(i:Noise,cont:Terminal<O,E>):Work{
    return this.arrow.defer(input,cont);
  }
  public function apply(i:Noise):O{
    return this.arrow.apply(input);
  }
  public var convention(get,default):Convention;
  public inline function get_convention():Convention{
    return this.arrow.convention;
  }
  public function asArrowletDef():ArrowletDef<Noise,O,E> return null;

  override public function get_defect():Defect<E>{
    return this.arrow.get_defect();
  }
  override public function get_result():Null<O>{
    return this.arrow.get_result();
  }
  override public function get_status():GoalStatus{ return this.arrow.get_status(); }

  override public function get_signal():tink.core.Signal<Noise>{
    return this.arrow.toWork().signal;
  }
  override public function pursue(){
    this.arrow.toWork().pursue();
  }
  override public function escape(){
    this.arrow.toWork().escape();
  }
  override public function toString(){
    return 'FulFill($arrow($input))';
  }
}