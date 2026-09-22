requires "verification-fixed.k"

module SPEC
  imports VERIFICATION-FIXED

  claim [balanceOf-success]:
    <kevm>
      <k> #execute => #halt </k>
      <schedule> BYZANTIUM </schedule>
      <useGas> false </useGas>
      <ethereum>
        <evm>
          <output>
            .Bytes => #buf(32, #lookup(STORAGE, #hashedLocation("Solidity", 1, WHO .IntList)))
          </output>
          <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
          <callState>
            <program> DSTOKEN_RUNTIME </program>
            <jumpDests> #computeValidJumpDests(DSTOKEN_RUNTIME) </jumpDests>
            <id> ACCT </id>
            <caller> CALLER_ID </caller>
            <callData> #abiCallData("balanceOf", #address(WHO)) </callData>
            <callValue> 0 </callValue>
            <wordStack> .WordStack => ?FINALSTACK:WordStack </wordStack>
            <localMem> .Bytes => ?FINALMEM:Bytes </localMem>
            <pc> 0 => ?FINALPC:Int </pc>
            <gas> 0 </gas>
            <memoryUsed> 0 => ?FINALMEMUSED:Int </memoryUsed>
            <callGas> 0 </callGas>
            <static> false </static>
            <callDepth> 0 </callDepth>
            <codeAddr> ACCT </codeAddr>
          </callState>
          ...
        </evm>
        <network>
          <accounts>
            <account>
              <acctID> ACCT </acctID>
              <storage> STORAGE </storage>
              ...
            </account>
            ...
          </accounts>
          ...
        </network>
        ...
      </ethereum>
      ...
    </kevm>
    requires #rangeAddress(WHO)
     andBool #rangeAddress(ACCT)
     andBool #rangeAddress(CALLER_ID)

  claim [balanceOf-nonzero-value-reverts]:
    <kevm>
      <k> #execute => #halt </k>
      <schedule> BYZANTIUM </schedule>
      <useGas> false </useGas>
      <ethereum>
        <evm>
          <output> .Bytes </output>
          <statusCode> .StatusCode => EVMC_REVERT </statusCode>
          <callState>
            <program> DSTOKEN_RUNTIME </program>
            <jumpDests> #computeValidJumpDests(DSTOKEN_RUNTIME) </jumpDests>
            <id> ACCT </id>
            <caller> CALLER_ID </caller>
            <callData> #abiCallData("balanceOf", #address(WHO)) </callData>
            <callValue> CALL_VALUE </callValue>
            <wordStack> .WordStack => ?FINALSTACK:WordStack </wordStack>
            <localMem> .Bytes => ?FINALMEM:Bytes </localMem>
            <pc> 0 => ?FINALPC:Int </pc>
            <gas> 0 </gas>
            <memoryUsed> 0 => ?FINALMEMUSED:Int </memoryUsed>
            <callGas> 0 </callGas>
            <static> false </static>
            <callDepth> 0 </callDepth>
            <codeAddr> ACCT </codeAddr>
          </callState>
          ...
        </evm>
        <network>
          <accounts>
            <account>
              <acctID> ACCT </acctID>
              <storage> STORAGE </storage>
              ...
            </account>
            ...
          </accounts>
          ...
        </network>
        ...
      </ethereum>
      ...
    </kevm>
    requires #rangeAddress(WHO)
     andBool #rangeAddress(ACCT)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeUInt(256, CALL_VALUE)
     andBool CALL_VALUE =/=Int 0

endmodule
