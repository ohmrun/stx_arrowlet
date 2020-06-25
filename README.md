## What Is It For?

This library is designed to abstract over Thread and Event programming, provide a natural, unobtrusive
and consistent interface, amd is based on a theoretically sound scheduler framework.

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
 __.raise,
).submit();
```


They also have a special type called `Terminal` to help aggregate `Work`. It *must* be the source of
the returned `Work` or the 

```haxe
public function applyII(i:I,cont:Terminal<O,E>):Work{
 ...
}
```

Terminal is a constructor of two types: `Job` and `Work`.

Job is a `Coroutine` that produces a value `Halt(Production(o))` or
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

It gets a little more complicated using multiple `Arrowlets`