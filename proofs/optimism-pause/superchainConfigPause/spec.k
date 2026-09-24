requires "verification.k"

module PAUSE-CALL-SYMBOLIC-SPEC
  imports VERIFICATION

  claim [guardian-global-pause-sets-symbolic-timestamp]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> LONDON </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <block>
          <timestamp> PAUSED_AT </timestamp>
          ...
        </block>
        <output> _ => .Bytes </output>
        <statusCode> _ => EVMC_SUCCESS </statusCode>
        <callStack> .List </callStack>
        <interimStates> .List </interimStates>
        <touchedAccounts> .Set => ?_ </touchedAccounts>
        <callState>
          <program> #superchainConfigProgram </program>
          <jumpDests> #computeValidJumpDests(#superchainConfigProgram) </jumpDests>
          <id> 20480 </id>
          <codeAddr> 20480 </codeAddr>
          <caller> GUARDIAN_ADDR </caller>
          <callData> #abiCallData("pause", #address(0)) </callData>
          <callValue> 0 </callValue>
          <wordStack> .WordStack => ?_ </wordStack>
          <localMem> .Bytes => ?_ </localMem>
          <pc> 0 => ?_ </pc>
          <gas> #gas(_VGAS) => ?_ </gas>
          <memoryUsed> 0 => ?_ </memoryUsed>
          <callGas> _ => ?_ </callGas>
          <static> false </static>
          <callDepth> 0 </callDepth>
        </callState>
        <versionedHashes> _ </versionedHashes>
        <substate>
          <selfDestruct> .Set </selfDestruct>
          <log> LOGS => ?_ </log>
          <refund> 0 => ?_ </refund>
          <accessedAccounts> .Set => ?_ </accessedAccounts>
          <accessedStorage> .Map => ?_ </accessedStorage>
          <createdAccounts> .Set => ?_ </createdAccounts>
        </substate>
        ...
      </evm>
      <network>
        <accounts>
          <account>
            <acctID> 20480 </acctID>
            <balance> 0 </balance>
            <code> #superchainConfigProgram </code>
            <storage> 0 |-> (GUARDIAN_ADDR *Int 65536 +Int 2) 75506153327051474587906755573858019282972751592871715030499431892688993766217 |-> (0 => PAUSED_AT) SC_STORAGE:Map </storage>
            <origStorage> 0 |-> (GUARDIAN_ADDR *Int 65536 +Int 2) 75506153327051474587906755573858019282972751592871715030499431892688993766217 |-> 0 SC_STORAGE:Map </origStorage>
            <nonce> 1 </nonce>
            <transientStorage> .Map </transientStorage>
          </account>
          ...
        </accounts>
        ...
      </network>
    </ethereum>
    requires #rangeAddress(GUARDIAN_ADDR)
     andBool GUARDIAN_ADDR >Int 0
     andBool PAUSED_AT >Int 0
     andBool #rangeUInt(256, PAUSED_AT)
endmodule
