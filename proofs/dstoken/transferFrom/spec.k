requires "verification.k"

module TRANSFER-FROM-SPEC
  imports VERIFICATION

  claim [transferfrom-success-distinct]:
    <k>
      #pushCallStack
      ~> #pushWorldState
      ~> #mkCall GUY TOKEN TOKEN #binRuntime(DSTOKEN) 0
           #abiCallData(
             "transferFrom",
             #address(SRC),
             #address(DST),
             #uint256(WAD)
           )
           false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> SHANGHAI </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> GUY </id>
    <caller> GUY </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> WS => 1 : WS </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> GAS_AVAILABLE </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> CALL_GAS </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> GUY </codeAddr>
    <log>
      .List
      =>
      #transferFromLogs(TOKEN, GUY, SRC, DST, WAD)
    </log>
    <touchedAccounts>
      TOUCHED => TOUCHED |Set SetItem(GUY) |Set SetItem(TOKEN)
    </touchedAccounts>
    <accessedAccounts>
      ACCESSED => ACCESSED |Set SetItem(GUY) |Set SetItem(TOKEN)
    </accessedAccounts>
    <selfDestruct> .Set </selfDestruct>
    <refund> 0 </refund>
    <accessedStorage> .Map </accessedStorage>
    <createdAccounts> .Set </createdAccounts>
    <account>
      <acctID> TOKEN </acctID>
      <code> #binRuntime(DSTOKEN) </code>
      <storage>
        STORAGE
        =>
        STORAGE
          [ #allowanceSlot(SRC, GUY) <-
              #lookup(STORAGE, #allowanceSlot(SRC, GUY)) -Int WAD ]
          [ #balanceSlot(SRC) <-
              #lookup(STORAGE, #balanceSlot(SRC)) -Int WAD ]
          [ #balanceSlot(DST) <-
              #lookup(STORAGE, #balanceSlot(DST)) +Int WAD ]
      </storage>
      ...
    </account>
    requires #rangeAddress(SRC)
      andBool #rangeAddress(DST)
      andBool #rangeAddress(GUY)
      andBool #rangeAddress(TOKEN)
      andBool (TOKEN ==Int 0 orBool TOKEN >Int 9)
      andBool #rangeUInt(256, WAD)
      andBool SRC =/=Int DST
      andBool #rangeUInt(256, #lookup(STORAGE, 4))
      andBool #stoppedByteIsZero(STORAGE)
      andBool #rangeUInt(256, #lookup(STORAGE, #balanceSlot(SRC)))
      andBool #rangeUInt(256, #lookup(STORAGE, #balanceSlot(DST)))
      andBool #rangeUInt(256, #lookup(STORAGE, #allowanceSlot(SRC, GUY)))
      andBool #lookup(STORAGE, #balanceSlot(SRC)) >=Int WAD
      andBool #lookup(STORAGE, #allowanceSlot(SRC, GUY)) >=Int WAD
      andBool #lookup(STORAGE, #balanceSlot(DST))
                <=Int 115792089237316195423570985008687907853269984665640564039457584007913129639935 -Int WAD
      andBool #balanceSlot(SRC) =/=Int 4
      andBool #balanceSlot(DST) =/=Int 4
      andBool #allowanceSlot(SRC, GUY) =/=Int 4
      andBool #balanceSlot(SRC) =/=Int #balanceSlot(DST)
      andBool #balanceSlot(SRC) =/=Int #allowanceSlot(SRC, GUY)
      andBool #balanceSlot(DST) =/=Int #allowanceSlot(SRC, GUY)

  claim [transferfrom-success-self]:
    <k>
      #pushCallStack
      ~> #pushWorldState
      ~> #mkCall GUY TOKEN TOKEN #binRuntime(DSTOKEN) 0
           #abiCallData(
             "transferFrom",
             #address(SRC),
             #address(SRC),
             #uint256(WAD)
           )
           false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> SHANGHAI </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> GUY </id>
    <caller> GUY </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> WS => 1 : WS </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> GAS_AVAILABLE </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> CALL_GAS </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> GUY </codeAddr>
    <log>
      .List
      =>
      #transferFromLogs(TOKEN, GUY, SRC, SRC, WAD)
    </log>
    <touchedAccounts>
      TOUCHED => TOUCHED |Set SetItem(GUY) |Set SetItem(TOKEN)
    </touchedAccounts>
    <accessedAccounts>
      ACCESSED => ACCESSED |Set SetItem(GUY) |Set SetItem(TOKEN)
    </accessedAccounts>
    <selfDestruct> .Set </selfDestruct>
    <refund> 0 </refund>
    <accessedStorage> .Map </accessedStorage>
    <createdAccounts> .Set </createdAccounts>
    <account>
      <acctID> TOKEN </acctID>
      <code> #binRuntime(DSTOKEN) </code>
      <storage>
        STORAGE
        =>
        STORAGE
          [ #allowanceSlot(SRC, GUY) <-
              #lookup(STORAGE, #allowanceSlot(SRC, GUY)) -Int WAD ]
          [ #balanceSlot(SRC) <-
              #lookup(STORAGE, #balanceSlot(SRC)) ]
      </storage>
      ...
    </account>
    requires #rangeAddress(SRC)
      andBool #rangeAddress(GUY)
      andBool #rangeAddress(TOKEN)
      andBool (TOKEN ==Int 0 orBool TOKEN >Int 9)
      andBool #rangeUInt(256, WAD)
      andBool #rangeUInt(256, #lookup(STORAGE, 4))
      andBool #stoppedByteIsZero(STORAGE)
      andBool #rangeUInt(256, #lookup(STORAGE, #balanceSlot(SRC)))
      andBool #rangeUInt(256, #lookup(STORAGE, #allowanceSlot(SRC, GUY)))
      andBool #lookup(STORAGE, #balanceSlot(SRC)) >=Int WAD
      andBool #lookup(STORAGE, #allowanceSlot(SRC, GUY)) >=Int WAD
      andBool #balanceSlot(SRC) =/=Int 4
      andBool #allowanceSlot(SRC, GUY) =/=Int 4
      andBool #balanceSlot(SRC) =/=Int #allowanceSlot(SRC, GUY)

  claim [transferfrom-failure-stopped]:
    <k>
      #pushCallStack
      ~> #pushWorldState
      ~> #mkCall GUY TOKEN TOKEN #binRuntime(DSTOKEN) 0
           #abiCallData(
             "transferFrom",
             #address(SRC),
             #address(DST),
             #uint256(WAD)
           )
           false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> SHANGHAI </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_INVALID_INSTRUCTION </statusCode>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> GUY </id>
    <caller> GUY </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> WS => 0 : WS </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> GAS_AVAILABLE </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> CALL_GAS </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> GUY </codeAddr>
    <log> .List </log>
    <touchedAccounts>
      TOUCHED => TOUCHED |Set SetItem(GUY) |Set SetItem(TOKEN)
    </touchedAccounts>
    <accessedAccounts> ACCESSED </accessedAccounts>
    <selfDestruct> .Set </selfDestruct>
    <refund> 0 </refund>
    <accessedStorage> .Map </accessedStorage>
    <createdAccounts> .Set </createdAccounts>
    <account>
      <acctID> TOKEN </acctID>
      <code> #binRuntime(DSTOKEN) </code>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(SRC)
      andBool #rangeAddress(DST)
      andBool #rangeAddress(GUY)
      andBool #rangeAddress(TOKEN)
      andBool (TOKEN ==Int 0 orBool TOKEN >Int 9)
      andBool #rangeUInt(256, WAD)
      andBool #rangeUInt(256, #lookup(STORAGE, 4))
      andBool notBool #stoppedByteIsZero(STORAGE)

  claim [transferfrom-failure-balance]:
    <k>
      #pushCallStack
      ~> #pushWorldState
      ~> #mkCall GUY TOKEN TOKEN #binRuntime(DSTOKEN) 0
           #abiCallData(
             "transferFrom",
             #address(SRC),
             #address(DST),
             #uint256(WAD)
           )
           false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> SHANGHAI </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_INVALID_INSTRUCTION </statusCode>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> GUY </id>
    <caller> GUY </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> WS => 0 : WS </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> GAS_AVAILABLE </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> CALL_GAS </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> GUY </codeAddr>
    <log> .List </log>
    <touchedAccounts>
      TOUCHED => TOUCHED |Set SetItem(GUY) |Set SetItem(TOKEN)
    </touchedAccounts>
    <accessedAccounts> ACCESSED </accessedAccounts>
    <selfDestruct> .Set </selfDestruct>
    <refund> 0 </refund>
    <accessedStorage> .Map </accessedStorage>
    <createdAccounts> .Set </createdAccounts>
    <account>
      <acctID> TOKEN </acctID>
      <code> #binRuntime(DSTOKEN) </code>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(SRC)
      andBool #rangeAddress(DST)
      andBool #rangeAddress(GUY)
      andBool #rangeAddress(TOKEN)
      andBool (TOKEN ==Int 0 orBool TOKEN >Int 9)
      andBool #rangeUInt(256, WAD)
      andBool #rangeUInt(256, #lookup(STORAGE, 4))
      andBool #stoppedByteIsZero(STORAGE)
      andBool #rangeUInt(256, #lookup(STORAGE, #balanceSlot(SRC)))
      andBool #lookup(STORAGE, #balanceSlot(SRC)) <Int WAD

  claim [transferfrom-failure-allowance]:
    <k>
      #pushCallStack
      ~> #pushWorldState
      ~> #mkCall GUY TOKEN TOKEN #binRuntime(DSTOKEN) 0
           #abiCallData(
             "transferFrom",
             #address(SRC),
             #address(DST),
             #uint256(WAD)
           )
           false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> SHANGHAI </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_INVALID_INSTRUCTION </statusCode>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> GUY </id>
    <caller> GUY </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> WS => 0 : WS </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> GAS_AVAILABLE </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> CALL_GAS </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> GUY </codeAddr>
    <log> .List </log>
    <touchedAccounts>
      TOUCHED => TOUCHED |Set SetItem(GUY) |Set SetItem(TOKEN)
    </touchedAccounts>
    <accessedAccounts> ACCESSED </accessedAccounts>
    <selfDestruct> .Set </selfDestruct>
    <refund> 0 </refund>
    <accessedStorage> .Map </accessedStorage>
    <createdAccounts> .Set </createdAccounts>
    <account>
      <acctID> TOKEN </acctID>
      <code> #binRuntime(DSTOKEN) </code>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(SRC)
      andBool #rangeAddress(DST)
      andBool #rangeAddress(GUY)
      andBool #rangeAddress(TOKEN)
      andBool (TOKEN ==Int 0 orBool TOKEN >Int 9)
      andBool #rangeUInt(256, WAD)
      andBool #rangeUInt(256, #lookup(STORAGE, 4))
      andBool #stoppedByteIsZero(STORAGE)
      andBool #rangeUInt(256, #lookup(STORAGE, #balanceSlot(SRC)))
      andBool #rangeUInt(256, #lookup(STORAGE, #allowanceSlot(SRC, GUY)))
      andBool #lookup(STORAGE, #balanceSlot(SRC)) >=Int WAD
      andBool #lookup(STORAGE, #allowanceSlot(SRC, GUY)) <Int WAD

  claim [transferfrom-failure-overflow]:
    <k>
      #pushCallStack
      ~> #pushWorldState
      ~> #mkCall GUY TOKEN TOKEN #binRuntime(DSTOKEN) 0
           #abiCallData(
             "transferFrom",
             #address(SRC),
             #address(DST),
             #uint256(WAD)
           )
           false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> SHANGHAI </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_INVALID_INSTRUCTION </statusCode>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> GUY </id>
    <caller> GUY </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> WS => 0 : WS </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> GAS_AVAILABLE </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> CALL_GAS </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> GUY </codeAddr>
    <log> .List </log>
    <touchedAccounts>
      TOUCHED => TOUCHED |Set SetItem(GUY) |Set SetItem(TOKEN)
    </touchedAccounts>
    <accessedAccounts> ACCESSED </accessedAccounts>
    <selfDestruct> .Set </selfDestruct>
    <refund> 0 </refund>
    <accessedStorage> .Map </accessedStorage>
    <createdAccounts> .Set </createdAccounts>
    <account>
      <acctID> TOKEN </acctID>
      <code> #binRuntime(DSTOKEN) </code>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(SRC)
      andBool #rangeAddress(DST)
      andBool #rangeAddress(GUY)
      andBool #rangeAddress(TOKEN)
      andBool (TOKEN ==Int 0 orBool TOKEN >Int 9)
      andBool #rangeUInt(256, WAD)
      andBool SRC =/=Int DST
      andBool #rangeUInt(256, #lookup(STORAGE, 4))
      andBool #stoppedByteIsZero(STORAGE)
      andBool #rangeUInt(256, #lookup(STORAGE, #balanceSlot(SRC)))
      andBool #rangeUInt(256, #lookup(STORAGE, #balanceSlot(DST)))
      andBool #rangeUInt(256, #lookup(STORAGE, #allowanceSlot(SRC, GUY)))
      andBool #lookup(STORAGE, #balanceSlot(SRC)) >=Int WAD
      andBool #lookup(STORAGE, #allowanceSlot(SRC, GUY)) >=Int WAD
      andBool #lookup(STORAGE, #balanceSlot(DST))
                >Int 115792089237316195423570985008687907853269984665640564039457584007913129639935 -Int WAD
      andBool #balanceSlot(SRC) =/=Int 4
      andBool #balanceSlot(DST) =/=Int 4
      andBool #allowanceSlot(SRC, GUY) =/=Int 4
      andBool #balanceSlot(SRC) =/=Int #balanceSlot(DST)
      andBool #balanceSlot(SRC) =/=Int #allowanceSlot(SRC, GUY)
      andBool #balanceSlot(DST) =/=Int #allowanceSlot(SRC, GUY)

  claim [transferfrom-failure-nonpayable]:
    <k>
      #pushCallStack
      ~> #pushWorldState
      ~> #mkCall GUY TOKEN TOKEN #binRuntime(DSTOKEN) CALL_VALUE
           #abiCallData(
             "transferFrom",
             #address(SRC),
             #address(DST),
             #uint256(WAD)
           )
           false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> SHANGHAI </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_REVERT </statusCode>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> GUY </id>
    <caller> GUY </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> WS => 0 : WS </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> GAS_AVAILABLE </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> CALL_GAS </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> GUY </codeAddr>
    <log> .List </log>
    <touchedAccounts>
      TOUCHED => TOUCHED |Set SetItem(GUY) |Set SetItem(TOKEN)
    </touchedAccounts>
    <accessedAccounts> ACCESSED </accessedAccounts>
    <selfDestruct> .Set </selfDestruct>
    <refund> 0 </refund>
    <accessedStorage> .Map </accessedStorage>
    <createdAccounts> .Set </createdAccounts>
    <account>
      <acctID> TOKEN </acctID>
      <code> #binRuntime(DSTOKEN) </code>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(SRC)
      andBool #rangeAddress(DST)
      andBool #rangeAddress(GUY)
      andBool #rangeAddress(TOKEN)
      andBool (TOKEN ==Int 0 orBool TOKEN >Int 9)
      andBool #rangeUInt(256, WAD)
      andBool #rangeUInt(256, CALL_VALUE)
      andBool CALL_VALUE >Int 0
endmodule
