requires "verification.k"

module SPEC
  imports VERIFICATION

  claim [approve-success]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> CANCUN </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <program> DSTOKEN_RUNTIME </program>
    <jumpDests> #computeValidJumpDests(DSTOKEN_RUNTIME) </jumpDests>
    <id> ACCT </id>
    <caller> CALLER_ID </caller>
    <callData> approveCallData(GUY, WAD) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?WS:WordStack </wordStack>
    <localMem> .Bytes => ?MEM:Bytes </localMem>
    <pc> 0 => ?PC:Int </pc>
    <gas> #gas(0) => ?GAS:Gas </gas>
    <memoryUsed> 0 => ?MEMUSED:Int </memoryUsed>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <log>
      LOGS
      =>
      LOGS
      ListItem(approveNoteLog(ACCT, CALLER_ID, GUY, WAD))
      ListItem(approvalLog(ACCT, CALLER_ID, GUY, WAD))
    </log>
    <account>
      <acctID> ACCT </acctID>
      <code> DSTOKEN_RUNTIME </code>
      <storage>
        STORAGE
        =>
        STORAGE [ approveSlot(CALLER_ID, GUY) <- WAD ]
      </storage>
      ...
    </account>
    requires #rangeAddress(ACCT)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(GUY)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool stoppedClear(STORAGE)

  claim [approve-stopped]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> CANCUN </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_INVALID_INSTRUCTION </statusCode>
    <program> DSTOKEN_RUNTIME </program>
    <jumpDests> #computeValidJumpDests(DSTOKEN_RUNTIME) </jumpDests>
    <id> ACCT </id>
    <caller> CALLER_ID </caller>
    <callData> approveCallData(GUY, WAD) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?WS:WordStack </wordStack>
    <localMem> .Bytes => ?MEM:Bytes </localMem>
    <pc> 0 => ?PC:Int </pc>
    <gas> #gas(0) => ?GAS:Gas </gas>
    <memoryUsed> 0 => ?MEMUSED:Int </memoryUsed>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <log> LOGS </log>
    <account>
      <acctID> ACCT </acctID>
      <code> DSTOKEN_RUNTIME </code>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(ACCT)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(GUY)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool notBool stoppedClear(STORAGE)

  claim [approve-nonpayable]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> CANCUN </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_REVERT </statusCode>
    <program> DSTOKEN_RUNTIME </program>
    <jumpDests> #computeValidJumpDests(DSTOKEN_RUNTIME) </jumpDests>
    <id> ACCT </id>
    <caller> CALLER_ID </caller>
    <callData> approveCallData(GUY, WAD) </callData>
    <callValue> CALL_VALUE </callValue>
    <wordStack> .WordStack => ?WS:WordStack </wordStack>
    <localMem> .Bytes => ?MEM:Bytes </localMem>
    <pc> 0 => ?PC:Int </pc>
    <gas> #gas(0) => ?GAS:Gas </gas>
    <memoryUsed> 0 => ?MEMUSED:Int </memoryUsed>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <log> LOGS </log>
    <account>
      <acctID> ACCT </acctID>
      <code> DSTOKEN_RUNTIME </code>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(ACCT)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(GUY)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, CALL_VALUE)
     andBool CALL_VALUE =/=Int 0
endmodule
