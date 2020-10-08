package stx.arw;

class Arch{
  static function make<I,O,E>():ArchCls<I,O,E> return new ArchCls();
  static public function get<I,O,E>(self:Res<I,E>->Res<O,E>):Cascade<I,O,E>{
    return make().get(self);
  }
  static public function defer<I,O,E>():ArchDefer<I,O,E>{
    return make().defer();
  }
  static public function value<I,O,E>():ArchValue<I,O,E>{
    return make().value();
  }
  static public function error<I,O,E>():ArchError<I,O,E>{
    return make().error();
  }

  //shortcuts
  static public function convert(){
    return value().value();
  }
  static public function attempt(){
    return value();
  }
  static public function command(){
    return value().error();
  }
  static public function execute(){
    return make().close().error();
  }
  static public function resolve(){
    return make().error();
  }
  static public function provide(){
    return make().close().value();
  }
  static public function produce(){
    return make().close();
  }
}
class ArchCls<I,O,E>{
  public function new(){}
  public function get(self:Res<I,E>->Res<O,E>):Cascade<I,O,E>{
    return Cascade.lift(Arrowlet.Sync(self));
  }
  public function defer(){
    return new ArchDefer();
  }
  public function value(){
    return new ArchValue();
  }
  public function error(){
    return new ArchError();
  }
  public function leave(){
    return new ArchLeave();
  }
  public function close(){
    return new ArchClose();
  }
}
class ArchChunk<O,E> extends Clazz{
  
}
class ArchClose<O,E>{
  public function new(){}
  public function get(self:Void->Res<O,E>){
    return Produce.lift(Arrowlet.Sync((_:Noise) -> self()));
  }
  public function value(){
    return new ArchCloseValue();
  }
  public function defer(){
    return new ArchCloseDefer();
  }
  public function error(){
    return new ArchCloseError();
  }
}
class ArchCloseDefer<O,E>{
  public function new(){}
  public function get(self:Produce<O,E>){
    return self;
  }
  public function cont(self:(Res<O,E>->Void)->Void){
    return Produce.lift(Arrowlet.fromFunSink((_:Noise,cont) -> self(cont)));
  }
  public function future(self:Future<Res<O,E>>){
    return Produce.lift(Arrowlet.Fun1Future((_:Noise) -> self));
  }
}
class ArchCloseError<E>{
  public function new(){}
  public function get(self:Void->Report<E>){
    return Execute.lift(Arrowlet.Sync((_:Noise) -> self()));
  }
  public function cont(self:(Report<E>->Void)->Void){
    return Execute.lift(Arrowlet.fromFunSink((_:Noise,cont) -> self(cont)));
  }
  public function future(self:Future<Report<E>>){
    return Execute.lift(Arrowlet.Fun1Future((_:Noise) -> self));
  }
}
class ArchCloseValue<O,E>{
  public function new(){}
  public function get(self:Void->O){
    return Provide.lift(Arrowlet.Sync((_:Noise) -> self));
  }
  public function defer(){
    return new ArchCloseValueDefer();
  }
}
class ArchCloseValueDefer<O>{
  public function new(){}
  public function get(self:Provide<O>){
    return self;
  }
  public function cont(self:(O->Void)->Void){
    return Provide.lift(Arrowlet.fromFunSink((_:Noise,cont) -> self(cont)));
  }
  public function future(self:Future<O>){
    return Provide.lift(Arrowlet.Fun1Future((_:Noise)->self));
  }
}
class ArchLeave<I,O,E>{
  public function new(){}
  public function get(self:Res<I,E>->Res<O,E>):Cascade<I,O,E>{
    return Cascade.lift(Arrowlet.Sync(self));
  }
  public function value(){
    return new ArchLeaveValue();
  }
}
class ArchLeaveValue<I,O,E>{
  public function new(){}
  public function get(self:Res<I,E>->O){
    return Rectify.lift(Arrowlet.Sync(self));
  }
}
class ArchLeaveValueDefer<I,O,E>{
  public function new(){}
  public function get(self:Rectify<I,E,O>){
    return self;
  }
  public function cont(self:Res<I,E>->(O->Void)->Void){
    return Rectify.lift(Arrowlet.fromFunSink(self));
  }
  public function future(self:Res<I,E>->Future<O>){
    return Rectify.lift(Arrowlet.Fun1Future(self));
  }
}
class ArchError<I,O,E>{
  public function new(){}
  public function get(self:Err<E>->Chunk<O,E>){
    return Resolve.fromErrChunk(self);
  }
  public function defer(){
    return new ArchErrorDefer();
  }
  public function value(){
    return new ArchErrorValue();
  }
}
class ArchErrorValue<I,O,E>{
  public function new(){}
  public function get(self:Res<I,E>->O){
    return Rectify.lift(Arrowlet.Sync(self));
  }
}
class ArchErrorError<I,O,E,EE>{
  public function new(){}
  public function get(self:E->EE){
    return Cascade.unit().errate(self);
  }
}
class ArchErrorDefer<I,O,E>{
  public function new(){}
  public function get(self:Resolve<I,E>){
    return self;
  }
  public function cont(self:Err<E>->(Chunk<I,E> -> Void)->Void){
    return Resolve.lift(Arrowlet.fromFunSink(self));
  }
  public function future(self:Err<E>->Future<Chunk<I,E>>){
    return Resolve.lift(Arrowlet.Fun1Future(self));
  }
}
class ArchDefer<I,O,E>{
  public function new(){}
  public function get(self:Cascade<I,O,E>){
    return self;
  }
  public function cont(self:Res<I,E>->(Res<O,E>->Void)->Void){
    return Cascade.lift(Arrowlet.fromFunSink(self));
  }
  public function future(self:Res<I,E>->Future<Res<O,E>>){
    return Cascade.lift(Arrowlet.Fun1Future(self));
  }
}
class ArchValueDefer<I,O,E>{
  public function new(){}
  public function get(self:Attempt<I,O,E>){
    return self;
  }
  public function cont(self:I->(Res<O,E>->Void)->Void){
    return Attempt.lift(Arrowlet.fromFunSink(self));
  }
  public function future(self:I->Future<Res<O,E>>){
    return Attempt.lift(Arrowlet.Fun1Future(self));
  }
}
class ArchValue<I,O,E>{
  public function new(){}
  public function defer(){
    return new ArchValueDefer();
  }
  public function value(){
    return new ArchValueValue();
  }
  public function get(self:I->Res<O,E>){
    return Attempt.fromFun1Res(self);
  }
  public function error(){
    return new ArchErrorValue();
  }
}
class ArchValueError<I,O,E>{
  public function new(){}
  public function get(self:I->Report<E>){
    return Command.lift(Arrowlet.Sync(self));
  }
  public function defer(){
    return new ArchValueErrorDefer();
  }
}
class ArchValueErrorDefer<I,O,E>{
  public function new(){}
  public function get(self:Command<I,E>){
    return self;
  }
  public function cont(self:I->(Report<E>->Void)->Void){
    return Command.lift(Arrowlet.fromFunSink(self));
  }
  public function future(self:I->Future<Report<E>>){
    return Command.lift(Arrowlet.Fun1Future(self));
  }
}
class ArchValueValue<I,O,E>{
  public function new(){}
  public function get(self:I->O):Convert<I,O>{
    return Convert.fromFun1R(self);
  }
  public function defer(){
    return new ArchValueValueDefer();
  }
}
class ArchValueValueDefer<I,O,E>{
  public function new(){}
  public function get(self:Convert<I,O>){
    return self;
  }
  public function cont(fn:I->(O->Void)->Void){
    return Convert.lift(Arrowlet.fromFunSink(fn));
  }
  public function future(fn:I->Future<O>){
    return Convert.lift(Arrowlet.Fun1Future(fn));
  }
}
class ArchTest{
  
  public function new(){}
  public function test_arch(){ 
    var a = Arch.attempt().get((x:Int) -> __.accept(x));
    //$type(a);
    var b = Arch.attempt().defer().cont(
      (b:String,c) -> c(__.accept(b))
    );
    //$type(b);
    var c = Arch.execute().get(
      () -> Report.pure(__.fault().err(FailCode.E_AbstractMethod))
    );
    //$type(c);
  }
}