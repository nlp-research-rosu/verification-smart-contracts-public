requires "verification.k"

module PAUSE-SPEC
  imports VERIFICATION

  claim [messenger-relay-paused]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> LONDON </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => #abiCallData("Error", #string("CrossDomainMessenger: paused")) </output>
        <statusCode> _ => EVMC_REVERT </statusCode>
        <callStack> .List </callStack>
        <interimStates> .List </interimStates>
        <touchedAccounts> .Set => ?_ </touchedAccounts>
        <callState>
          <program> #l1CrossDomainMessengerProgram </program>
          <jumpDests> #computeValidJumpDests(#l1CrossDomainMessengerProgram) </jumpDests>
          <id> 4096 </id>
          <codeAddr> 4096 </codeAddr>
          <caller> CALLER_ADDR </caller>
          <callData> #abiCallData("relayMessage", #uint256(NONCE), #address(SENDER), #address(TARGET), #uint256(VALUE), #uint256(MIN_GAS_LIMIT), #bytes(MESSAGE)) </callData>
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
            <code> #l1CrossDomainMessengerProgram </code>
            <storage> 254 |-> 16384 MESSENGER_STORAGE:Map </storage>
            <origStorage> 254 |-> 16384 MESSENGER_STORAGE:Map </origStorage>
            <nonce> CONTRACT_NONCE </nonce>
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
     andBool #rangeUInt(256, NONCE)
     andBool #rangeAddress(SENDER)
     andBool #rangeAddress(TARGET)
     andBool #rangeUInt(256, VALUE)
     andBool #rangeUInt(256, MIN_GAS_LIMIT)
     andBool #rangeUInt(256, MSG_VALUE)
     andBool lengthBytes(MESSAGE) <=Int 1073741824

endmodule
