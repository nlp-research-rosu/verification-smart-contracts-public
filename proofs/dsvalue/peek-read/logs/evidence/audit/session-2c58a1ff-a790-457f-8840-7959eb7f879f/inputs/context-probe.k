requires "verification.k"
module CONTEXT-PROBE
  imports VERIFICATION
  claim [peek]:
    <k> #execute ~> CONTINUATION:K => #halt ~> CONTINUATION </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <gas> #gas(VGAS:Int) => ?FINAL_GAS:Gas </gas>
    <program> #dsValueRuntime </program>
    <jumpDests> #computeValidJumpDests(#dsValueRuntime) </jumpDests>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <wordStack> .WordStack => ?FINAL_STACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEMORY:Bytes </localMem>
    <memoryUsed> 0 => ?FINAL_MEMORY_USED:Int </memoryUsed>
    <callData> #abiCallData("peek", .TypedArgs) +Bytes CD:Bytes </callData>
    <callValue> VALUE:Int </callValue>
    <id> ACCT:Int </id>
    <codeAddr> ACCT </codeAddr>
    <caller> CALLER_ACCT:Int </caller>
    <static> STATIC:Bool </static>
    <output>
      INITIAL_OUTPUT:Bytes
      =>
      #buf(32, #lookup(STORAGE, 2))
      +Bytes #buf(32, bool2Word(notBool (#dsHasByte(STORAGE) ==Int 0)))
    </output>
    <statusCode> INITIAL_STATUS:StatusCode => EVMC_SUCCESS </statusCode>
    <account>
      <acctID> ACCT </acctID>
      <storage> STORAGE:Map </storage>
      ...
    </account>
    requires lengthBytes(CD) <=Int 1250000000
     andBool #rangeAddress(ACCT)
     andBool #rangeAddress(CALLER_ACCT)
     andBool #rangeUInt(256, VALUE)
     andBool VALUE ==Int 0

  claim [read-success]:
    <k> #execute ~> CONTINUATION:K => #halt ~> CONTINUATION </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <gas> #gas(VGAS:Int) => #gas(VGAS -Int 2043) </gas>
    <program> #dsValueRuntime </program>
    <jumpDests> #computeValidJumpDests(#dsValueRuntime) </jumpDests>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <wordStack> .WordStack => ?FINAL_STACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEMORY:Bytes </localMem>
    <memoryUsed> 0 => ?FINAL_MEMORY_USED:Int </memoryUsed>
    <callData> #abiCallData("read", .TypedArgs) +Bytes CD:Bytes </callData>
    <callValue> VALUE:Int </callValue>
    <id> ACCT:Int </id>
    <codeAddr> ACCT </codeAddr>
    <caller> CALLER_ACCT:Int </caller>
    <static> STATIC:Bool </static>
    <output> INITIAL_OUTPUT:Bytes => #buf(32, #lookup(STORAGE, 2)) </output>
    <statusCode> INITIAL_STATUS:StatusCode => EVMC_SUCCESS </statusCode>
    <account>
      <acctID> ACCT </acctID>
      <storage> STORAGE:Map </storage>
      ...
    </account>
    requires lengthBytes(CD) <=Int 1250000000
     andBool #rangeAddress(ACCT)
     andBool #rangeAddress(CALLER_ACCT)
     andBool #rangeUInt(256, VALUE)
     andBool VALUE ==Int 0
     andBool notBool (#dsHasByte(STORAGE) ==Int 0)

endmodule
