package stx.arw.arrowlet.term;

class Deliver<I,O,E> implements ArrowletApi<I,Noise,Noise> extends stx.arw.Task<Noise,Noise>{
  var success  : O -> Void;
  var failure  : Defect<E> -> Void;
  var arrow    : Internal<I,O,E>;

  public function new(arrow,success:O->Void,failure:Defect<E> -> Void,?pos:Pos){
    super(pos);
    this.arrow   = arrow;
    this.success = success;
    this.failure = failure;
  }
  inline public function apply(i:I):Noise{
    success(this.arrow.apply(i));
    return Noise;
  }
  inline public function defer(i:I,cont:Terminal<Noise,Noise>):Work{
    //__.log().debug('environment: $arrow');
    return arrow.defer(i,cont.joint((outcome) -> {
      //__.log().debug(outcome);
      outcome.fold(success,failure);
      return Work.ZERO;
    }));
  }
  public var convention(get,default):Convention;
  public inline function get_convention():Convention{
    return this.arrow.convention;
  }
  public function asArrowletDef():ArrowletDef<I,Noise,Noise> return null;

  override public inline function get_signal():tink.core.Signal<Noise>{
    return this.arrow.signal;
  }
  override public inline function get_defect():Defect<Noise>{
    return Defect.unit();
  }
  override public inline function get_result():Null<Noise>{
    return Noise;
  }
  override public inline function get_status():GoalStatus{ return this.arrow.get_status(); }

  override public inline function pursue(){
    this.arrow.toWork().pursue();
  }
  override public inline function escape(){
    this.arrow.toWork().escape();
  }
  override public function toString(){
    return 'Deliver($arrow)';
  }
}