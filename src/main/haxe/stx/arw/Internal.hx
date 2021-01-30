package stx.arw;

/**
  Arrowlets make use of `stx.async.Task` but shouldn't normally use that functionality.
  This class allows access if you're doing something high-fallutin.
**/
@:forward(apply,defer,get_defect,get_result,get_status,convention,signal)
@:allow(stx) 
abstract Internal<I,O,E>(ArrowletDef<I,O,E>) from ArrowletDef<I,O,E>{
  @:from static private inline function lift<I,O,E>(def:Arrowlet<I,O,E>){
    return new Internal(def);
  }
  public inline function toWork():Work{
    return this.toWork();
  }
  public inline function toArrowlet():Arrowlet<I,O,E>{
    return this;
  }
  private inline function new(self) this = self;

  public inline function get_defect(){
    return this.get_defect();
  }
}