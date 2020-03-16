package stx.arrowlet.core.pack.arrowlet;

import stx.arrowlet.Pack.Arrowlet     in Arw;
import stx.core.Package.Tuple2        in Tup2;

class Implementation{
  static public inline function inj<I,O>()  return Arw._();

  static public function prepare<I,O>(self:Arw<I,O>,i:I,cont:Sink<O>):Automation                               return inj()._.prepare(i,cont,self);
  static public function fulfill<I,O>(self:Arw<I,O>,i:I):Arw<Noise,O>                                          return inj()._.fulfill(i,self);
  static public function deliver<I,O>(self:Arw<I,O>,cb:O->Void):Arw<I,Noise>                                   return inj()._.deliver(cb,self);
  
  static public function inject<I,Oi,Oii>(self:Arw<I,Oi>,v:Oii):Arw<I,Oii>                                     return inj()._.inject(v,self);
  static public function then<I,Oi,Oii>(lhs:Arw<I,Oi>, rhs:Arw<Oi,Oii>):Arw<I,Oii>                             return inj()._.then(rhs,lhs);
  static public function first<Ii,Iii,O>(self:Arw<Ii,O>):Arw<Tup2<Ii,Iii>,Tup2<O,Iii>>                         return inj()._.first(self);
  static public function second<Ii,O,Iii>(self:Arw<Ii,O>):Arw<Tup2<Iii,Ii>,Tup2<Iii,O>>                        return inj()._.second(self);
  static public function split<I, Oi, Oii>(lhs:Arw<I, Oi>, rhs:Arw<I, Oii>):Arw<I,Tup2<Oi,Oii>>                return inj()._.split(rhs,lhs);
  static public function both<Ii,Oi,Iii,Oii>(lhs:Arw<Ii,Oi>,rhs:Arw<Iii,Oii>):Arw<Tup2<Ii,Iii>,Tup2<Oi,Oii>>   return inj()._.both(rhs,lhs);
  static public function swap<I,Oi,Oii>(self:Arw<I,Tup2<Oi,Oii>>):Arw<I,Tup2<Oii,Oi>>                          return inj()._.swap(self);
  static public function fan<I,O>(self:Arw<I,O>):Arw<I,Tup2<O,O>>                                              return inj()._.fan(self);
  
  static public function joint<I,Oi,Oii>(lhs:Arw<I,Oi>,rhs:Arw<Oi,Oii>):Arw<I,Tup2<Oi,Oii>>                    return inj()._.joint(rhs,lhs);
  static public function bound<I,Oi,Oii>(lhs:Arw<I,Oi>,rhs:Arw<Tup2<I,Oi>,Oii>):Arw<I,Oii>                     return inj()._.bound(rhs,lhs);
  static public function or<Ii,Iii,O>(lhs:Arw<Ii,O>,rhs:Arw<Iii,O>):Arw<Either<Ii,Iii>,O>                      return inj()._.or(rhs,lhs);
  
  static public function prefix<I,Ii,O>(self:Arw<Ii,O>,fn:I->Ii):Arw<I,O>                                      return inj()._.prefix(fn,self);
  static public function postfix<I,Oi,Oii>(self:Arw<I,Oi>,fn:Oi->Oii):Arw<I,Oii>                               return inj()._.postfix(fn,self);

  /**
    The $rhs Arrowlet returns an Arrowlet. The resulting Arrowlet calls $lhs with its output.
  **/
  static public function inform<I,Oi,Oii>(lhs:Arw<I,Oi>,rhs:Arw<Oi,Arw<Oi,Oii>>):Arw<I,Oii>                    return inj()._.inform(rhs,lhs);
  static public function broach<I,O>(self:Arw<I,O>):Arw<I,Tup2<I,O>>                                           return inj()._.broach(self);

  static public function left<I,Oi,Oii>(self:Arw<I,Oi>):Arw<Either<I,Oii>,Either<Oi,Oii>>                      return inj()._.left(self);
  static public function right<I,Oi,Oii>(self:Arw<I,Oi>):Arw<Either<Oii,I>,Either<Oii,Oi>>                     return inj()._.right(self);

  /**
    Sprinkle liberally, as this operator orchestrates two tasks seperated by an asyncronous step.

    l_automation = 
  **/
  static public function flat_map<I,Oi,Oii>(self:Arw<I,Oi>,fn:Oi->Arw<I,Oii>):Arw<I,Oii>                       return inj()._.flat_map(fn,self);
}