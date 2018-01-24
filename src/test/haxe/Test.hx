package;

import haxe.PosInfos;
using stx.arrowlet.Lift;
import tink.CoreApi;
using stx.Tuple;
using stx.arrowlet.Package;

using Lambda;

class Test{
  static function main(){
    //CompileTime.importPackage("test");
    //CompileTime.importPackage("stx.async");

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

    var _ = 
      (str:String) ->
        (?pos:PosInfos) ->
          (v:Dynamic) -> {
            p2(str)(pos)(v);
            return v;
          }
    var a = function(x) {return Id(x,'a');}.tapO(p2('a')());
    var b = function(x) {return Id(x,'b');}.tapO(p2('b')());

    _('init')().tapO(p2('start')()).then(a).tapO(p2('after a')()).then(b).tapO(p2('after b')()).joint(
      (x) -> Id(x,'joint')
    ).tapO(p2('after joint')()).then(
        Bo
    ).tapO(p2('bound')()).bound(
      (x,y) -> Id(Jo(x,y),'bound')
    ).tapO(p2('pair')())
    //everything on the rhs passed through here->>>
    .pair(
      (x) -> Id(Ting(x),'pair')
    ).apply(tuple2(Id(Mump,'l'),Id(Mump,'r')))
     .handle(_('done')());

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
