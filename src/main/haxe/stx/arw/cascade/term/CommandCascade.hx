package stx.arw.cascade.term;

class CommandCascade<T,E> extends ArrowletCls<Res<T,E>,Res<T,E>,Noise>{
  var delegate : Command<T,E>;

  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function apply(p:Res<T,E>):Res<T,E>{
    return p.fold(
      (ok) -> Arrowlet.lift(delegate).toInternal().apply(ok).fold(
        er -> __.reject(er),
        () -> p
      ),
      (no) -> __.reject(no)
    );
  }
  override public function defer(p:Res<T,E>,cont:Terminal<Res<T,E>,Noise>):Work{
    return p.fold(
      ok -> Arrowlet.lift(delegate).toInternal().defer(
        ok,
        cont.joint(joint.bind(p,_,cont))
      ),
      no -> cont.value(__.reject(no)).serve()
    );
  }
  private function joint(input:Res<T,E>,outcome:Outcome<Report<E>,Defect<Noise>>,cont:Terminal<Res<T,E>,Noise>){
    return outcome.fold(
      (report:Report<E>) -> report.fold(
        err -> cont.value(__.reject(err)).serve(),
        ()  -> cont.value(input).serve()
      ),
      (e) -> cont.error(e).serve()
    );
  }
}
// return Cascade.lift(
//   Arrowlet.Anon(
//     (i:Res<I,E>,cont:Terminal<Res<I,E>,Noise>) -> {
//       i.fold(
//         (i:I) -> {
//           var defer = Future.trigger();
//           var inner = cont.inner(
//             (res:Outcome<Report<E>,Array<Noise>>) -> {
//               var value : Res<I,E> = res.fold(
//                ok   -> Res.fromReport(ok).map( _ -> i ),
//                (_)  -> __.accept(i)
//               );
//               defer.trigger(__.success(value));
//             }
//           );
//           return cont.later(defer).after(this.prepare(i,inner));
//         },
//         (e:Err<E>) -> {
//           return cont.value(__.reject(e)).serve();
//         }
//       );
//     }
//   )
// );