requires "verification-body.k"
module BODY-CHECK
  imports VERIFICATION
  claim [read-body-mutated]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <gas> #gas((10000)) => #gas((10000) -Int 2043) </gas>
    <program> #dsValueRuntime </program>
    <jumpDests> #computeValidJumpDests(#dsValueRuntime) </jumpDests>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <wordStack> .WordStack => ?FINAL_STACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEMORY:Bytes </localMem>
    <memoryUsed> 0 => ?FINAL_MEMORY_USED:Int </memoryUsed>
    <callData> #abiCallData("read", .TypedArgs) +Bytes (.Bytes) </callData>
    <callValue> (0) </callValue>
    <id> (100) </id>
    <codeAddr> (100) </codeAddr>
    <caller> (101) </caller>
    <static> (false) </static>
    <output> .Bytes => #buf(32, #lookup(((1 |-> (2 ^Int 160)) (2 |-> 42) (3 |-> 43)), 2)) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <account>
      <acctID> (100) </acctID>
      <storage> ((1 |-> (2 ^Int 160)) (2 |-> 42) (3 |-> 43)) </storage>
      ...
    </account>
    requires lengthBytes((.Bytes)) <=Int 1250000000
     andBool #rangeAddress((100))
     andBool #rangeAddress((101))
     andBool #rangeUInt(256, (0))
     andBool (0) ==Int 0
     andBool notBool (#dsHasByte(((1 |-> (2 ^Int 160)) (2 |-> 42) (3 |-> 43))) ==Int 0)

endmodule
