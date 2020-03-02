package;

class Main{
  static function main(){
    #if (test=="stx_arrowlet")
      utest.UTest.run(new stx.arrowlet.core.pack.Test().deliver());
    #end
  } 
}
