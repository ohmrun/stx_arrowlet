package stx.arw.arrowlet.term;

class Fulfill<I,O,E> implements ArrowletApi<Noise,O,E>{
  @:isVar public var id(get,null):Int;
  public function get_id():Int{
    return id == null ? id = Task.counter++ : id;
  }  
  var input    : I;
  var arrow    : Internal<I,O,E>;

  public function new(arrow:Internal<I,O,E>,input:I){
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

  public var loaded(get,null):Bool;
  public inline function get_loaded(){
    return this.status == Secured;
  }
  public function toWork():Work return Work.lift(this);
  public function toTaskApi():TaskApi<O,E> return this;

  public var defect(get,null):Defect<E>;
  public function get_defect():Defect<E>{
    return this.arrow.defect;
  }
  public var result(get,null):Null<O>;
  public function get_result():Null<O>{
    return this.arrow.result;
  }
  public var status(get,null):GoalStatus;
  public function get_status():GoalStatus{ return this.arrow.status; }

  public var signal(get,null):tink.core.Signal<Noise>;
  public function get_signal():tink.core.Signal<Noise>{
    return this.arrow.toWork().signal;
  }
  public function pursue(){
    this.arrow.toWork().pursue();
  }
  public function escape(){
    this.arrow.toWork().escape();
  }
  public function toString(){
    return 'FulFill($arrow($input))';
  }
  public function equals<Q:{id:Int}>(that:Q):Bool{
    return this.id == that.id;
  }
}