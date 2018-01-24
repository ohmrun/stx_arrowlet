package stx.arrowlet.core.head.data;

enum Fly<I,O>{
    Fly(i:I,cont:Sink<O>);
}