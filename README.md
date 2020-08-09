## What Is It For?

This library is designed to abstract over Thread and Event programming, provide a natural, unobtrusive
and consistent interface, and is based on a theoretically sound scheduler framework.

## How does it work

An Arrowlet is an Asynchronous Function.


The input `I`
A handler function `O->Void` to put the output `O` into.

```haxe
I -> (O -> Void) -> Void
```

Under the hood, and with the use of combinators, you can obtain remote resources and apply methods
to them in a way that is not much different from regular functions.

These particular `Arrowlets` use the return value to return something to send to a scheduler

```haxe
I -> (O->Void) -> Work
```
 
with `Work`, you can either `submit` to the scheduler or `crunch` to *try* to get the result inline.

To run an `Arrowlet` at the head, use `environment`, which generally requires:

```
function environment(i:I,success:O->Void,failure:Res<E>->Void):Work
```

so:
```haxe
arrow.environment(
 1,
 __.logger(),
 __.crack,
).submit();
```

```haxe
public function applyII(i:I,cont:Terminal<O,E>):Work{
 ...
}
```

The constructor type is called `Arch`
```
using stx.Arw;
class Main{
  static function main(){
    Arch....
  }
}
```
Arch gives you a decision tree for accessing the various constructors of `Cascade` compatible arrowlets. Cascade is something like`Res<I,E> -> Res<O,E>`.
First you specify the input type constraint, then the output constraint, you mark whether you are inputting a synchronous or asynchronous thing, and the
constructor should be to hand.

```haxe
  Arch.defer()//Default on the input and output being Res so is Cascade<I,O,E>
  Arch.leave().value()//leave says you've specified Res as the input and need to specify the output. Rectify(Res<I,E> -> O)

  Arch.close()//no input, gives you constructors for Proceed, Forward and Execute.
      //Proceed(Void -> Res<O,E>)
    Arch.close();
      //Forward(Void -> O)
    Arch.close().value();
      //Execute(Void-> Option<Err<E>>)
    Arch.close().error();

  Arch.value();//value input, gives you constructors from Attempt, Command and Process
      //Attempt(I -> Res<O,E>)
    Arch.value();
      //Command(I -> Option<Err<E>>)
    Arch.value().error()
      //Process(I->O)
    Arch.value().value()

  //Defer gives you `cont` and `future` functions that help simplify integration. Any integrations you need just pop me a message.
```

Terminal is responsible internally for passing control flow along, and you don't normally need to expose the internals unless you're writing combinators.

As the `applyII` or `prepare` functions return `Work` to be done, if you're inside an async function, you need to pass the work forward of any arrowlets you are calling internally in the correct order.

Between `Terminal` and `Work`, there is an intermediate type responsible for the handling of the arrowlet return value, called `Receiver`.

```haxe
  public function applyII(i:I,cont:Terminal<O,E>):Work{
    var value  = cont.value(1);//Receiver<Int,E>;
    var result = value.serve();//Work
    return result;//OK
  }

  public function applyII(i:I,cont:Terminal<O,E>):Work{
    var defer     = Future.sync(Success())
    var value     = cont.value(1);//Receiver<Int,E>;
    var result    = value.serve();//Work
    return result;//OK
  }
```


Job is functionally equivalent to a `Coroutine` that produces a value `Halt(Production(o))` or
`Halt(Terminated(Early(err)))`. Producing the second of these bypasses any later function in the chain and is reported in `environment`

Work is like `Job` except the `O` type has been given a handler.

In order to return a value immediately, use `value` to produce a `Job`, and then `serve` to transform that to `Work`

```haxe
 public function applyII(i:I,cont:Terminal<O,E>):Work{
  return cont.value(f(i)).serve();
 }
```

The Constructor for this is found in `Arrowlet.Sync` 

In order to defer a value, use `defer`

```haxe
//Constructor in `Arrowlet.Future` 
 public function applyII(i:I,cont:Terminal<I,E>):Work{
  return cont.defer(ft).serve();
 }
```