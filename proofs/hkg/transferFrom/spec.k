requires "verification.k"

module SPEC
  imports VERIFICATION

  claim [transferFrom-success]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> CANCUN </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 1) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <program> #binRuntime(HKG) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(HKG)) </jumpDests>
    <id> ACCT </id>
    <caller> CALLER_ID </caller>
    <callData>
      #abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE))
    </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINALSTACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINALMEM:Bytes </localMem>
    <pc> 0 => ?FINALPC:Int </pc>
    <gas> 0 </gas>
    <memoryUsed> 0 => ?FINALMEMUSED:Int </memoryUsed>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <log>
      .List
      => ListItem(
           #abiEventLog(
             ACCT,
             "Transfer",
             #indexed(#address(FROM)),
             #indexed(#address(TO)),
             #uint256(VALUE)))
    </log>
    <accounts>
      <account>
        <acctID> ACCT </acctID>
        <storage>
          STORAGE
          => ( STORAGE
               [ #hashedLocation("Solidity", 1, FROM .IntList)
                   <- #lookup(
                        STORAGE,
                        #hashedLocation("Solidity", 1, FROM .IntList)) -Word VALUE ]
               [ #hashedLocation("Solidity", 1, TO .IntList)
                   <- #lookup(
                        STORAGE
                        [ #hashedLocation("Solidity", 1, FROM .IntList)
                            <- #lookup(
                                 STORAGE,
                                 #hashedLocation("Solidity", 1, FROM .IntList)) -Word VALUE ],
                        #hashedLocation("Solidity", 1, TO .IntList)) +Word VALUE ] )
             [ #hashedLocation("Solidity", 2, FROM CALLER_ID .IntList)
                 <- #lookup(
                      STORAGE
                      [ #hashedLocation("Solidity", 1, FROM .IntList)
                          <- #lookup(
                               STORAGE,
                               #hashedLocation("Solidity", 1, FROM .IntList)) -Word VALUE ]
                      [ #hashedLocation("Solidity", 1, TO .IntList)
                          <- #lookup(
                               STORAGE
                               [ #hashedLocation("Solidity", 1, FROM .IntList)
                                   <- #lookup(
                                        STORAGE,
                                        #hashedLocation("Solidity", 1, FROM .IntList)) -Word VALUE ],
                               #hashedLocation("Solidity", 1, TO .IntList)) +Word VALUE ],
                      #hashedLocation("Solidity", 2, FROM CALLER_ID .IntList)) -Word VALUE ]
        </storage>
        ...
      </account>
      ...
    </accounts>
    requires #rangeAddress(ACCT)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(FROM)
     andBool #rangeAddress(TO)
     andBool #rangeUInt(256, VALUE)
     andBool #lookup(STORAGE, #hashedLocation("Solidity", 1, FROM .IntList)) >=Int VALUE
     andBool #lookup(STORAGE, #hashedLocation("Solidity", 2, FROM CALLER_ID .IntList)) >=Int VALUE
     andBool VALUE >Int 0

  claim [transferFrom-fail-zero]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> CANCUN </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 0) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <program> #binRuntime(HKG) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(HKG)) </jumpDests>
    <id> ACCT </id>
    <caller> CALLER_ID </caller>
    <callData>
      #abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE))
    </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINALSTACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINALMEM:Bytes </localMem>
    <pc> 0 => ?FINALPC:Int </pc>
    <gas> 0 </gas>
    <memoryUsed> 0 => ?FINALMEMUSED:Int </memoryUsed>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <log> .List </log>
    <accounts>
      <account>
        <acctID> ACCT </acctID>
        <storage> STORAGE </storage>
        ...
      </account>
      ...
    </accounts>
    requires #rangeAddress(ACCT)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(FROM)
     andBool #rangeAddress(TO)
     andBool VALUE ==Int 0

  claim [transferFrom-fail-balance]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> CANCUN </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 0) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <program> #binRuntime(HKG) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(HKG)) </jumpDests>
    <id> ACCT </id>
    <caller> CALLER_ID </caller>
    <callData>
      #abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE))
    </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINALSTACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINALMEM:Bytes </localMem>
    <pc> 0 => ?FINALPC:Int </pc>
    <gas> 0 </gas>
    <memoryUsed> 0 => ?FINALMEMUSED:Int </memoryUsed>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <log> .List </log>
    <accounts>
      <account>
        <acctID> ACCT </acctID>
        <storage> STORAGE </storage>
        ...
      </account>
      ...
    </accounts>
    requires #rangeAddress(ACCT)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(FROM)
     andBool #rangeAddress(TO)
     andBool #rangeUInt(256, VALUE)
     andBool VALUE >Int 0
     andBool #lookup(STORAGE, #hashedLocation("Solidity", 1, FROM .IntList)) <Int VALUE

  claim [transferFrom-fail-allowance]:
    <k> #execute => #halt </k>
    <mode> NORMAL </mode>
    <schedule> CANCUN </schedule>
    <useGas> false </useGas>
    <output> .Bytes => #buf(32, 0) </output>
    <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
    <program> #binRuntime(HKG) </program>
    <jumpDests> #computeValidJumpDests(#binRuntime(HKG)) </jumpDests>
    <id> ACCT </id>
    <caller> CALLER_ID </caller>
    <callData>
      #abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE))
    </callData>
    <callValue> 0 </callValue>
    <wordStack> .WordStack => ?FINALSTACK:WordStack </wordStack>
    <localMem> .Bytes => ?FINALMEM:Bytes </localMem>
    <pc> 0 => ?FINALPC:Int </pc>
    <gas> 0 </gas>
    <memoryUsed> 0 => ?FINALMEMUSED:Int </memoryUsed>
    <static> false </static>
    <callDepth> 0 </callDepth>
    <log> .List </log>
    <accounts>
      <account>
        <acctID> ACCT </acctID>
        <storage> STORAGE </storage>
        ...
      </account>
      ...
    </accounts>
    requires #rangeAddress(ACCT)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(FROM)
     andBool #rangeAddress(TO)
     andBool #rangeUInt(256, VALUE)
     andBool VALUE >Int 0
     andBool #lookup(STORAGE, #hashedLocation("Solidity", 1, FROM .IntList)) >=Int VALUE
     andBool #lookup(STORAGE, #hashedLocation("Solidity", 2, FROM CALLER_ID .IntList)) <Int VALUE
endmodule
