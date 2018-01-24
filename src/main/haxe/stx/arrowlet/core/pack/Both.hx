package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.Data.Both in BothT;

@:forward @:callable abstract Both<A,B,C,D>(BothT<A,B,C,D>) from BothT<A,B,C,D> to BothT<A,B,C,D>{
  public function new(fst:ArrowletT<A,B>,snd:ArrowletT<C,D>){
	this = (t:Tuple2<A,C>,cont:Sink<Tuple2<B,D>>) -> {
		var cancelled = false;	
		var a :Option<B> = None;
		var b :Option<D> = None;
		function ready():Bool{
			return (a != None) && (b != None);
		}
		function go(){
			switch([ready(),cancelled,a,b]){
				case[true,false,Some(l),Some(r)] : cont(tuple2(l,r));
				default:
			}
		}

		fst(Fly(t.fst(),
			function(x){
				a = Some(x);
				go();
			}
		));
		snd(Fly(t.snd(),
			function(x){
				b = Some(x);
				go();
			}
		));	
		return () -> cancelled = true;
	}/*
    this = new Arrowlet(function(t:Tuple2<A,C>,cont:Handler<Tuple2<B,D>>){
    	
    });*/
  }
}
/*class Both<A,B,C,D>	extends Combinator<A,B,C,D,Tuple2<A,C>,Tuple2<B,D>>{
//(ArrowletBoth<A,B,C,D>) from ArrowletBoth<A,B,C,D> to ArrowletBoth<A,B,C,D>{
	override public function apply(i : Tuple2<A,C>):Future<Tuple2<B,D>>{
		var otrg = Future.trigger();

		var ol : Option<B> 	= null;
		var or : Option<D> 	= null;

		var merge 	=
			function(l:B,r:D){
				otrg.trigger( tuple2(l,r) );
			}
		var check 	=
			function(){
				if (((ol!=null) && (or!=null))){
					merge(Options.valOrC(ol,null),Options.valOrC(or,null));
				}
			}
		var hl 		=
			function(v:B){
				ol = v == null ? None : Some(v);
				check();
			}
		var hr 		=
			function(v:D){
				or = v == null ? None : Some(v);
				check();
			}
		fst.apply(i.fst()).handle(hl);
		snd.apply(i.snd()).handle(hr);

		return otrg.asFuture();
	}
}*/
