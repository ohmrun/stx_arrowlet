package stx.arw.only;

import stx.run.pack.recall.term.Base;

class Term<I,O> extends Base<Option<I>,Option<O>,Automation>{
  private var delegate : Arrowlet<I,O>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override private function doApplyII(i:Option<I>,cont:Sink<Option<O>>):Automation{
    return i.fold(
      (i) -> delegate.prepare(i,
        (o) -> cont(Some(o))
      ),
      ()  -> Automation.unit()
    );
  }
}