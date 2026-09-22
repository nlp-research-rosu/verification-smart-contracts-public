requires "verification-body-mutated.k"

module SPEC
  imports VERIFICATION

  claim [totalSupply-success]:
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
    <output> .Bytes => #buf(32, #lookup(STORAGE, 0)) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <account>
      <acctID> ACCT </acctID>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(ACCT)

  claim [totalSupply-nonzero-value-reverts]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> SHANGHAI </schedule>
    <useGas> false </useGas>
    <program> #binRuntime(DSTOKEN) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(DSTOKEN)) </jumpDests>
    <id> ACCT </id>
    <callData> #abiCallData("totalSupply", .TypedArgs) </callData>
    <callValue> CV </callValue>
    <wordStack> .WordStack => ?FINALSTACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINALMEM:Bytes </localMem>
    <memoryUsed> 0 => ?FINALMEMUSED:Int </memoryUsed>
    <pc> 0 => ?FINALPC:Int </pc>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_REVERT </statusCode>
    <account>
      <acctID> ACCT </acctID>
      <storage> _STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(ACCT)
     andBool #rangeUInt(256, CV)
     andBool CV =/=Int 0
endmodule
