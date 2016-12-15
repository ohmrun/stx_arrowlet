package stx.async.arrowlet.head.data;

import stx.async.arrowlet.body.Arrowlet;

typedef RightChoice<B,C,D> = Arrowlet<Either<D,B>,Either<D,C>>