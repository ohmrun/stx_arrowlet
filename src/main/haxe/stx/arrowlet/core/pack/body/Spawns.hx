package stx.arrowlet.core.pack.body;

class Spawns{
  public function edit<A,B>(spn:SpawnType<A>,arw:Arrowlet<A,B>):Spawn<B>{
    return new Spawn(spn).edit(arw);
  }
  public function attempt<A,B>(spn:SpawnType<A>,arw:Arrowlet<A,Chunk<B>>):Spawn<B>{
    return new Spawn(spn).attempt(arw);
  }
  static public function split<A,B>(spn0:SpawnType<A>,spn1:Spawn<B>):Spawn<Tuple2<A,B>>{
    return new Spawn(spn0).split(spn1);
  }
  static public function toCrank<A,B>(spn:SpawnType<A>):Crank<B,A>{
    return new Spawn(spn).toCrank();
  }
}