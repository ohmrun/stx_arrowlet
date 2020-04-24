package stx.arrowlet.core.pack;

typedef TerminalDef<R,E> = JobDef<R,E>;

interface TerminalApi<R,E>{
  public function future():FutureTrigger<Res<R,E>>;
  
  public function issue(res:Res<R,E>):Receiver<R,E>;
  public function value(r:R):Receiver<R,E>;
  public function error(err:Err<E>):Receiver<R,E>;

  public function defer(ft:Future<Res<R,E>>):Receiver<R,E>;

  public function inner<RR,EE>(join:Res<RR,EE> -> Void):Terminal<RR,EE>;

  public function toTerminalApi():TerminalApi<R,E>;
}
@:forward abstract Terminal<R,E>(TerminalApi<R,E>) from TerminalApi<R,E> to TerminalApi<R,E>{
  public function new(){
    this = new TerminalBase();
  }
}
class TerminalBase<R,E> implements TerminalApi<R,E>{
  public function new(){}
  public function future():FutureTrigger<Res<R,E>>{
    return Future.trigger();
  }

  public function issue(res:Res<R,E>):Receiver<R,E>{
    return Receiver.lift(Job.issue(res));
  }
  public function value(r:R):Receiver<R,E>{
    return issue(__.success(r));
  }
  public function error(err:Err<E>):Receiver<R,E>{
    return issue(__.failure(err));
  }


  public function defer(ft:Future<Res<R,E>>):Receiver<R,E>{
    return Receiver.lift(Job.defer(ft));
  }
  
  
  public function inner<RR,EE>(join:Res<RR,EE> -> Void):Terminal<RR,EE>{
    return new SubTerminal(join).toTerminalApi();
  }

  public function toTerminalApi():TerminalApi<R,E>{
    return this;
  }
}
class SubTerminal<R,E> extends Terminal<R,E>{
  private var join : Res<R,E> -> Void;
  public function new(join:Res<R,E>->Void){
    this.join = join;
  }
  override public function issue(res:Res<R,E>):Receiver<R,E>{
    return Receiver.lift(Job.issue(res).later(join));
  }

  override public function defer(ft:Future<Res<R,E>>):Receiver<R,E>{
    return Receiver.lift(Job.defer(ft).later(join));
  }
  
}
abstract Receiver<R,E>(JobDef<R,E>){
  public function new(self) this = self;
  static public function lift<R,E>(self:JobDef<R,E>):Receiver<R,E>{
    return new Receiver(self);
  }
  public function after(res:Response):Response{
    return res.seq(Job._.serve(this));
  }
  public function later(handler:Res<R,E>->Void):Receiver<R,E>{
    return lift(Job._.later(this,handler));
  }
  public function serve():Response{
    return Job._.serve(this);
  }
  @:from static public function fromFutureResponse<E>(ft:Future<Response>):Response{
    return Agenda.fromFutureAgenda(ft);
  }
} 