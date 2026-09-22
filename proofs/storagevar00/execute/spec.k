requires "verification.k"

module SPEC
  imports VERIFICATION

  claim [execute-success]:
    <k> #execute => #halt </k>
    <schedule> CANCUN </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, #lookup(STORAGE, 0)) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <program> #storageVar00Runtime </program>
    <jumpDests> #computeValidJumpDests(#storageVar00Runtime) </jumpDests>
    <id> ACCT </id>
    <callData> #abiCallData("execute", .TypedArgs) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINAL_STACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEMORY:Bytes </localMem>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <gas> 0 => ?FINAL_GAS:Gas </gas>
    <memoryUsed> 0 => ?FINAL_MEMORY_USED:Int </memoryUsed>
    <account>
      <acctID> ACCT </acctID>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(ACCT)

  claim [execute-nonpayable-revert]:
    <k> #execute => #halt </k>
    <schedule> CANCUN </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_REVERT </statusCode>
    <program> #storageVar00Runtime </program>
    <jumpDests> #computeValidJumpDests(#storageVar00Runtime) </jumpDests>
    <id> ACCT </id>
    <callData> #abiCallData("execute", .TypedArgs) </callData>
    <callValue> VALUE </callValue>
    <wordStack> .WordStack => ?FINAL_STACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEMORY:Bytes </localMem>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <gas> 0 => ?FINAL_GAS:Gas </gas>
    <memoryUsed> 0 => ?FINAL_MEMORY_USED:Int </memoryUsed>
    <account>
      <acctID> ACCT </acctID>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(ACCT)
     andBool #rangeUInt(256, VALUE)
     andBool VALUE =/=Int 0
endmodule
