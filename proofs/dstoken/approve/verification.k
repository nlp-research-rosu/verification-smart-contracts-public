requires "edsl.md"
requires "lemmas/lemmas.k"
requires "bytecode.k"

module VERIFICATION-SUMMARIES
  imports EDSL
  imports DSTOKEN-BYTECODE

  syntax Bytes ::= approveCallData ( Int , Int ) [function]
  rule approveCallData(GUY, WAD)
    => #abiCallData("approve", #address(GUY), #uint256(WAD))

  syntax Int ::= approveSlot ( Int , Int ) [function, total]
  rule approveSlot(OWNER, GUY)
    => #hashedLocation("Solidity", 2, OWNER GUY)

  syntax Bool ::= stoppedClear ( Map ) [function, total]
  rule stoppedClear(STORAGE)
    => #range(#buf(32, #lookup(STORAGE, 4) /Int (2 ^Int 160)), 31, 1)
       ==K b"\x00"

  syntax Bytes ::= approveNoteData ( Int , Int ) [function]
  rule approveNoteData(GUY, WAD)
    => #buf(32, 0)
       +Bytes #buf(32, 64)
       +Bytes #buf(32, 68)
       +Bytes approveCallData(GUY, WAD)

  syntax SubstateLogEntry ::= approveNoteLog ( Int , Int , Int , Int ) [function]
  rule approveNoteLog(ACCT, CALLER_ID, GUY, WAD)
    => { ACCT
       | ListItem(4238056678808933066457772256406219440718756300954938350892797929791311314944)
         ListItem(CALLER_ID)
         ListItem(GUY)
         ListItem(WAD)
       | approveNoteData(GUY, WAD)
       }

  syntax SubstateLogEntry ::= approvalLog ( Int , Int , Int , Int ) [function]
  rule approvalLog(ACCT, CALLER_ID, GUY, WAD)
    => { ACCT
       | ListItem(63486140976153616755203102783360879283472101686154884697241723088393386309925)
         ListItem(CALLER_ID)
         ListItem(GUY)
       | #buf(32, WAD)
       }
endmodule

module VERIFICATION
  imports VERIFICATION-SUMMARIES
  imports LEMMAS
endmodule
