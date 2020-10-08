package stx.arw;

typedef StateDef<S,A> = ArrowletA<S,Couple<A,S>>;

@:provide @:callable abstract State<S,A>(StateDef<S,A>) from StateDef<S,A> to StateDef<S,A>{
  public function new(self:StateDef<S,A>){
    this = self;
  }
  @:noUsing static public function pure<S,A>(a:A):State<S,A>{
    return new State(function(s:S):Couple<A,S>{
      return __.couple(a,s);
    });
  }
  /**
   *  Using the outp
   ut Couple<A,S>, create a new S, dropping the old one
   *  @param arw1 - 
   *  @return StateDef<S,A>
   */
  public function change<S,A>(arw1:Arrowlet<Couple<A,S>,S>):StateDef<S,A>{
    return States.change(this,arw1);
  }
  /**
   *  Using the output Couple<A,S>, create a new A.
   *  @param arw1 - 
   *  @param B> - 
   *  @return StateDef<S,B>
   */
  public function modify<S,A,B>(arw1:Arrowlet<Couple<A,S>,B>):StateDef<S,B>{
    return States.modify(this,arw1);
  }
  /**
   *  After the State transformation, put a new S.
   *  @param v - 
   *  @return StateDef<S,A>
   */
  public function put<S,A,B>(v:S):StateDef<S,A>{
    return States.put(this,v);
  }
  /**
   *  Drop the A, replace with S after the current transformation
   *  @param arw0 - 
   *  @return StateDef<S,S>
   */
  //public function ret<S,A>(arw0:StateDef<S,A>):StateDef<S,S>{
} 
class StateLift{
  static public function change<S,A>(self:StateT<S,A>,that:Arrowlet<Couple<A,S>,S>):StateT<S,A>{
    return self.fan().then(that.second())
      .postfix(
        __.decouple(
          (l:Couple<A,S>,r:S) -> __.couple(l.fst(),r)
        )
      );
  }
  static public function modify<S,A,B>(self:StateT<S,A>,that:Arrowlet<Couple<A,S>,B>):StateT<S,B>{
    return self.joint(that)
      .postfix(
        (t:Couple<Couple<A,S>,B>) -> __.decouple(
         (l:Couple<A,S>,r:B) -> __.couple(r,l.snd())
        )(t)
      );
  }
  static public function put<S,A,B>(self:StateT<S,A>,v:S):StateT<S,A>{
    return Arrowlet.inj()._.postfix(
      function(tp:Couple<A,S>){
        return __.couple(tp.fst(),v);
      },
      self
    );
  }
  static public function ret<S,A>(self:StateT<S,A>):StateT<S,S>{
    return Arrowlet.inj()._.postfix(
      function(tp:Couple<A,S>){
        return __.couple(tp.snd(),tp.snd());
      },
      self
    );
  }
  static public function request<S,A>(self:StateT<S,A>):Arrowlet<S,A>{
    return self.postfix(
      function(t:Couple<A,S>){
        return t.fst();
      }
    );
  }
  
  static public function rectify<S,A>(self:StateT<S,A>){
    return self.then(
      function(t:Couple<A,S>){
        return t.snd();
      }
    );
  }
  static public function breakout<S,A>(arw:StateT<S,A>):Arrowlet<S,A>{
    return arw.then(
      function(x:Couple<A,S>):A{
        return x.fst();
      }
    );
  }
}