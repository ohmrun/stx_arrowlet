package stx.arw;

typedef CascadeDef<I, O, E> = ArrowletDef<Res<I, E>, Res<O, E>, Noise>;

@:using(stx.arw.Cascade.CascadeLift)
@:forward abstract Cascade<I, O, E>(CascadeDef<I, O, E>) from CascadeDef<I, O, E> to CascadeDef<I, O, E> {
	static public var _(default, never) = CascadeLift;

	public inline function new(self) this = self;

	@:noUsing static public inline function lift<I, O, E>(self:ArrowletDef<Res<I, E>, Res<O, E>, Noise>):Cascade<I, O, E> {
		return new Cascade(self);
	}

	static public function unit<I, O, E>():Cascade<I, I, E> {
		return lift(Arrowlet.fromFun1R((oc:Res<I, E>) -> oc));
	}

	@:noUsing static public function pure<I, O, E>(o:O):Cascade<I, O, E> {
		return fromRes(__.accept(o));
	}
	@:noUsing static inline public function Fun<I,O,E>(fn:I->O):Cascade<I,O,E>{
		return fromFun1R(fn);
	}
  @:noUsing static inline public function fromFun1Res<I, O, E>(fn:I -> Res<O, E>):Cascade<I, O, E> {
		return lift(Arrowlet.fromFun1R((ocI:Res<I, E>) -> ocI.fold((i : I) -> fn(i), (e:Err<E>) -> __.reject(e))));
  }
  @:noUsing static public function fromFun1R<I, O, E>(fn:I -> O ):Cascade<I, O, E> {
		return lift(Arrowlet.fromFun1R((ocI:Res<I, E>) -> ocI.fold((i : I) -> __.accept(fn(i)), (e:Err<E>) -> __.reject(e))));
	}
	@:noUsing static public function fromRes<I, O, E>(ocO:Res<O, E>):Cascade<I, O, E> {
		return lift(Arrowlet.fromFun1R((ocI:Res<I, E>) -> ocI.fold((i : I) -> ocO, (e:Err<E>) -> __.reject(e))));
	}
	@:from @:noUsing static public function fromFunResRes0<I,O,E>(fn:Res<I,E>->Res<O,E>):Cascade<I,O,E>{
		return lift(Arrowlet.Sync(
			(res:Res<I,E>) -> res.fold(
				ok -> fn(__.accept(ok)),
				no -> __.reject(no)
			)
		));
	}
	@:from @:noUsing static public function fromFunResRes<I,O,E,EE>(fn:Res<I,E>->Res<O,EE>):Cascade<I,O,EE>{
		return lift(Arrowlet.Sync(
			(res:Res<I,EE>) -> res.fold(
				ok -> fn(__.accept(ok)),
				no -> __.reject(no)
			)
		));
	}
	@:noUsing static public function fromArrowlet<I, O, E>(arw:Arrowlet<I, O, E>):Cascade<I, O, E> {
		return lift(new stx.arw.cascade.term.ArrowletCascade(arw));
	}

	@:noUsing static public function fromAttempt<I, O, E>(self:Attempt<I,O,E>):Cascade<I, O, E> {
		return new stx.arw.cascade.term.AttemptCascade(self);
	}

	@:noUsing static public function fromProduce<O, E>(arw:Arrowlet<Noise, Res<O, E>, Noise>):Cascade<Noise, O, E> {
		return new stx.arw.cascade.term.ProduceCascade(arw);
	}

	@:from @:noUsing static public function fromFun1Produce<I, O, E>(arw:I->Produce<O, E>):Cascade<I, O, E> {
		return lift(Arrowlet.Anon((i:Res<I, E>, cont:Terminal<Res<O, E>, Noise>) -> i.fold((i) -> arw(i).prepare(cont), typical_fail_handler(cont))));
	}

	static private function typical_fail_handler<O, E>(cont:Terminal<Res<O, E>, Noise>) {
		return (e:Err<E>) -> cont.value(__.reject(e)).serve();
	}

	@:to public inline function toArrowlet():Arrowlet<Res<I, E>, Res<O, E>, Noise> return this;

	public inline function environment(i:I, success:O->Void, failure:Err<E>->Void):Fiber {
		return _.environment(this, i, success, failure);
	}
	public inline function split<Oi>(that:Cascade<I, Oi, E>):Cascade<I, Couple<O, Oi>, E> {
		return _.split(this, that);
	}
	public inline function prefix<Ii>(fn:Ii->I):Cascade<Ii, O, E> {
		return _.prefix(this, fn);
  }
  public inline function convert<Oi>(that:Convert<O, Oi>):Cascade<I, Oi, E> {
		return _.convert(this, that);
  }
  public inline function broach():Cascade<I, Couple<I,O>,E>{ 
    return _.broach(this);
	}
	public inline function flat_map<Oi>(fn:O->Cascade<I,Oi,E>):Cascade<I,Oi,E>{
		return _.flat_map(this,fn);
	}
}

class CascadeLift {
	static public inline function prepare<I, O, E>(self:Cascade<I, O, E>, i:Res<I, E>, cont:Terminal<Res<O, E>, Noise>) {
		return Arrowlet._.prepare(self, i, cont);
	}

	static private function lift<I, O, E>(self:ArrowletDef<Res<I, E>, Res<O, E>, Noise>):Cascade<I, O, E> {
		return new Cascade(self);
	}

	static public function or<Ii, Iii, O, E>(self:Cascade<Ii, O, E>, that:Cascade<Iii, O, E>):Cascade<Either<Ii, Iii>, O, E> {
		return lift(Arrowlet.Anon((ipt:Res<Either<Ii, Iii>, E>, cont:Terminal<Res<O, E>, Noise>) -> switch (ipt) {
			case Accept(Left(l)): self.prepare(Accept(l), cont);
			case Accept(Right(r)): that.prepare(Accept(r), cont);
			case Reject(e): typical_fail_handler(cont)(e);
		}));
	}

