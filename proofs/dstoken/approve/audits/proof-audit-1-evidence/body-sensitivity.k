requires "verification.k"
requires "body-mutated-bytecode.k"

module AUDIT-BODY-SENSITIVITY
  imports VERIFICATION
  imports AUDIT-MUTATED-BYTECODE

  claim [approve-success-stop-body]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> CANCUN </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <program> AUDIT_MUTATED_RUNTIME </program>
    <jumpDests> #computeValidJumpDests(AUDIT_MUTATED_RUNTIME) </jumpDests>
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
      <code> AUDIT_MUTATED_RUNTIME </code>
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
