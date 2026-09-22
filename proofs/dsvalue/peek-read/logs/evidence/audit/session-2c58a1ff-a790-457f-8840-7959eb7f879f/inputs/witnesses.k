requires "verification.k"
module WITNESSES
  imports VERIFICATION
  claim [peek-zero]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <gas> #gas((10000)) => ?FINAL_GAS:Gas </gas>
    <program> #dsValueRuntime </program>
    <jumpDests> #computeValidJumpDests(#dsValueRuntime) </jumpDests>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <wordStack> .WordStack => ?FINAL_STACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEMORY:Bytes </localMem>
    <memoryUsed> 0 => ?FINAL_MEMORY_USED:Int </memoryUsed>
    <callData> #abiCallData("peek", .TypedArgs) +Bytes (.Bytes) </callData>
    <callValue> (0) </callValue>
    <id> (100) </id>
    <codeAddr> (100) </codeAddr>
    <caller> (101) </caller>
    <static> (false) </static>
    <output>
      .Bytes
      =>
      #buf(32, #lookup((.Map), 2))
      +Bytes #buf(32, bool2Word(notBool (#dsHasByte((.Map)) ==Int 0)))
    </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <account>
      <acctID> (100) </acctID>
      <storage> (.Map) </storage>
      ...
    </account>
    requires lengthBytes((.Bytes)) <=Int 1250000000
     andBool #rangeAddress((100))
     andBool #rangeAddress((101))
     andBool #rangeUInt(256, (0))
     andBool (0) ==Int 0

  claim [peek-one]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <gas> #gas((10000)) => ?FINAL_GAS:Gas </gas>
    <program> #dsValueRuntime </program>
    <jumpDests> #computeValidJumpDests(#dsValueRuntime) </jumpDests>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <wordStack> .WordStack => ?FINAL_STACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEMORY:Bytes </localMem>
    <memoryUsed> 0 => ?FINAL_MEMORY_USED:Int </memoryUsed>
    <callData> #abiCallData("peek", .TypedArgs) +Bytes (.Bytes) </callData>
    <callValue> (0) </callValue>
    <id> (100) </id>
    <codeAddr> (100) </codeAddr>
    <caller> (101) </caller>
    <static> (false) </static>
    <output>
      .Bytes
      =>
      #buf(32, #lookup(((1 |-> (2 ^Int 160)) (2 |-> 42)), 2))
      +Bytes #buf(32, bool2Word(notBool (#dsHasByte(((1 |-> (2 ^Int 160)) (2 |-> 42))) ==Int 0)))
    </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <account>
      <acctID> (100) </acctID>
      <storage> ((1 |-> (2 ^Int 160)) (2 |-> 42)) </storage>
      ...
    </account>
    requires lengthBytes((.Bytes)) <=Int 1250000000
     andBool #rangeAddress((100))
     andBool #rangeAddress((101))
     andBool #rangeUInt(256, (0))
     andBool (0) ==Int 0

  claim [read-one]:
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
    <output> .Bytes => #buf(32, #lookup(((1 |-> (2 ^Int 160)) (2 |-> 42)), 2)) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <account>
      <acctID> (100) </acctID>
      <storage> ((1 |-> (2 ^Int 160)) (2 |-> 42)) </storage>
      ...
    </account>
    requires lengthBytes((.Bytes)) <=Int 1250000000
     andBool #rangeAddress((100))
     andBool #rangeAddress((101))
     andBool #rangeUInt(256, (0))
     andBool (0) ==Int 0
     andBool notBool (#dsHasByte(((1 |-> (2 ^Int 160)) (2 |-> 42))) ==Int 0)

  claim [read-zero]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <gas> #gas((10000)) => ?FINAL_GAS:Gas </gas>
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
    <output> .Bytes => #hazNotRevert </output>
    <statusCode> .StatusCode => EVMC_REVERT </statusCode>
    <account>
      <acctID> (100) </acctID>
      <storage> (.Map) </storage>
      ...
    </account>
    requires lengthBytes((.Bytes)) <=Int 1250000000
     andBool #rangeAddress((100))
     andBool #rangeAddress((101))
     andBool #rangeUInt(256, (0))
     andBool (0) ==Int 0
     andBool #dsHasByte((.Map)) ==Int 0

  claim [peek-value]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <gas> #gas((10000)) => ?FINAL_GAS:Gas </gas>
    <program> #dsValueRuntime </program>
    <jumpDests> #computeValidJumpDests(#dsValueRuntime) </jumpDests>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <wordStack> .WordStack => ?FINAL_STACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEMORY:Bytes </localMem>
    <memoryUsed> 0 => ?FINAL_MEMORY_USED:Int </memoryUsed>
    <callData> #abiCallData("peek", .TypedArgs) +Bytes (.Bytes) </callData>
    <callValue> (1) </callValue>
    <id> (100) </id>
    <codeAddr> (100) </codeAddr>
    <caller> (101) </caller>
    <static> (false) </static>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_REVERT </statusCode>
    <account>
      <acctID> (100) </acctID>
      <storage> (.Map) </storage>
      ...
    </account>
    requires lengthBytes((.Bytes)) <=Int 1250000000
     andBool #rangeAddress((100))
     andBool #rangeAddress((101))
     andBool #rangeUInt(256, (1))
     andBool 0 <Int (1)

  claim [read-value]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <gas> #gas((10000)) => ?FINAL_GAS:Gas </gas>
    <program> #dsValueRuntime </program>
    <jumpDests> #computeValidJumpDests(#dsValueRuntime) </jumpDests>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <wordStack> .WordStack => ?FINAL_STACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEMORY:Bytes </localMem>
    <memoryUsed> 0 => ?FINAL_MEMORY_USED:Int </memoryUsed>
    <callData> #abiCallData("read", .TypedArgs) +Bytes (.Bytes) </callData>
    <callValue> (1) </callValue>
    <id> (100) </id>
    <codeAddr> (100) </codeAddr>
    <caller> (101) </caller>
    <static> (false) </static>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_REVERT </statusCode>
    <account>
      <acctID> (100) </acctID>
      <storage> (.Map) </storage>
      ...
    </account>
    requires lengthBytes((.Bytes)) <=Int 1250000000
     andBool #rangeAddress((100))
     andBool #rangeAddress((101))
     andBool #rangeUInt(256, (1))
     andBool 0 <Int (1)
endmodule
