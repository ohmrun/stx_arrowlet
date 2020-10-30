package stx.arw.arrowlet.term;

class Finisher<I,O,E> implements ArrowletApi<I,Noise,Noise>{
  var success  : O -> Void;
  var failure  : Defect<E> -> Void;
  var arrow    : Arrowlet<I,O,E>;

  public function new(arrow,success:O->Void,failure:Defect<E> -> Void){
    this.arrow   = arrow;
    this.success = success;
    this.failure = failure;
  }
  inline public function apply(i:I):Noise{
    return convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> {
        success(this.arrow.apply(i));
        return Noise;
      }
    );
  }
  inline public function defer(i:I,cont:Terminal<Noise,Noise>):Work{
    __.log().debug('environment: $arrow');
    var defer = TinkFuture.trigger();
    var inner = cont.inner(handler.bind(defer));

    return cont.later(defer).after(arrow.prepare(i,inner));
  }
  inline function handler(defer:FutureTrigger<stx.Outcome<Noise,Defect<Noise>>>,outcome:stx.Outcome<O,Defect<E>>){
    outcome.fold(success,failure);
    defer.trigger(__.success(Noise));
  }
  public var convention(get,default):Convention;
  public inline function get_convention():Convention{
    return this.arrow.convention;
  }
  public function asArrowletDef():ArrowletDef<I,Noise,Noise> return null;

  public var loaded(get,null):Bool;
  public inline function get_loaded(){
    return this.status == Secured;
  }
  public inline function toWork():Work return Work.lift(this);
  public inline function toTaskApi():TaskApi<Noise,Noise> return this;

  public var signal(get,null):tink.core.Signal<Noise>;
  public inline function get_signal():tink.core.Signal<Noise>{
    return this.arrow.signal;
  }
  public var defect(get,null):Defect<Noise>;
  public inline function get_defect():Defect<Noise>{
    return Defect.unit();
  }
  public var result(get,null):Null<Noise>;
  public inline function get_result():Null<Noise>{
    return Noise;
  }
  public var status(get,null):GoalStatus;
  public inline function get_status():GoalStatus{ return this.arrow.status; }

  public inline function pursue(){
    this.arrow.pursue();
  }
  public inline function escape(){
    this.arrow.escape();
  }
}