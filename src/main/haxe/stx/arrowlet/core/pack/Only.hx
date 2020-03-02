package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.data.Only in OnlyT;

@:callable @:forward abstract Only<I,O>(OnlyT<I,O>) from OnlyT<I,O> to OnlyT<I,O>{
  public function  new(arw:Arrowlet<I,O>){
    this = __.arw().cont()(method.bind(arw));
  }
  static private function method<I,O>(arw:Arrowlet<I,O>,opt:Option<I>,cont:Sink<Option<O>>){
    return opt.map(
      (i) -> arw.postfix(Some.fn().then(_ -> _.core())).fulfill(i)
    ).defv(
      __.arw().fn()(_ -> None.core())
    ).prepare(Noise,cont);
  }
}
