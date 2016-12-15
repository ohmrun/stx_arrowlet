package stx.async.arrowlet.head.data;

import stx.async.arrowlet.body.Arrowlet;

typedef Only<I,O> = Arrowlet<Option<I>,Option<O>>;