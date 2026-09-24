requires "verification.k"

module PAUSE-SPEC
  imports VERIFICATION

  claim [standard-bridge-eth-paused]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> LONDON </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => #abiCallData("Error", #string("StandardBridge: paused")) </output>
        <statusCode> _ => EVMC_REVERT </statusCode>
        <callStack> .List </callStack>
        <interimStates> .List </interimStates>
        <touchedAccounts> .Set => ?_ </touchedAccounts>
        <callState>
          <program> #l1StandardBridgeProgram </program>
          <jumpDests> #computeValidJumpDests(#l1StandardBridgeProgram) </jumpDests>
          <id> 4096 </id>
          <codeAddr> 4096 </codeAddr>
          <caller> 8192 </caller>
          <callData> #abiCallData("finalizeBridgeETH", #address(FROM), #address(TO), #uint256(AMOUNT), #bytes(EXTRA_DATA)) </callData>
          <callValue> MSG_VALUE </callValue>
          <wordStack> .WordStack => ?_ </wordStack>
          <localMem> .Bytes => ?_ </localMem>
          <pc> 0 => ?_ </pc>
          <gas> #gas(_VGAS) => ?_ </gas>
          <memoryUsed> 0 => ?_ </memoryUsed>
          <callGas> _ => ?_ </callGas>
          <static> false </static>
          <callDepth> CD </callDepth>
        </callState>
        <versionedHashes> _ </versionedHashes>
        <substate>
          <selfDestruct> .Set </selfDestruct>
          <log> LOGS </log>
          <refund> 0 </refund>
          <accessedAccounts> .Set => ?_ </accessedAccounts>
          <accessedStorage> .Map => ?_ </accessedStorage>
          <createdAccounts> .Set => ?_ </createdAccounts>
        </substate>
        ...
      </evm>
      <network>
        <accounts>
          <account>
            <acctID> 4096 </acctID>
            <balance> CONTRACT_BAL </balance>
            <code> #l1StandardBridgeProgram </code>
            <storage> 3 |-> 8192 4 |-> 12288 52 |-> 16384 BRIDGE_STORAGE:Map </storage>
            <origStorage> 3 |-> 8192 4 |-> 12288 52 |-> 16384 BRIDGE_STORAGE:Map </origStorage>
            <nonce> CONTRACT_NONCE </nonce>
            <transientStorage> .Map </transientStorage>
          </account>
          <account>
            <acctID> 8192 </acctID>
            <balance> 0 </balance>
            <code> #otherBridgeResponderProgram </code>
            <storage> .Map </storage>
            <origStorage> .Map </origStorage>
            <nonce> 1 </nonce>
            <transientStorage> .Map </transientStorage>
          </account>
          <account>
            <acctID> 16384 </acctID>
            <balance> 0 </balance>
            <code> #trueResponderProgram </code>
            <storage> .Map </storage>
            <origStorage> .Map </origStorage>
            <nonce> 1 </nonce>
            <transientStorage> .Map </transientStorage>
          </account>
          ...
        </accounts>
        ...
      </network>
    </ethereum>
    requires #rangeAddress(CALLER_ADDR)
     andBool #rangeUInt(256, CONTRACT_BAL)
     andBool #rangeNonce(CONTRACT_NONCE)
     andBool #range(0 <= CD < 1023)
     andBool #rangeAddress(FROM)
     andBool #rangeAddress(TO)
     andBool #rangeUInt(256, AMOUNT)
     andBool #rangeUInt(256, MSG_VALUE)
     andBool lengthBytes(EXTRA_DATA) <=Int 1073741824

endmodule
