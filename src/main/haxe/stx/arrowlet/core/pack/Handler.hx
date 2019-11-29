package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.Data.Handler in HandlerT;

@:forward  abstract Handler<T>(HandlerT<T>) from HandlerT<T>{
    @:from static public function fromFunction<T>(fn:T->Void):Handler<T>{
        return {
            upply : (v:T) -> {
                fn(v);
                return () -> {}
            }
        }
    }
    public function new(self){
        this = self;
    }
}