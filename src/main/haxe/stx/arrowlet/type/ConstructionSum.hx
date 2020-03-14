package stx.arrowlet.type;

enum ConstructionSum<I,O>{
  InjInputReceiver(fn:I -> (O->Void) -> Automation);
  InjInputReactor(fn:I -> (O->Void) -> Void);
  InjSync(fn:I->O);
  //AutomationConstructor(fn:O->Automation<I,O>);
}