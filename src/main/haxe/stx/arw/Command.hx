package stx.arw;
        
typedef CommandDef<I,E>                 = ArrowletDef<I,Report<E>,Noise>;

@:using(stx.arw.arrowlet.Lift)
@:using(stx.arw.Command.CommandLift)
@:forward abstract Command<I,E>(CommandDef<I,E>) from CommandDef<I,E> to CommandDef<I,E>{
  static public var _(default,never) = CommandLift;
  public function new(self){
    this = self;
  }
  static public function unit<I,E>():Command<I,E>{
    return lift(Arrowlet.Sync((i:I)->Report.unit()));
  }
  static public inline function lift<I,E>(self:CommandDef<I,E>):Command<I,E>{
    return new Command(self);
  }
  @:from static public function fromFun1Void<I,E>(fn:I->Void):Command<I,E>{
    return lift(Arrowlet.Sync(__.passthrough(fn).fn().then((_)->Report.unit())));
  }
  @:from static public function fromFun1Report<I,E>(fn:I->Report<E>):Command<I,E>{
    return lift(Arrowlet.fromFun1R((i) -> fn(i)));
  }
  static public function fromFun1Option<I,E>(fn:I->Option<Err<E>>):Command<I,E>{
    return lift(Arrowlet.fromFun1R((i) -> Report.fromOption(fn(i))));
  } 
  static public function fromArrowlet<I,E>(self:Arrowlet<I,Noise,E>):Command<I,E>{
    return lift(new stx.arw.command.term.ArrowletCommand(self));
  }
  @:from static public function fromFun1Execute<I,E>(fn:I->Execute<E>):Command<I,E>{
    return lift(
      Arrowlet.Anon(
        (i:I,cont) -> fn(i).prepare(cont)
      )
    );
  }
  public function toCascade():Cascade<I,I,E>{
    return Cascade.lift(new stx.arw.cascade.term.CommandCascade(this));
  }
  public function prj():CommandDef<I,E>{
    return this;
  }
  public inline function toArrowlet():Arrowlet<I,Report<E>,Noise>{
    return this;
  }
  public function and(that:Command<I,E>):Command<I,E>{
    return lift(self.split(that.toArrowlet()).postfix(
      (tp) -> tp.fst().merge(tp.snd())
    ));
  }
  public function errata<EE>(fn:Err<E>->Err<EE>){
    return self.postfix((report) -> report.errata(fn));
  }
  public function provide(i:I):Execute<E>{
    return Execute.lift(
      Arrowlet.Anon((_:Noise,cont:Terminal<Report<E>,Noise>) -> prepare(i,cont))
    );
  }
  private var self(get,never):Command<I,E>;
  private function get_self():Command<I,E> return this;

  public inline function prepare(i:I,cont){
    return Arrowlet._.prepare(this,i,cont);
  }
} 
class CommandLift{
  static public function produce<I,O,E>(command:Command<I,E>,produce:Produce<O,E>):Attempt<I,O,E>{
    return Attempt.lift(
      Arrowlet.Then(
        command.toArrowlet(),
        Arrowlet.Anon(
          (ipt:Report<E>,cont:Terminal<Res<O,E>,Noise>) -> ipt.fold(
            e   -> cont.value(__.reject(e)).serve(),
            () -> produce.prepare(cont)
          )
        )
      )
    );
  }
}