	static public function errata<I, O, E, EE>(self:Cascade<I, O, E>, fn:Err<E>->Err<EE>):Cascade<I, O, EE> {
		return lift(Arrowlet.Anon((i:Res<I, EE>,
				cont:Terminal<Res<O, EE>, Noise>) -> i.fold((i:I) -> Arrowlet._.postfix(self,o -> o.errata(fn)).prepare(__.accept(i), cont), typical_fail_handler(cont))));
	}

	static public function errate<I, O, E, EE>(self:Cascade<I, O, E>, fn:E->EE):Cascade<I, O, EE> {
		return errata(self, (e) -> e.map(fn));
	}

	static public function reframe<I, O, E>(self:Cascade<I, O, E>):Reframe<I, O, E> {
		return lift(new stx.arw.reframe.term.CascadeReframe(self));
	}

	static public function cascade<I, O, Oi, E>(self:Cascade<I, O, E>, that:Cascade<O, Oi, E>):Cascade<I, Oi, E> {
		return lift(Arrowlet.Then(self, that));
	}

	static public function attempt<I, O, Oi, E>(self:Cascade<I, O, E>, that:Attempt<O, Oi, E>):Cascade<I, Oi, E> {
		return cascade(self, that.toCascade());
	}

	static public function convert<I, O, Oi, E>(self:Cascade<I, O, E>, that:Convert<O, Oi>):Cascade<I, Oi, E> {
		return cascade(self, that.toCascade());
	}

	static public function postfix<I, O, Oi, E>(self:Cascade<I, O, E>, fn:O->Oi):Cascade<I, Oi, E> {
		return convert(self, Convert.fromFun1R(fn));
	}

	static public function prefix<I, Ii, O, E>(self:Cascade<I, O, E>, fn:Ii->I):Cascade<Ii, O, E> {
		return lift(Cascade.fromArrowlet(Arrowlet.fromFun1R(fn)).then(self));
	}

	static function typical_fail_handler<O, E>(cont:Terminal<Res<O, E>, Noise>):Err<E>->Work {
		return (e:Err<E>) ->  cont.value(__.reject(e)).serve();
	}

	@:noUsing static public inline function environment<I, O, E>(self:Cascade<I, O, E>, i:I, success:O->Void, failure:Err<E>->Void):Fiber {
		return Arrowlet._.environment(self, __.accept(i), (res) -> res.fold(success, failure), (err) -> throw err);
	}

	static public function provide<I, O, E>(self:Cascade<I, O, E>, i:I):Produce<O, E> {
		return Produce.lift(Arrowlet.Anon((_:Noise, cont) -> self.prepare(__.accept(i), cont)));
	}

	static public function reclaim<I, O, Oi, E>(self:Cascade<I, O, E>, that:Convert<O, Produce<Oi, E>>):Cascade<I, Oi, E> {
		return lift(cascade(self,
			that.toCascade()).attempt(Attempt.lift(Arrowlet.Anon((prd:Produce<Oi, E>, cont:Terminal<Res<Oi, E>, Noise>) -> prd.prepare(cont)))));
	}

	static public function arrange<I, O, Oi, E>(self:Cascade<I, O, E>, then:Arrange<O, I, Oi, E>):Cascade<I, Oi, E> {
		return lift(Arrowlet.Anon((i:Res<I, E>, cont:Terminal<Res<Oi, E>, Noise>) -> {
			var bound = Future.trigger();
			var inner = cont.inner((outcome:Outcome<Res<O, E>, Array<Noise>>) -> {
				var input = outcome.fold((res) -> res.fold((lhs) -> i.fold((i) -> then.prepare(__.couple(lhs, i), cont),
					(e) -> cont.value(__.reject(e)).serve()),
					(e) -> cont.value(__.reject(e)).serve()),
					(_) -> cont.error([Noise]).serve());
				bound.trigger(input);
			});
			var lhs = self.prepare(i, inner);
			return lhs.seq(bound);
		}));
	}

	static public function split<I, Oi, Oii, E>(self:Cascade<I, Oi, E>, that:Cascade<I, Oii, E>):Cascade<I, Couple<Oi, Oii>, E> {
		return lift(Arrowlet._.split(self, that).postfix(__.decouple(Res._.zip)));
  }
  
  static public function broach<I, O, E>(self:Cascade<I, O, E>):Cascade<I, Couple<I,O>,E>{
    return lift(Arrowlet._.broach(
      self
    ).then(
      Arrowlet.Sync(
        (tp:Couple<Res<I,E>,Res<O,E>>) -> tp.decouple(
          (lhs,rhs) -> lhs.zip(rhs)
        )
      )
    ));
	}
	static public function flat_map<I,O,Oi,E>(self:Cascade<I,O,E>,fn:O->Cascade<I,Oi,E>):Cascade<I,Oi,E>{
		return lift(Arrowlet.FlatMap(
			self,
			(res:Res<O,E>)->res.fold(
				ok -> fn(ok),
				no -> Cascade.fromRes(__.reject(no))
			)
		));
	}
	static public function command<I,O,E>(self:Cascade<I,O,E>,that:Command<O,E>):Cascade<I,O,E>{
    return Cascade.lift(
      Arrowlet.Then(
        self,
        Arrowlet.Anon(
          (ipt:Res<O,E>,cont:Terminal<Res<O,E>,Noise>) -> ipt.fold(
            o -> that.produce(Produce.pure(o)).prepare(o,cont),
            e -> cont.value(__.reject(e)).serve()
          )
        )
      )
    );
  }
}