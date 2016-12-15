package stx.async.arrowlet.head.data;

import stx.async.arrowlet.body.Arrowlet;

typedef LeftChoice<B,C,D> = Arrowlet<Either<B,D>,Either<C,D>>