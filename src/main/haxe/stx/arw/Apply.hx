package stx.arw;

interface ApplyApi<I,O,E> extends TaskApi<O,E>{
  public function apply(i:I):O;
}
typedef ApplyDef<I,O,E> = TaskDef<O,E> & {
  public function apply(i:I):O;
}
abstract class ApplyCls<I,O,E> extends stx.async.task.term.Once<O,E>{
  abstract public function apply(i:I):O;
}