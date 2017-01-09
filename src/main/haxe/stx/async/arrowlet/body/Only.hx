package stx.async.arrowlet.body;

import stx.Chunk;
import stx.async.arrowlet.head.data.Only in OnlyT;

@:callable @:forward abstract Only<I,O>(OnlyT<I,O>) from OnlyT<I,O> to OnlyT<I,O>{
  public function new(arw:Arrowlet<I,O>){
    this = Lift.fromSink(function(v:Option<I>,cont:Sink<Option<O>>){
      switch (v) {
        case Some(v) : arw.then(Some)(v,cont);
        case None    : cont(None);
      }
    });
  }
  public function toCrank():Crank<I,O>{
    return new Crank(Lift.fromSink(
      function(ipt,cont){
        switch(ipt){
          case Val(v) : this(Some(v),
            function(opt){
              switch(opt){
                case Some(v)  : cont(Val(v));
                case None     : cont(Nil);
              }
            }
          );
          case Nil    : cont(Nil);
          case End(e) : cont(End(e));
        }
      }
    ));
  }
}
