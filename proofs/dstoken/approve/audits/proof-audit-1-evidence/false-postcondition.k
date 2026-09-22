requires "verification.k"

module AUDIT-FALSE-SPEC
  imports VERIFICATION

  // Fresh A5 mutation: the real approve success path returns ABI true.
  // This claim deliberately asks for ABI false while retaining the same
  // executable program term, precondition, storage update, and logs.
  claim [approve-success-false-output]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> CANCUN </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 0) </output>
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
endmodule
