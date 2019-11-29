package;

using Lambda;
import haxe.PosInfos;


import stx.core.head.Data;
import tink.CoreApi;
import stx.core.Package;

using stx.core.Lift;
using stx.arrowlet.Lift;

import stx.arrowlet.Package;



class Test{
  static function main(){


    var a = new utest.Runner();
    //utest.ui.Report.create(a);
    var arr : Array<Dynamic> = [
      #if (js && !nodejs)
        //new stx.arrowlet.js.JQueryEventTest()
      #end
    ];
    arr.iter(
      function(x){
        a.addCase(x);
      }
    );
    //a.run();
    var p = (?pos:haxe.PosInfos) -> (v:Dynamic) -> haxe.Log.trace(v,pos);
    var p2 = (str:String) -> 
      (?pos:PosInfos) -> 
        (v:Dynamic) -> p(pos)('$str:: $v');

    var print = 
      (str:String) ->
        (?pos:PosInfos) ->
          (v:Dynamic) -> {
            p2(str)(pos)(v);
            return v;
          }
    var a = 
      __.arrowlet(
        function(x) {return Id(x,'a');}
      ).tapO(p2('a')());
    var b = __.arrowlet(
        function(x) {return Id(x,'b');}).tapO(p2('b')()
      );

    print('init')().toArrowlet()
      .tapO(p2('start')())
      .then(a).tapO(p2('after a')())
      .then(b).tapO(p2('after b')())
      .joint(
        (x) -> Id(x,'joint')
      ).tapO(p2('after joint')()).then(
        Bo
      ).tapO(p2('bound')()).bound(
        (x,y) -> Id(Jo(x,y),'bound')
      ).tapO(p2('pair')())
      //everything on the rhs passed through here->>>
      .both(
        (x) -> Id(Ting(x),'pair')
      ).apply(tuple2(Id(Mump,'l'),Id(Mump,'r')))
       .handle(print('done')());

    var ft = Future.trigger();
        ft.asFuture().then(
          function(x,cont){
            cont(x*3);
            return ()  -> {}
          }
        ).handle(
          function(x){
            trace(x);
          }
        );
        ft.trigger(10);  
  }
}
enum Stuff{
  Bo(l:Stuff,r:Stuff);
  Jo(l:Stuff,r:Stuff);
  Mump;
  Ting(stuff:Stuff);
  Id(stuff:Stuff,name:String);
}
