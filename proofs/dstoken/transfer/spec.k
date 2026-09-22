requires "verification.k"

module SPEC
  imports VERIFICATION

  claim [raw-transfer-failure-nonpayable]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <static> false </static>
    <program> #binRuntime(DSTOKEN) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(DSTOKEN)) </jumpDests>
    <id> TOKEN </id>
    <caller> SRC </caller>
    <callData> #abiCallData("transfer", #address(DST), #uint256(WAD)) </callData>
    <callValue> VALUE </callValue>
    <wordStack> .WordStack => ?FINAL_WS:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEM:Bytes </localMem>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <gas> 0 => ?FINAL_GAS:Gas </gas>
    <memoryUsed> 0 => ?FINAL_MU:Int </memoryUsed>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_REVERT </statusCode>
    <log> LOGS </log>
    <account>
      <acctID> TOKEN </acctID>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, VALUE)
     andBool VALUE =/=Int 0

  claim [raw-transfer-success-distinct]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <static> false </static>
    <program> #binRuntime(DSTOKEN) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(DSTOKEN)) </jumpDests>
    <id> TOKEN </id>
    <caller> SRC </caller>
    <callData> #abiCallData("transfer", #address(DST), #uint256(WAD)) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINAL_WS:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEM:Bytes </localMem>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <gas> 0 => ?FINAL_GAS:Gas </gas>
    <memoryUsed> 0 => ?FINAL_MU:Int </memoryUsed>
    <output> .Bytes => #buf(32, 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <log>
      LOGS
      => LOGS
           ListItem({ TOKEN
                    | ListItem(2835717307 *Int pow224) ListItem(SRC) ListItem(DST) ListItem(WAD)
                    | #buf(32, 0) +Bytes #buf(32, 64) +Bytes #buf(32, 68)
                      +Bytes #abiCallData("transfer", #address(DST), #uint256(WAD)) })
           ListItem({ TOKEN
                    | ListItem(100389287136786176327247604509743168900146139575972864366142685224231313322991)
                      ListItem(SRC) ListItem(DST)
                    | #buf(32, WAD) })
    </log>
    <account>
      <acctID> TOKEN </acctID>
      <storage>
        STORAGE
        => STORAGE
             [ #hashedLocation("Solidity", 1, SRC .IntList) <- SRCBAL -Int WAD ]
             [ #hashedLocation("Solidity", 1, DST .IntList) <- DSTBAL +Int WAD ]
      </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, SRCBAL)
     andBool #rangeUInt(256, DSTBAL)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool (#range(#buf(32, #lookup(STORAGE, 4) /Int pow160), 31, 1) ==K b"\x00")
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, SRC .IntList)) ==Int SRCBAL)
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, DST .IntList)) ==Int DSTBAL)
     andBool (#hashedLocation("Solidity", 1, SRC .IntList) =/=Int #hashedLocation("Solidity", 1, DST .IntList))
     andBool (WAD <=Int SRCBAL)
     andBool (DSTBAL +Int WAD <Int pow256)

  claim [raw-transfer-success-same-slot]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <static> false </static>
    <program> #binRuntime(DSTOKEN) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(DSTOKEN)) </jumpDests>
    <id> TOKEN </id>
    <caller> SRC </caller>
    <callData> #abiCallData("transfer", #address(DST), #uint256(WAD)) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINAL_WS:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEM:Bytes </localMem>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <gas> 0 => ?FINAL_GAS:Gas </gas>
    <memoryUsed> 0 => ?FINAL_MU:Int </memoryUsed>
    <output> .Bytes => #buf(32, 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <log>
      LOGS
      => LOGS
           ListItem({ TOKEN
                    | ListItem(2835717307 *Int pow224) ListItem(SRC) ListItem(DST) ListItem(WAD)
                    | #buf(32, 0) +Bytes #buf(32, 64) +Bytes #buf(32, 68)
                      +Bytes #abiCallData("transfer", #address(DST), #uint256(WAD)) })
           ListItem({ TOKEN
                    | ListItem(100389287136786176327247604509743168900146139575972864366142685224231313322991)
                      ListItem(SRC) ListItem(DST)
                    | #buf(32, WAD) })
    </log>
    <account>
      <acctID> TOKEN </acctID>
      <storage>
        STORAGE
        => STORAGE
             [ #hashedLocation("Solidity", 1, SRC .IntList) <- SRCBAL -Int WAD ]
             [ #hashedLocation("Solidity", 1, DST .IntList) <- SRCBAL ]
      </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, SRCBAL)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool (#range(#buf(32, #lookup(STORAGE, 4) /Int pow160), 31, 1) ==K b"\x00")
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, SRC .IntList)) ==Int SRCBAL)
     andBool (#hashedLocation("Solidity", 1, SRC .IntList) ==Int #hashedLocation("Solidity", 1, DST .IntList))
     andBool (WAD <=Int SRCBAL)

  claim [raw-transfer-failure-stopped]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <static> false </static>
    <program> #binRuntime(DSTOKEN) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(DSTOKEN)) </jumpDests>
    <id> TOKEN </id>
    <caller> SRC </caller>
    <callData> #abiCallData("transfer", #address(DST), #uint256(WAD)) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINAL_WS:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEM:Bytes </localMem>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <gas> 0 => ?FINAL_GAS:Gas </gas>
    <memoryUsed> 0 => ?FINAL_MU:Int </memoryUsed>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_INVALID_INSTRUCTION </statusCode>
    <log> LOGS </log>
    <account>
      <acctID> TOKEN </acctID>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool (#range(#buf(32, #lookup(STORAGE, 4) /Int pow160), 31, 1) =/=K b"\x00")

  claim [raw-transfer-failure-insufficient-balance]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <static> false </static>
    <program> #binRuntime(DSTOKEN) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(DSTOKEN)) </jumpDests>
    <id> TOKEN </id>
    <caller> SRC </caller>
    <callData> #abiCallData("transfer", #address(DST), #uint256(WAD)) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINAL_WS:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEM:Bytes </localMem>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <gas> 0 => ?FINAL_GAS:Gas </gas>
    <memoryUsed> 0 => ?FINAL_MU:Int </memoryUsed>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_INVALID_INSTRUCTION </statusCode>
    <log>
      LOGS
      => LOGS ListItem({ TOKEN
                      | ListItem(2835717307 *Int pow224) ListItem(SRC) ListItem(DST) ListItem(WAD)
                      | #buf(32, 0) +Bytes #buf(32, 64) +Bytes #buf(32, 68)
                        +Bytes #abiCallData("transfer", #address(DST), #uint256(WAD)) })
    </log>
    <account>
      <acctID> TOKEN </acctID>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, SRCBAL)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool (#range(#buf(32, #lookup(STORAGE, 4) /Int pow160), 31, 1) ==K b"\x00")
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, SRC .IntList)) ==Int SRCBAL)
     andBool (SRCBAL <Int WAD)

  claim [raw-transfer-failure-overflow]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <static> false </static>
    <program> #binRuntime(DSTOKEN) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(DSTOKEN)) </jumpDests>
    <id> TOKEN </id>
    <caller> SRC </caller>
    <callData> #abiCallData("transfer", #address(DST), #uint256(WAD)) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINAL_WS:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEM:Bytes </localMem>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <gas> 0 => ?FINAL_GAS:Gas </gas>
    <memoryUsed> 0 => ?FINAL_MU:Int </memoryUsed>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_INVALID_INSTRUCTION </statusCode>
    <log>
      LOGS
      => LOGS ListItem({ TOKEN
                      | ListItem(2835717307 *Int pow224) ListItem(SRC) ListItem(DST) ListItem(WAD)
                      | #buf(32, 0) +Bytes #buf(32, 64) +Bytes #buf(32, 68)
                        +Bytes #abiCallData("transfer", #address(DST), #uint256(WAD)) })
    </log>
    <account>
      <acctID> TOKEN </acctID>
      <storage>
        STORAGE => STORAGE [ #hashedLocation("Solidity", 1, SRC .IntList) <- SRCBAL -Int WAD ]
      </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, SRCBAL)
     andBool #rangeUInt(256, DSTBAL)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool (#range(#buf(32, #lookup(STORAGE, 4) /Int pow160), 31, 1) ==K b"\x00")
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, SRC .IntList)) ==Int SRCBAL)
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, DST .IntList)) ==Int DSTBAL)
     andBool (#hashedLocation("Solidity", 1, SRC .IntList) =/=Int #hashedLocation("Solidity", 1, DST .IntList))
     andBool (WAD <=Int SRCBAL)
     andBool (pow256 <=Int DSTBAL +Int WAD)

  claim [transfer-success-distinct]:
    <k>
      #pushCallStack ~> #pushWorldState
      ~> #mkCall SRC TOKEN TOKEN #binRuntime(DSTOKEN) 0
           #abiCallData("transfer", #address(DST), #uint256(WAD)) false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <log>
      LOGS
      => LOGS
           ListItem({ TOKEN
                    | ListItem(2835717307 *Int pow224) ListItem(SRC) ListItem(DST) ListItem(WAD)
                    | #buf(32, 0) +Bytes #buf(32, 64) +Bytes #buf(32, 68)
                      +Bytes #abiCallData("transfer", #address(DST), #uint256(WAD)) })
           ListItem({ TOKEN
                    | ListItem(100389287136786176327247604509743168900146139575972864366142685224231313322991)
                      ListItem(SRC) ListItem(DST)
                    | #buf(32, WAD) })
    </log>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <touchedAccounts> TOUCHED => TOUCHED |Set SetItem(SRC) |Set SetItem(TOKEN) </touchedAccounts>
    <accessedAccounts> ACCESSED => ACCESSED |Set SetItem(SRC) |Set SetItem(TOKEN) </accessedAccounts>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> .Account </id>
    <caller> .Account </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => 1 : .WordStack </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> 0 </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> 0 </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> .Account </codeAddr>
    <account>
      <acctID> TOKEN </acctID>
      <storage>
        STORAGE
        => STORAGE
             [ #hashedLocation("Solidity", 1, SRC .IntList) <- SRCBAL -Int WAD ]
             [ #hashedLocation("Solidity", 1, DST    .IntList) <- DSTBAL +Int WAD ]
      </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool TOKEN >Int 8
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, SRCBAL)
     andBool #rangeUInt(256, DSTBAL)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool (#range(#buf(32, #lookup(STORAGE, 4) /Int pow160), 31, 1) ==K b"\x00")
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, SRC .IntList)) ==Int SRCBAL)
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, DST    .IntList)) ==Int DSTBAL)
     andBool (#hashedLocation("Solidity", 1, SRC .IntList) =/=Int #hashedLocation("Solidity", 1, DST .IntList))
     andBool (WAD <=Int SRCBAL)
     andBool (DSTBAL +Int WAD <Int pow256)

  claim [transfer-success-same-slot]:
    <k>
      #pushCallStack ~> #pushWorldState
      ~> #mkCall SRC TOKEN TOKEN #binRuntime(DSTOKEN) 0
           #abiCallData("transfer", #address(DST), #uint256(WAD)) false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <log>
      LOGS
      => LOGS
           ListItem({ TOKEN
                    | ListItem(2835717307 *Int pow224) ListItem(SRC) ListItem(DST) ListItem(WAD)
                    | #buf(32, 0) +Bytes #buf(32, 64) +Bytes #buf(32, 68)
                      +Bytes #abiCallData("transfer", #address(DST), #uint256(WAD)) })
           ListItem({ TOKEN
                    | ListItem(100389287136786176327247604509743168900146139575972864366142685224231313322991)
                      ListItem(SRC) ListItem(DST)
                    | #buf(32, WAD) })
    </log>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <touchedAccounts> TOUCHED => TOUCHED |Set SetItem(SRC) |Set SetItem(TOKEN) </touchedAccounts>
    <accessedAccounts> ACCESSED => ACCESSED |Set SetItem(SRC) |Set SetItem(TOKEN) </accessedAccounts>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> .Account </id>
    <caller> .Account </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => 1 : .WordStack </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> 0 </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> 0 </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> .Account </codeAddr>
    <account>
      <acctID> TOKEN </acctID>
      <storage>
        STORAGE
        => STORAGE
             [ #hashedLocation("Solidity", 1, SRC .IntList) <- SRCBAL -Int WAD ]
             [ #hashedLocation("Solidity", 1, DST .IntList) <- SRCBAL ]
      </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool TOKEN >Int 8
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, SRCBAL)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool (#range(#buf(32, #lookup(STORAGE, 4) /Int pow160), 31, 1) ==K b"\x00")
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, SRC .IntList)) ==Int SRCBAL)
     andBool (#hashedLocation("Solidity", 1, SRC .IntList) ==Int #hashedLocation("Solidity", 1, DST .IntList))
     andBool (WAD <=Int SRCBAL)

  claim [transfer-failure-nonpayable]:
    <k>
      #pushCallStack ~> #pushWorldState
      ~> #mkCall SRC TOKEN TOKEN #binRuntime(DSTOKEN) VALUE
           #abiCallData("transfer", #address(DST), #uint256(WAD)) false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_REVERT </statusCode>
    <log> LOGS </log>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <touchedAccounts> TOUCHED => TOUCHED |Set SetItem(SRC) |Set SetItem(TOKEN) </touchedAccounts>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> .Account </id>
    <caller> .Account </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => 0 : .WordStack </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> 0 </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> 0 </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> .Account </codeAddr>
    <account>
      <acctID> TOKEN </acctID>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool TOKEN >Int 8
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, VALUE)
     andBool VALUE =/=Int 0

  claim [transfer-failure-stopped]:
    <k>
      #pushCallStack ~> #pushWorldState
      ~> #mkCall SRC TOKEN TOKEN #binRuntime(DSTOKEN) 0
           #abiCallData("transfer", #address(DST), #uint256(WAD)) false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_INVALID_INSTRUCTION </statusCode>
    <log> LOGS </log>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <touchedAccounts> TOUCHED => TOUCHED |Set SetItem(SRC) |Set SetItem(TOKEN) </touchedAccounts>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> .Account </id>
    <caller> .Account </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => 0 : .WordStack </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> 0 </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> 0 </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> .Account </codeAddr>
    <account>
      <acctID> TOKEN </acctID>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool TOKEN >Int 8
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool (#range(#buf(32, #lookup(STORAGE, 4) /Int pow160), 31, 1) =/=K b"\x00")

  claim [transfer-failure-insufficient-balance]:
    <k>
      #pushCallStack ~> #pushWorldState
      ~> #mkCall SRC TOKEN TOKEN #binRuntime(DSTOKEN) 0
           #abiCallData("transfer", #address(DST), #uint256(WAD)) false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_INVALID_INSTRUCTION </statusCode>
    <log> LOGS </log>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <touchedAccounts> TOUCHED => TOUCHED |Set SetItem(SRC) |Set SetItem(TOKEN) </touchedAccounts>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> .Account </id>
    <caller> .Account </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => 0 : .WordStack </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> 0 </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> 0 </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> .Account </codeAddr>
    <account>
      <acctID> TOKEN </acctID>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool TOKEN >Int 8
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, SRCBAL)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool (#range(#buf(32, #lookup(STORAGE, 4) /Int pow160), 31, 1) ==K b"\x00")
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, SRC .IntList)) ==Int SRCBAL)
     andBool (SRCBAL <Int WAD)

  claim [transfer-failure-overflow]:
    <k>
      #pushCallStack ~> #pushWorldState
      ~> #mkCall SRC TOKEN TOKEN #binRuntime(DSTOKEN) 0
           #abiCallData("transfer", #address(DST), #uint256(WAD)) false
      ~> #return 0 0
      => .K
    </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <output> .Bytes </output>
    <statusCode> .StatusCode => EVMC_INVALID_INSTRUCTION </statusCode>
    <log> LOGS </log>
    <callStack> .List </callStack>
    <interimStates> .List </interimStates>
    <touchedAccounts> TOUCHED => TOUCHED |Set SetItem(SRC) |Set SetItem(TOKEN) </touchedAccounts>
    <program> .Bytes </program>
    <jumpDests> .Bytes </jumpDests>
    <id> .Account </id>
    <caller> .Account </caller>
    <callData> .Bytes </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => 0 : .WordStack </wordStack>
    <localMem> .Bytes </localMem>
    <pc> 0 </pc>
    <gas> 0 </gas>
    <memoryUsed> 0 </memoryUsed>
    <callGas> 0 </callGas>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <codeAddr> .Account </codeAddr>
    <account>
      <acctID> TOKEN </acctID>
      <storage> STORAGE </storage>
      ...
    </account>
    requires #rangeAddress(TOKEN)
     andBool TOKEN >Int 8
     andBool #rangeAddress(SRC)
     andBool #rangeAddress(DST)
     andBool #rangeUInt(256, WAD)
     andBool #rangeUInt(256, SRCBAL)
     andBool #rangeUInt(256, DSTBAL)
     andBool #rangeUInt(256, #lookup(STORAGE, 4))
     andBool (#range(#buf(32, #lookup(STORAGE, 4) /Int pow160), 31, 1) ==K b"\x00")
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, SRC .IntList)) ==Int SRCBAL)
     andBool (#lookup(STORAGE, #hashedLocation("Solidity", 1, DST    .IntList)) ==Int DSTBAL)
     andBool (#hashedLocation("Solidity", 1, SRC .IntList) =/=Int #hashedLocation("Solidity", 1, DST .IntList))
     andBool (WAD <=Int SRCBAL)
     andBool (pow256 <=Int DSTBAL +Int WAD)

endmodule
