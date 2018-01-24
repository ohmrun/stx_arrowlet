package stx.arrowlet.core.head.data;

import stx.arrowlet.core.pack.Arrowlet in ArrowletA;

enum Bounce<T>{
  Call(arw:ArrowletA<Noise,Bounce<T>>);
  Done(v:T);
}
