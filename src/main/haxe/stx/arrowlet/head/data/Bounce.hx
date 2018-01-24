package stx.arrowlet.head.data;

import stx.arrowlet.pack.Arrowlet in ArrowletA;

enum Bounce<T>{
  Call(arw:ArrowletA<Noise,Bounce<T>>);
  Done(v:T);
}
