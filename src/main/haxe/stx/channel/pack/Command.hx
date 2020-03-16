package stx.channel.pack;


@:using(stx.arrowlet.core.pack.arrowlet.Implementation)
@:forward abstract Command<I,E>(CommandDef<I,E>) from CommandDef<I,E> to CommandDef<I,E>{
  public function new(self){
    this = self;
  }
  static public function fromFun1Option<I,E>(fn:I->Option<TypedError<E>>){
    return Arrowlet.fromFun1R((i) -> new Report(fn(i)));
  }
  static public function fromFun1EIO<I,E>(fn:I->EIO<E>){
    return Recall.Anon(
      (i,cont) -> fn(i).duoply(Automation.unit(),cont)
    );
  }
  static public function lift<I,E>(self:CommandDef<I,E>):Command<I,E>{
    return new Command(self);
  }
  public function toChannel():Channel<I,I,E>{
    return Channel.fromCommand(self.postfix(report -> report.prj()));
  }
  public function prj():CommandDef<I,E>{
    return this;
  }
  public function and(that:Command<I,E>):Command<I,E>{
    return self.split(that).postfix(
      (tp) -> tp.fst().merge(tp.snd())
    );
  }
  public function forward(i:I):EIO<E>{
    return Recall.Anon(
      (auto:Automation,cont:Sink<Report<E>>) -> auto.snoc(self.prepare(i,cont))
    );
  }
  public function errata<EE>(fn:TypedError<E>->TypedError<EE>){
    return self.postfix((report) -> report.errata(fn));
  }
  private var self(get,never):Command<I,E>;
  private function get_self():Command<I,E> return this;

  @:to public function toArw():Arrowlet<I,Report<E>>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,E>(self:Arrowlet<I,Report<E>>):Command<I,E>{
    return lift(self.asRecallDef());
  }
} 