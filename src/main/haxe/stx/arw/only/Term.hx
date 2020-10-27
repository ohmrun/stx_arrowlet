package stx.arw.only;

class Term<I,O> extends ArrowletBase<Option<I>,Option<O>,Automation>{
  private var delegate : Arrowlet<I,O>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function applyII(i:Option<I>,cont:Sink<Option<O>>):Automation{
    return i.fold(
      (i) -> delegate.prepare(i,
        (o) -> cont(Some(o))
      ),
      ()  -> Automation.unit()
    );
  }
}