requires "verification.k"

module PAUSE-GLOBAL-SYMBOLIC-SPEC
  imports VERIFICATION

  claim [global-pause-getter-true-for-active-pause]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> LONDON </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <block>
          <timestamp> NOW </timestamp>
          ...
        </block>
        <output> _ => #buf(32, 1) </output>
        <statusCode> _ => EVMC_SUCCESS </statusCode>
        <callStack> .List </callStack>
        <interimStates> .List </interimStates>
        <touchedAccounts> .Set => ?_ </touchedAccounts>
        <callState>
          <program> #superchainConfigProgram </program>
          <jumpDests> #computeValidJumpDests(#superchainConfigProgram) </jumpDests>
          <id> 20480 </id>
          <codeAddr> 20480 </codeAddr>
          <caller> CALLER_ADDR </caller>
          <callData> #abiCallData("isLocalOrGlobalPaused", #address(LOCKBOX_ADDR)) </callData>
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
            <acctID> 20480 </acctID>
            <balance> 0 </balance>
            <code> #superchainConfigProgram </code>
            <storage> 75506153327051474587906755573858019282972751592871715030499431892688993766217 |-> PAUSED_AT SC_STORAGE:Map </storage>
            <origStorage> 75506153327051474587906755573858019282972751592871715030499431892688993766217 |-> PAUSED_AT SC_STORAGE:Map </origStorage>
            <nonce> 1 </nonce>
            <transientStorage> .Map </transientStorage>
          </account>
          ...
        </accounts>
        ...
      </network>
    </ethereum>
    requires #rangeAddress(CALLER_ADDR)
     andBool #rangeAddress(LOCKBOX_ADDR)
     andBool PAUSED_AT >Int 0
     andBool NOW >=Int PAUSED_AT
     andBool NOW <Int PAUSED_AT +Int 7884000
     andBool #rangeUInt(256, PAUSED_AT +Int 7884000)
endmodule
