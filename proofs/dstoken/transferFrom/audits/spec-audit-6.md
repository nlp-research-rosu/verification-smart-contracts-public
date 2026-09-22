# KIT specification audit 6

## Trigger and evidence

Focused proof 5 (`/app/.kprover/sessions/0965306b-374d-4868-a291-37d3096894d4/proof-005/result.json`) executed the distinct-address success path to its final state. Storage, status, output, caller flag, and Transfer event matched. The sole failed cell was `<log>`.

## Finding

Source construct: `LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data)` from the old Solidity compiler represented by the supplied runtime.

Formal term: `#transferFromLogs` used `#encodeArgs(#uint256(0), #bytes(CALLDATA))`. The pinned ABI helper pads the 100-byte dynamic calldata tail to 128 bytes, producing 224 bytes of note data.

Fixed-bytecode witness: proof 5's final `LOG_CELL` contains 32-byte zero `msg.value`, 32-byte offset 64, 32-byte length 100, and exactly the 100 canonical calldata bytes, with no final 28 zero bytes. Its note data is 196 bytes. The candidate consequent contained the same prefix plus 28 zero bytes and therefore did not match. This occurs for any satisfying ground success, for example distinct addresses, amount zero, stopped false, and sufficient zero balance/allowance.

Required repair: define the anonymous note data directly as `#buf(32, 0) +Bytes #buf(32, 64) +Bytes #buf(32, 100) +Bytes #abiCallData(...)`, recording the supplied compiler's unpadded trailing dynamic bytes in scope. Do not alter execution or the standard Transfer event.

VERDICT: FAIL
TARGET: writing-spec
REASON: The LogNote summary adds 28 trailing zero bytes that the supplied runtime does not emit.
