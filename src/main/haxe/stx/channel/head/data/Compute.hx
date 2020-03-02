package stx.channel.head.data;

enum Further
enum Compute<I,O,Z,E>{
  CProcessFunction(fn:Unary<I,O>);
  CProcessArrowlet(arw:Arrwolet<I,O>);

  CAttemptFunction(fn:Unary<I,Outcome<O,E>>);
  CAttemptArrowlet(arw:Arrowlet<I,Outcome<O,E>>);

  CCommandFunction(fn:Unary<I,Option<TypedError<E>>);
  CCommandArrowlet(arw:Arrowlet<I,Option<TypedError<E>>);


}