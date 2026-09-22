# Verification scope

## Program boundary

The raw claims start at runtime PC 0 with non-static execution and cover
all 160-bit contract addresses. The additional whole-call claims execute
the exact 6,955-byte runtime image in `program/contract.bin`, pinned in
`dstoken-bin.k`, through a nested EVM message-call boundary. The
entry is canonical ABI calldata for `transfer(address,uint256)` and execution
includes the dispatcher, the `note` and `stoppable` modifiers, the
`DSTokenBase.transfer` body, checked subtraction/addition, event opcodes,
return, exceptional halt, and the enclosing call's commit-or-rollback logic.

## Input domain

`SRC`, `DST`, and `TOKEN` range over 160-bit addresses; `WAD`, balances,
call value, and relevant storage words range over EVM uint256 words.  `TOKEN`
is constrained above the Byzantium precompile range only in whole-call
claims so that a message call to it executes the supplied runtime image.
Storage is otherwise symbolic. The
claims partition canonical calls into nonzero-value rejection, stopped
rejection, insufficient-balance rejection, destination-overflow rejection,
successful distinct storage locations, and successful coincident storage
locations (including self-transfer).  The source and destination mapping
locations are split explicitly because the fixed semantics does not assume
collision resistance for symbolic `keccak`.

## Observable final state

The raw claims observe EVM status, return data, the complete token storage
map, and event logs before an enclosing call rolls back an exceptional halt.
Whole-call claims additionally observe the caller-stack success flag and
commit-or-rollback behavior.
Successful calls return ABI `true`, append the exact anonymous `LogNote` and
ERC-20 `Transfer` records, debit/credit distinct balance locations, and leave a
coincident location's effective balance unchanged. Its exact final map
writes back the initial effective balance at that location; this can add an
explicit zero entry when it was absent. At the raw boundary, insufficient
balance
preserves storage but retains LogNote; overflow retains LogNote and the
source debit. Stopped and nonpayable failures preserve storage and logs.
Every unsuccessful whole-call claim returns a zero call result and restores
both the entire pre-call storage map and pre-call log list.
The whole-call theorem also records the fixed semantics' call bookkeeping:
both addresses
remain in `touchedAccounts` on all paths, while successful calls retain them in
`accessedAccounts` and failed calls restore the pre-call accessed set.  Gas and
the final machine-local stack/memory of the callee are outside the stated
postcondition.

## Intended property

For zero call value and an unstopped token, transfer succeeds exactly when the
source balance covers `WAD` and (for distinct balance slots) crediting the
destination does not overflow.  It returns `true`, subtracts `WAD` from the
source, adds `WAD` to the destination, and otherwise preserves storage.  A
nonzero call value reverts.  A stopped token, insufficient source balance, or
destination overflow raises the compiler's invalid-instruction assertion path;
the enclosing call reports failure and rolls back all storage effects.

## Chosen contract readings

- “Transfer function” means the public override
  `DSToken.transfer(address,uint256)`, selector `0xa9059cbb`, rather than
  `transferFrom`, `push`, or the base function in isolation.
- The execution schedule is Byzantium because this runtime uses opcode `0xfd`
  for the generated nonpayable rejection; gas accounting is disabled so the
  theorem is about functional behavior rather than a gas-limit threshold.
- Calls use canonical ABI encoding and zero-width caller return-memory copying.
  Malformed calldata and ABI trailing bytes are outside the input domain.
- The supplied bytecode, not recompilation of `program/contract.sol`, is the
  executable theorem target.  The source is used to identify the intended
  entry point and storage behavior.
- The successful historical `LogNote` payload encodes
  `(msg.value,msg.data)`, with `msg.value = 0` and the 68-byte canonical
  transfer calldata.  Failure paths observe call-boundary rollback of logs.

## Event and stopped-flag details

The stopped byte is the last byte of the 32-byte encoding of slot 4 divided
by 2^160. Byte equality to zero expresses the same condition as reduction
modulo 256 for the constrained uint256 slot. This matches the pinned EVM
BYTE/AND simplification form without adding any proof axiom.

The stoppable modifier runs before note: stopped rejection emits no LogNote.
Other zero-value paths that pass stoppable emit the historical runtime’s
164-byte LogNote payload (96-byte header plus 68-byte calldata,
no tail padding).
At the outer call boundary all failing paths roll logs back.

## Storage representation

The pinned semantics implements SSTORE as a map update and missing-key
SLOAD as zero. A successful same-slot transfer therefore ends in
`STORAGE [sourceSlot <- SRCBAL - WAD] [destinationSlot <- SRCBAL]`.
The equal-slot precondition makes the second write restore the balance.
Every effective storage value is
preserved, while an absent zero-valued slot may become an explicit zero
entry. The reference self-transfer prestate contains the balance entry
explicitly, so this update preserves its literal map as well. No storage
existence restriction is added to the candidate.
