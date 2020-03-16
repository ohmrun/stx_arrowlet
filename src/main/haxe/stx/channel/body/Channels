package stx.channel.body;

class Channels extends Clazz{

  public function process<I,O,Z,E>(that:Arrowlet<O,Z>,thiz:Channel<I,O,E>):Channel<I,Z,E>{
    return thiz.then(stx.channel.head.Channels.fromArrowlet(that));
  }  
  public function then<I,O,Z,E>(that:Channel<O,Z,E>,thiz:Channel<I,O,E>):Channel<I,Z,E>{
    return Channel.lift(thiz.prj().then(that.prj()));
  }
  public function postfix<I,O,Z,E>(fn:O->Z,thiz:Channel<I,O,E>){
    return process(
      __.arw().fn(fn),
      thiz
    );
  }
  public function prefix<A,I,O,E>(fn:A->I,thiz:Channel<I,O,E>):Channel<A,O,E>{
    return then(
      thiz,
      fn.broker(
        F -> 
        __.arw().fn()
          .then(stx.channel.head.Channels.fromArrowlet)
      )
    );
  }
}