package stx.arw;

class ContextualizeCls<P,R,E>{
  public var environment(default,null):P;
  public function new(environment){
    this.environment = environment;
  }
  public dynamic function on_error(e:Defect<E>):Void{
    __.crack(e);
  }
  public dynamic function on_value(r:R):Void{
    __.log().debug((ctr) -> ctr.pure(r));
  }
}
@:forward abstract Contextualize<P,R,E>(ContextualizeCls<P,R,E>) from ContextualizeCls<P,R,E> to ContextualizeCls<P,R,E>{
  @:noUsing static public function pure<P,R,E>(environment:P):Contextualize<P,R,E>{
    return make(environment);
  }
  @:noUsing static public function make<P,R,E>(environment:P,?on_value:R->Void,?on_error:Defect<E>->Void):Contextualize<P,R,E>{
    var result = new ContextualizeCls(environment);
    if(__.option(on_value).is_defined()){
      result.on_value = on_value;
    }
    if(__.option(on_error).is_defined()){
      result.on_error = on_error;
    }
    return result;
  }
  @:from static public function fromInput<P,R,E>(environment:P):Contextualize<P,R,E>{
    return make(environment);
  }
  public function load(arrowlet:ArrowletDef<P,R,E>):Fiber{
    return Fiber.lift(new stx.arw.arrowlet.term.Completion(this,Arrowlet.lift(arrowlet)));
  }
}