package stx.arw;

class Log{
  static public function log(wildcard:Wildcard):stx.Log{
    return new stx.Log().tag("stx.arw");
  }
}