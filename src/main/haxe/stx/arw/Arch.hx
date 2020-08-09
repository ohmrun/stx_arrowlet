package stx.arw;

using stx.arw.Arch;

class Arch{
  static function make<I,O,E>():ArchCls<I,O,E>{
    return new ArchCls();
  }
  static public function get<I,O,E>(self:Res<I,E>->Res<O,E>):Cascade<I,O,E>{
    return make().get(self);
  }
  static public function of<I,O,E>(self:Res<I,E>->Res<O,E>):Cascade<I,O,E>{
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

  static public function process(){
    return value().value();
  }
  static public function attempt(){
    return value();
  }
}
class ArchCls<I,O,E>{
  public function new(){}
  public function get(self:Res<I,E>->Res<O,E>):Cascade<I,O,E>{
    return Cascade.lift(Arrowlet.Sync(self));
  }
  public function of(self:Res<I,E>->Res<O,E>):Cascade<I,O,E>{
    return get(self);
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
}
class ArchError<I,O,E>{
  public function new(){}
  public function get(self:Err<E>->Chunk<O,E>){
    return Resolve.fromErrChunk(self);
  }
  public function of(self:Err<E>->Chunk<O,E>){
    return get(self).toCascade();
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
  public function of(self:Res<I,E>->O){
    return get(self).toCascade();
  }
}
class ArchErrorError<I,O,E,EE>{
  public function new(){}
  public function get(self:E->EE){
    return Cascade.unit().errate(self);
  }
  public function of(self:E->EE){
    return Cascade.unit().errate(self).toCascade();
  }
}
class ArchErrorDefer<I,O,E>{
  public function new(){}
  public function get(self:Resolve<I,E>){
    return self;
  }
  public function of(self:Resolve<I,E>){
    return self.toCascade();
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
  public function of(self:Cascade<I,O,E>){
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
  public function of(self:Attempt<I,O,E>){
    return self.toCascade();
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
  public function of(self:I->Res<O,E>){
    return get(self).toCascade();
  }
}
class ArchValueValue<I,O,E>{
  public function new(){}
  public function get(self:I->O):Process<I,O>{
    return Process.fromFun1R(self);
  }
  public function of(self:I->O):Cascade<I,O,E>{
    return get(self).toCascade();
  }
  public function defer(){
    return new ArchValueValueDefer();
  }
}
class ArchValueValueDefer<I,O,E>{
  public function new(){}
  public function get(self:Process<I,O>){
    return self;
  }
  public function of(self:Process<I,O>){
    return self.toCascade();
  }
  public function cont(fn:I->(O->Void)->Void){
    return Process.lift(Arrowlet.fromFunSink(fn));
  }
  public function future(fn:I->Future<O>){
    return Process.lift(Arrowlet.Fun1Future(fn));
  }
}
class ArchTest{
  
  public function new(){}
  public function test_arch(){ 
    var a = Arch.attempt().get((x:Int) -> __.accept(x));
    $type(a);
    var b = Arch.attempt().defer().cont(
      (b:String,c) -> c(__.accept(b))
    );
    $type(b);
  }
}