requires "verification.k"

module PAUSE-SPEC
  imports VERIFICATION

  claim [portal-prove-paused]:
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
          <callData> #abiCallData("proveWithdrawalTransaction", #tuple(#uint256(NONCE), #address(SENDER), #address(TARGET), #uint256(VALUE), #uint256(GAS_LIMIT), #bytes(TX_DATA)), #uint256(GAME_INDEX), #tuple(#bytes32(VERSION), #bytes32(STATE_ROOT), #bytes32(MESSAGE_PASSER_ROOT), #bytes32(LATEST_BLOCKHASH)), #array(#bytes(.Bytes), 0, .TypedArgs)) </callData>
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

  claim [portal-finalize-paused]:
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
          <callData> #abiCallData("finalizeWithdrawalTransaction", #tuple(#uint256(NONCE), #address(SENDER), #address(TARGET), #uint256(VALUE), #uint256(GAS_LIMIT), #bytes(TX_DATA))) </callData>
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

  claim [standard-bridge-erc20-paused]:
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
          <callData> #abiCallData("finalizeBridgeERC20", #address(LOCAL_TOKEN), #address(REMOTE_TOKEN), #address(FROM), #address(TO), #uint256(AMOUNT), #bytes(EXTRA_DATA)) </callData>
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
     andBool #rangeAddress(LOCAL_TOKEN)
     andBool #rangeAddress(REMOTE_TOKEN)
     andBool #rangeAddress(FROM)
     andBool #rangeAddress(TO)
     andBool #rangeUInt(256, AMOUNT)
     andBool lengthBytes(EXTRA_DATA) <=Int 1073741824

  claim [erc721-bridge-paused]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> LONDON </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => #abiCallData("Error", #string("L1ERC721Bridge: paused")) </output>
        <statusCode> _ => EVMC_REVERT </statusCode>
        <callStack> .List </callStack>
        <interimStates> .List </interimStates>
        <touchedAccounts> .Set => ?_ </touchedAccounts>
        <callState>
          <program> #l1ERC721BridgeProgram </program>
          <jumpDests> #computeValidJumpDests(#l1ERC721BridgeProgram) </jumpDests>
          <id> 4096 </id>
          <codeAddr> 4096 </codeAddr>
          <caller> 8192 </caller>
          <callData> #abiCallData("finalizeBridgeERC721", #address(LOCAL_TOKEN), #address(REMOTE_TOKEN), #address(FROM), #address(TO), #uint256(TOKEN_ID), #bytes(EXTRA_DATA)) </callData>
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
            <code> #l1ERC721BridgeProgram </code>
            <storage> 1 |-> 8192 2 |-> 12288 51 |-> 16384 BRIDGE_STORAGE:Map </storage>
            <origStorage> 1 |-> 8192 2 |-> 12288 51 |-> 16384 BRIDGE_STORAGE:Map </origStorage>
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
     andBool #rangeAddress(LOCAL_TOKEN)
     andBool #rangeAddress(REMOTE_TOKEN)
     andBool #rangeAddress(FROM)
     andBool #rangeAddress(TO)
     andBool #rangeUInt(256, TOKEN_ID)
     andBool lengthBytes(EXTRA_DATA) <=Int 1073741824

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
