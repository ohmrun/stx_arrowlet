package stx.arw;

@:forward(apply,defer,defect,result,status,convention,signal)
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
}