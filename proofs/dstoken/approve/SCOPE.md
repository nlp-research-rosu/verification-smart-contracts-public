# Verification scope

## Program boundary

The claims begin at byte offset 0 of the exact 6,955-byte runtime image in
`/app/contract.bin`, with an empty EVM stack and memory, program counter zero,
and canonical ABI calldata for `approve(address,uint256)`. They execute the
runtime dispatcher, the DSToken `stoppable` and `note` modifiers, and the
inherited DSTokenBase `approve` implementation through an EVM halt.

Three entry claims partition canonical non-static calls: zero call value with
the packed `stopped` byte clear, zero call value with that byte nonzero, and
nonzero call value. The function contains no loop, so no loop-circularity claim
is required.

## Input domain

`ACCT`, `CALLER`, and `GUY` range over all 160-bit addresses; `WAD` and
nonzero `CALLVALUE` range over all 256-bit unsigned values. `STORAGE` is
symbolic; only its read storage word at slot 4 is required to be a valid
256-bit word. Existing logs are an arbitrary symbolic list and are preserved
as a prefix.

Calldata is the canonical 68-byte Solidity ABI encoding of the typed source
function. Malformed, short, selector-mismatched, or trailing calldata is outside
the source-level function-call domain. Static calls and finite-gas/out-of-gas
executions are excluded: the claims use `NORMAL` mode, `static = false`,
`useGas = false`, and infinite symbolic-execution gas.

## Observable final state

The observed cells are status code, return bytes, the complete contract storage
map, and the complete log list. Successful execution must return ABI `true`,
write exactly `WAD` to
`keccak256(GUY . keccak256(CALLER . uint256(2)))`, append the anonymous
`LogNote` and then the ERC-20 `Approval` log, and otherwise preserve storage.
The stopped failure must halt with `EVMC_INVALID_INSTRUCTION` and no new log.
The nonpayable failure must halt with `EVMC_REVERT` and no new log.

Final program counter, stack, memory, memory high-water mark, and remaining
infinite-gas metadata are deliberately existential: they are compiler
bookkeeping and are not part of the requested function behavior. All other
unmentioned configuration cells are framed unchanged by the reachability
claims.

## Intended property

For every well-typed symbolic owner/caller, spender, amount, and symbolic
storage map, an enabled zero-value `approve` call overwrites that caller's
allowance for the spender with the amount, emits the two implemented events,
and returns true. If the token is stopped, the Solidity 0.4 `assert` fails
through `INVALID` before logging or writing. Any nonzero-value call is rejected
by the generated nonpayable guard before the stopped check, logging, or write.

## Chosen contract readings

- The verified artifact is the supplied runtime bytecode, not a recompile of
  `contract.sol`; the source fixes the intended function and explains the
  storage/event meaning.
- Solidity's storage layout is read from the bytecode: `_approvals` has base
  slot 2, while `stopped` is packed into byte offset 20 of slot 4 alongside
  `owner`.
- “Unsuccessful calls” includes both implemented source-visible failure modes:
  the `stoppable` assertion and the generated nonpayable guard. Malformed ABI,
  static-context, and out-of-gas failures are execution-environment behavior,
  not typed executions of the function, and are explicitly excluded.
- Cancun is selected as a concrete modern schedule under which every opcode in
  this older runtime is defined. Gas is disabled to state functional partial
  correctness independently of a gas limit.
- Direct runtime entry is used rather than a surrounding transaction/call-stack
  wrapper. This preserves the function's status, output, storage, and log
  behavior while excluding balance transfers, transaction fees, and caller
  rollback machinery not exercised by a zero-value state-changing call.
