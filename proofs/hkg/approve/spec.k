requires "verification.k"

module SPEC
  imports VERIFICATION

  // A canonical, zero-value, non-static approve call succeeds for every
  // Solidity address and uint256 value. It overwrites exactly the nested
  // allowed[CALLER_ID][SPENDER] slot, returns true, and emits Approval.
  claim [approve-success]:
    <k> #execute => #halt </k>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <program> #binRuntime(hkg) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(hkg)) </jumpDests>
    <id> CONTRACT </id>
    <caller> CALLER_ID </caller>
    <callData> #abiCallData("approve", #address(SPENDER), #uint256(VALUE)) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINALSTACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINALMEM:Bytes </localMem>
    <pc> 0 => ?FINALPC:Int </pc>
    <memoryUsed> 0 => ?FINALMEMUSED:Int </memoryUsed>
    <static> false </static>
    <log>
      LOGS
      => LOGS ListItem({ CONTRACT
                       | ListItem(63486140976153616755203102783360879283472101686154884697241723088393386309925)
                         ListItem(CALLER_ID)
                         ListItem(SPENDER)
                       | #buf(32, VALUE) })
    </log>
    <accounts>
      <account>
        <acctID> CONTRACT </acctID>
        <storage>
          STORAGE
          => STORAGE [ #hashedLocation("Solidity", 2, CALLER_ID SPENDER .IntList) <- VALUE ]
        </storage>
        ...
      </account>
      ...
    </accounts>
    requires #rangeAddress(CONTRACT)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(SPENDER)
     andBool #rangeUInt(256, VALUE)

  // Solidity's nonpayable dispatcher rejects every canonical approve call
  // carrying nonzero value before storage or logs can change.
  claim [approve-nonpayable-revert]:
    <k> #execute => #halt </k>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_REVERT </statusCode>
    <program> #binRuntime(hkg) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(hkg)) </jumpDests>
    <id> CONTRACT </id>
    <caller> CALLER_ID </caller>
    <callData> #abiCallData("approve", #address(SPENDER), #uint256(VALUE)) </callData>
    <callValue> CALL_VALUE </callValue>
    <wordStack> .WordStack => ?FINALSTACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINALMEM:Bytes </localMem>
    <pc> 0 => ?FINALPC:Int </pc>
    <memoryUsed> 0 => ?FINALMEMUSED:Int </memoryUsed>
    <static> STATIC </static>
    <log> LOGS </log>
    <accounts>
      <account>
        <acctID> CONTRACT </acctID>
        <storage> STORAGE </storage>
        ...
      </account>
      ...
    </accounts>
    requires #rangeAddress(CONTRACT)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(SPENDER)
     andBool #rangeUInt(256, VALUE)
     andBool #rangeUInt(256, CALL_VALUE)
     andBool CALL_VALUE =/=Int 0

  // A zero-value STATICCALL reaches SSTORE and fails exceptionally. Since
  // the violation is detected before SSTORE executes, storage and logs stay
  // unchanged.
  claim [approve-static-failure]:
    <k> #execute => #halt </k>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_STATIC_MODE_VIOLATION </statusCode>
    <program> #binRuntime(hkg) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(hkg)) </jumpDests>
    <id> CONTRACT </id>
    <caller> CALLER_ID </caller>
    <callData> #abiCallData("approve", #address(SPENDER), #uint256(VALUE)) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINALSTACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINALMEM:Bytes </localMem>
    <pc> 0 => ?FINALPC:Int </pc>
    <memoryUsed> 0 => ?FINALMEMUSED:Int </memoryUsed>
    <static> true </static>
    <log> LOGS </log>
    <accounts>
      <account>
        <acctID> CONTRACT </acctID>
        <storage> STORAGE </storage>
        ...
      </account>
      ...
    </accounts>
    requires #rangeAddress(CONTRACT)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(SPENDER)
     andBool #rangeUInt(256, VALUE)
endmodule
