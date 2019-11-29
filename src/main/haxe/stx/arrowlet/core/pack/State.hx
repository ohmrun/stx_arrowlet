package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.data.State in StateT;

@:forward @:callable abstract State<S,A>(StateT<S,A>) from StateT<S,A> to StateT<S,A>{
  public function new(self:StateT<S,A>){
    this = self;
  }
  @:noUsing static public function pure<S,A>(a:A):State<S,A>{
    return new State(function(s:S):Tuple2<A,S>{
      return tuple2(a,s);
    });
  }
  /**
   *  Using the output Tuple2<A,S>, create a new S, dropping the old one
   *  @param arw1 - 
   *  @return StateT<S,A>
   */
  public function change<S,A>(arw1:Arrowlet<Tuple2<A,S>,S>):StateT<S,A>{
    return States.change(this,arw1);
  }
  /**
   *  Using the output Tuple2<A,S>, create a new A.
   *  @param arw1 - 
   *  @param B> - 
   *  @return StateT<S,B>
   */
  public function modify<S,A,B>(arw1:Arrowlet<Tuple2<A,S>,B>):StateT<S,B>{
    return States.modify(this,arw1);
  }
  /**
   *  After the State transformation, put a new S.
   *  @param v - 
   *  @return StateT<S,A>
   */
  public function put<S,A,B>(v:S):StateT<S,A>{
    return States.put(this,v);
  }
  /**
   *  Drop the A, replace with S after the current transformation
   *  @param arw0 - 
   *  @return StateT<S,S>
   */
  //public function ret<S,A>(arw0:StateT<S,A>):StateT<S,S>{
} 