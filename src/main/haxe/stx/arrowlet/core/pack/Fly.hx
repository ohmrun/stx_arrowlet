package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.Data.Fly in FlyT;

@:forward abstract Fly<I,O>(FlyT<I,O>) from FlyT<I,O> to FlyT<I,O>{
    public function new(self){
        this = self;
    }
    public function into(fn : I -> (O->Void) -> Block):Block{
        return switch(this){
            case Fly(i,cont) : fn(i,cont);
        }
    }
    /*
    @:to public function toFunction():I->Handler<O>->Block{
        return switch(this){
            case Fly(fn) : fn;
        }
    }
    
    public var f(get,never) : I -> Handler<O> -> Block;
    private function get_f(): I -> Handler<O> -> Block{
        return this.toFunction();
    }*/
}