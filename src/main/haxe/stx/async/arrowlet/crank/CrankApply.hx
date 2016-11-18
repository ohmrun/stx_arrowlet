package stx.async.arrowlet.crank;

using stx.Tuple;

typedef CrankApplyIn<A,B> = Tuple2<Crank<A,B>,Chunk<A>>;
typedef CrankApplyT<A,B>  = Arrowlet<CrankApplyIn<A,B>,Chunk<B>>;

@:forward @:callable abstract CrankApply<A,B>(CrankApplyT<A,B>) from CrankApplyT<A,B> to CrankApplyT<A,B>{
  public function new(self){
    this = self;
  }
  public function apply(ipt:CrankApplyIn<A,B>){
    this(
      ipt,
      function(cont){

      }
    );
  }
}
/*
function(tp:Tuple2<Crank<A,B>,Chunk<A>>,cont){
        var l = tp.fst();
        $type(l);
        var r = tp.snd();
        $type(r);
        l(r,cont);
        return null;
      }
*/