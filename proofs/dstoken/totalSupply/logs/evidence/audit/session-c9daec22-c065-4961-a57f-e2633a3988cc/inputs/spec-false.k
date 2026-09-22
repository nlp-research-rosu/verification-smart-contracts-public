requires "verification.k"

module SPEC-FALSE
  imports VERIFICATION

  // Audit-authored A5 mutation: for the satisfiable witness STORAGE = .Map,
  // fixed execution returns slot 0 as zero, not one.
  claim [totalSupply-success-false-slot0-plus-one]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> SHANGHAI </schedule>
    <useGas> false </useGas>
    <program> #binRuntime(DSTOKEN) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(DSTOKEN)) </jumpDests>
    <id> ACCT </id>
    <callData> #abiCallData("totalSupply", .TypedArgs) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINALSTACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINALMEM:Bytes </localMem>
    <memoryUsed> 0 => ?FINALMEMUSED:Int </memoryUsed>
    <pc> 0 => ?FINALPC:Int </pc>
    <output> .Bytes => #buf(32, #lookup(STORAGE, 0) +Int 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <account>
      <acctID> ACCT </acctID>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(ACCT)
endmodule
