requires "verification.k"

module SPEC
  imports VERIFICATION

  claim [allowance-success]:
    <k> #execute => #halt </k>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <program> #dstokenRuntime </program>
    <jumpDests> #computeValidJumpDests(#dstokenRuntime) </jumpDests>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <wordStack> .WordStack => ?FINAL_STACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEMORY:Bytes </localMem>
    <memoryUsed> 0 => ?FINAL_MEMORY_USED:Int </memoryUsed>
    <id> CONTRACT:Int </id>
    <codeAddr> CONTRACT:Int </codeAddr>
    <caller> MSGSENDER:Int </caller>
    <callData> #abiCallData("allowance", #address(SRC), #address(GUY)) </callData>
    <callValue> 0 </callValue>
    <static> false </static>
    <output> .Bytes => #buf(32, #lookup(STORAGE, #hashedLocation("Solidity", 2, SRC GUY))) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <account>
      <acctID> CONTRACT:Int </acctID>
      <storage> STORAGE:Map </storage>
      ...
    </account>
    requires #rangeAddress(SRC)
     andBool #rangeAddress(GUY)
     andBool #rangeAddress(CONTRACT)
     andBool #rangeAddress(MSGSENDER)

  claim [allowance-nonpayable-reverts]:
    <k> #execute => #halt </k>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <program> #dstokenRuntime </program>
    <jumpDests> #computeValidJumpDests(#dstokenRuntime) </jumpDests>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <wordStack> .WordStack => ?FINAL_STACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEMORY:Bytes </localMem>
    <memoryUsed> 0 => ?FINAL_MEMORY_USED:Int </memoryUsed>
    <id> CONTRACT:Int </id>
    <codeAddr> CONTRACT:Int </codeAddr>
    <caller> MSGSENDER:Int </caller>
    <callData> #abiCallData("allowance", #address(SRC), #address(GUY)) </callData>
    <callValue> VALUE:Int </callValue>
    <static> false </static>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_REVERT </statusCode>
    <account>
      <acctID> CONTRACT:Int </acctID>
      <storage> STORAGE:Map </storage>
      ...
    </account>
    requires #rangeAddress(SRC)
     andBool #rangeAddress(GUY)
     andBool #rangeAddress(CONTRACT)
     andBool #rangeAddress(MSGSENDER)
     andBool 0 <Int VALUE
     andBool VALUE <Int pow256
endmodule
