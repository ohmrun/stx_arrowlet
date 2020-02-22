package stx.arrowlet.core.head.data;

typedef Attempt<I,O,E> = Arrowlet<I,Chunk<O,E>>;