# HKG `transferFrom` verification scope

## Program boundary

The claims enter the EVM runtime at `#execute`, program counter zero, with the
exact 2,091-byte contents of `/app/contract.bin` supplied by
`#binRuntime(HKG)`.  Canonical ABI calldata selects
`transferFrom(address,address,uint256)`.  The theorem includes selector
dispatch, ABI decoding, every opcode in the selected function body, all SLOAD
and SSTORE operations, ABI return encoding, and the `Transfer` LOG3 operation.
It stops at the resulting `#halt`; transaction-envelope validation, fee
payment, and block finalization are outside the program boundary.

## Input domain

`ACCT`, `CALLER_ID`, `FROM`, and `TO` range over every 160-bit address.  `VALUE`
ranges over every 256-bit unsigned integer.  `STORAGE` is an otherwise
arbitrary symbolic EVM storage map for the HKG account; unmentioned accounts
and account fields are framed.  The four claims partition the complete
canonical-call domain into: success; failure because `VALUE == 0`; failure
because a positive value exceeds the source balance; and failure because the
balance suffices but the allowance does not.  No distinctness is assumed among
addresses or computed storage keys.

The call is a non-static, zero-Ether, top-level invocation.  The initial
operand stack, memory, memory-use counter, output, status, and substate log are
empty/default as shown in the claims.  The contract account exists.  Execution
uses the `CANCUN` schedule with gas accounting disabled (`<useGas> false`), so
out-of-gas behavior and exact gas consumption are excluded.

## Observable final state

The theorem observes the EVM status, returned bytes, the complete HKG storage
map, and the complete substate log.  On success it requires `EVMC_SUCCESS`, ABI
boolean `true`, exactly the three sequential storage updates implemented by
the bytecode, and exactly one `Transfer(from,to,value)` event.  On failure it
requires `EVMC_SUCCESS`, ABI boolean `false`, unchanged complete storage, and
no log.  Final stack, memory, program counter, and memory-use counter are
existential because they are internal compiler artifacts after `#halt`.
Gas/refund bookkeeping, access-list bookkeeping, touched accounts, and other
unmentioned machine or block cells are unobserved and framed because the
requested property is the function-level token behavior, not transaction
accounting.

## Intended property

For every canonical symbolic call, the function returns true exactly when the
source balance and caller allowance are both at least the strictly positive
requested value.  A successful call subtracts from `balances[from]`, then adds
to `balances[to]`, then subtracts from `allowed[from][msg.sender]`, with EVM
word arithmetic and a `Transfer` event.  Every other call returns false without
changing storage or emitting a log.

## Chosen contract readings

- “Implemented behavior” means the supplied runtime bytecode is authoritative;
  `/app/contract.sol` supplies names, types, storage layout, and intent.
- Successful and unsuccessful calls mean Solidity-level boolean success and
  failure.  This implementation returns normally in both cases; neither branch
  reverts.
- The post-state summary applies writes sequentially.  This intentionally
  captures `FROM == TO` and even equality among concrete hashed slots without
  adding collision or address-distinctness assumptions.
- Canonical ABI calldata is in scope.  Short, overlong, malformed, or
  noncanonical calldata and nonzero `msg.value` are excluded because the task
  asks for calls to this typed function rather than fallback behavior.
- `CANCUN` with disabled gas is chosen because the function uses only
  fork-stable opcodes and the request did not nominate a transaction fork or
  gas budget.  This proves state/output/log behavior, not gas-sensitive
  behavior.
