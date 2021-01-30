package stx.arw.arrowlet.term;

class Completion<P,R,E> extends ArrowletCls<Noise,Noise,Noise>{
  public function new(context,process){
    super();
    this.context = context;
    this.process = process;
  }
  public var context(default,null):Contextualize<P,R,E>;
  public var process(default,null):Arrowlet<P,R,E>;

  public function apply(p:Noise):Noise{
    var result : R = this.process.toInternal().apply(context.environment);
        context.on_value(result);
        
    return Noise;
  }
  public function defer(p:Noise,cont:Terminal<Noise,Noise>):Work{
    return this.process.toInternal().defer(
      this.context.environment,
      @:privateAccess new Terminal().joint(
        (outcome) -> outcome.fold(
          ok -> {
            context.on_value(ok); Work.unit();
          },
          no -> {
            context.on_error(no); Work.unit();
          }
        )
      )
    );
  }
}