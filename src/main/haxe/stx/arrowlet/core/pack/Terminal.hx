package stx.arrowlet.core.pack;

typedef TerminalDef<R,E> = JobDef<R,E>;

interface TerminalApi<R,E>{
  public function future():FutureTrigger<Outcome<R,E>>;
  
  public function issue(res:Outcome<R,E>):Receiver<R,E>;
  public function value(r:R):Receiver<R,E>;
  public function error(err:E):Receiver<R,E>;

  public function defer(ft:Future<Outcome<R,E>>):Receiver<R,E>;


  public function inner<RR,EE>(join:Outcome<RR,EE> -> Void):Terminal<RR,EE>;

  public function toTerminalApi():TerminalApi<R,E>;
}
@:forward abstract Terminal<R,E>(TerminalApi<R,E>) from TerminalApi<R,E> to TerminalApi<R,E>{
  static public var ZERO = new Terminal();
  public function new(){
    this = new TerminalBase();
  }
}
class TerminalBase<R,E> implements TerminalApi<R,E>{
  public function new(){}
  public function future():FutureTrigger<Outcome<R,E>>{
    return Future.trigger();
  }

  public function issue(res:Outcome<R,E>):Receiver<R,E>{
    return Receiver.lift(Job.issue(res));
  }
  public function value(r:R):Receiver<R,E>{
    return issue(Success(r));
  }
  public function error(err:E):Receiver<R,E>{
    return issue(Failure(err));
  }
  public function defer(ft:Future<Outcome<R,E>>):Receiver<R,E>{
    return Receiver.lift(Job.defer(ft));
  }
  
  public function inner<RR,EE>(join:Outcome<RR,EE> -> Void):Terminal<RR,EE>{
    return new SubTerminal(join).toTerminalApi();
  }

  public function toTerminalApi():TerminalApi<R,E>{
    return this;
  }
}
class SubTerminal<R,E> extends TerminalBase<R,E>{
  private var join : Outcome<R,E> -> Void;
  public function new(join:Outcome<R,E>->Void){
    super();
    this.join = join;
  }
  override public function issue(res:Outcome<R,E>):Receiver<R,E>{
    return Receiver.lift(Job.issue(res).later(join));
  }
  override public function defer(ft:Future<Outcome<R,E>>):Receiver<R,E>{
    return Receiver.lift(Job.defer(ft).later(join));
  }
}
abstract Receiver<R,E>(JobDef<R,E>){
  public function new(self) this = self;
  static public function lift<R,E>(self:JobDef<R,E>):Receiver<R,E>{
    return new Receiver(self);
  }
  public function after(res:Work):Work{
    return res.seq(Job._.serve(this));
  }
  public function later(handler:Outcome<R,E>->Void):Receiver<R,E>{
    return lift(Job._.later(this,handler));
  }
  public function serve():Work{
    return Job._.serve(this);
  }
  //@:from static public function fromFutureResponse<E>(ft:Future<Work>):Work{
    //return Agenda.fromFutureAgenda(ft);
  //}
} 