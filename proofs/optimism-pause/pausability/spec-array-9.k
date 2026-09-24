requires "verification.k"

module PAUSE-WITHDRAWAL-ARRAY-9-SPEC
  imports VERIFICATION

  claim [portal-prove-paused-array-9]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> LONDON </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => #abiCallData("OptimismPortal_CallPaused", .TypedArgs) </output>
        <statusCode> _ => EVMC_REVERT </statusCode>
        <callStack> .List </callStack>
        <interimStates> .List </interimStates>
        <touchedAccounts> .Set => ?_ </touchedAccounts>
        <callState>
          <program> #optimismPortal2Program </program>
          <jumpDests> #computeValidJumpDests(#optimismPortal2Program) </jumpDests>
          <id> 4096 </id>
          <codeAddr> 4096 </codeAddr>
          <caller> CALLER_ADDR </caller>
          <callData> #abiCallData("proveWithdrawalTransaction", #tuple(#uint256(NONCE), #address(SENDER), #address(TARGET), #uint256(VALUE), #uint256(GAS_LIMIT), #bytes(TX_DATA)), #uint256(GAME_INDEX), #tuple(#bytes32(VERSION), #bytes32(STATE_ROOT), #bytes32(MESSAGE_PASSER_ROOT), #bytes32(LATEST_BLOCKHASH)), #array(#bytes(PROOF_1), 9, #bytes(PROOF_1), #bytes(PROOF_2), #bytes(PROOF_3), #bytes(PROOF_4), #bytes(PROOF_5), #bytes(PROOF_6), #bytes(PROOF_7), #bytes(PROOF_8), #bytes(PROOF_9), .TypedArgs)) </callData>
          <callValue> 0 </callValue>
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
            <code> #optimismPortal2Program </code>
            <storage> 63 |-> 16384 PORTAL_STORAGE:Map </storage>
            <origStorage> 63 |-> 16384 PORTAL_STORAGE:Map </origStorage>
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
     andBool #rangeUInt(256, GAS_LIMIT)
     andBool lengthBytes(TX_DATA) <=Int 1073741824
     andBool #rangeUInt(256, GAME_INDEX)
     andBool #rangeUInt(256, VERSION)
     andBool #rangeUInt(256, STATE_ROOT)
     andBool #rangeUInt(256, MESSAGE_PASSER_ROOT)
     andBool #rangeUInt(256, LATEST_BLOCKHASH)
     andBool lengthBytes(PROOF_1) ==Int 600
     andBool lengthBytes(PROOF_2) ==Int 600
     andBool lengthBytes(PROOF_3) ==Int 600
     andBool lengthBytes(PROOF_4) ==Int 600
     andBool lengthBytes(PROOF_5) ==Int 600
     andBool lengthBytes(PROOF_6) ==Int 600
     andBool lengthBytes(PROOF_7) ==Int 600
     andBool lengthBytes(PROOF_8) ==Int 600
     andBool lengthBytes(PROOF_9) ==Int 600

endmodule

