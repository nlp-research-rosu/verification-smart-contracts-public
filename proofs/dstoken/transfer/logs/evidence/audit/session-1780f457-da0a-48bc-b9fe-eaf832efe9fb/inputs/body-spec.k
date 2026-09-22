requires "body-verification.k"

module AUDIT-BODY
  imports VERIFICATION

  claim [mutated-return-body]:
    <k> #execute => #halt ... </k>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <useGas> false </useGas>
    <static> false </static>
    <program> #binRuntime(DSTOKEN) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(DSTOKEN)) </jumpDests>
    <id> 0 </id>
    <caller> 1 </caller>
    <callData> #abiCallData("transfer", #address(1), #uint256(3)) </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINAL_WS:WordStack </wordStack>
    <localMem> .Bytes => ?FINAL_MEM:Bytes </localMem>
    <pc> 0 => ?FINAL_PC:Int </pc>
    <gas> 0 => ?FINAL_GAS:Gas </gas>
    <memoryUsed> 0 => ?FINAL_MU:Int </memoryUsed>
    <output> .Bytes => #buf(32, 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <log>
      .List
      => .List
           ListItem({ 0
                    | ListItem(2835717307 *Int pow224) ListItem(1) ListItem(1) ListItem(3)
                    | #buf(32, 0) +Bytes #buf(32, 64) +Bytes #buf(32, 68)
                      +Bytes #abiCallData("transfer", #address(1), #uint256(3)) })
           ListItem({ 0
                    | ListItem(100389287136786176327247604509743168900146139575972864366142685224231313322991)
                      ListItem(1) ListItem(1)
                    | #buf(32, 3) })
    </log>
    <account>
      <acctID> 0 </acctID>
      <storage>
        (4 |-> 0 #hashedLocation("Solidity", 1, 1 .IntList) |-> 7)
        => (4 |-> 0 #hashedLocation("Solidity", 1, 1 .IntList) |-> 7)
             [ #hashedLocation("Solidity", 1, 1 .IntList) <- 7 -Int 3 ]
             [ #hashedLocation("Solidity", 1, 1 .IntList) <- 7 ]
      </storage>
      ...
    </account>
    requires #rangeAddress(0)
     andBool #rangeAddress(1)
     andBool #rangeAddress(1)
     andBool #rangeUInt(256, 3)
     andBool #rangeUInt(256, 7)
     andBool #rangeUInt(256, #lookup((4 |-> 0 #hashedLocation("Solidity", 1, 1 .IntList) |-> 7), 4))
     andBool (#range(#buf(32, #lookup((4 |-> 0 #hashedLocation("Solidity", 1, 1 .IntList) |-> 7), 4) /Int pow160), 31, 1) ==K b"\x00")
     andBool (#lookup((4 |-> 0 #hashedLocation("Solidity", 1, 1 .IntList) |-> 7), #hashedLocation("Solidity", 1, 1 .IntList)) ==Int 7)
     andBool (#hashedLocation("Solidity", 1, 1 .IntList) ==Int #hashedLocation("Solidity", 1, 1 .IntList))
     andBool (3 <=Int 7)

endmodule
