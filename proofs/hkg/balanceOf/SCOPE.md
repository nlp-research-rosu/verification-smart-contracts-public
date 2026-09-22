# Verification scope

## Program boundary

The target is the exact 2,091-byte runtime image in `/app/contract.bin`
(SHA-256 `71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`),
entered at program counter 0 with an empty word stack and memory. The theorem
executes the runtime bytecode under pinned KIT semantics `evm` revision
`4f4c3843076c` through `#execute` until `#halt`; it does not replace the
dispatcher or function body with a candidate operational rule.

The covered program-defined operations are dispatch of the
`balanceOf(address)` selector, ABI decoding and address masking, the generated
nonpayable call-value guard, Solidity mapping-location computation, `SLOAD`,
ABI return encoding, and `RETURN` or `REVERT`.

## Input domain

The successful claim uses a symbolic 36-byte `CALLDATA`. Its preconditions fix
the selector expression read by the dispatcher to `0x70a08231` and bind
`OWNER` to the compiler's 160-bit-masked `CALLDATALOAD(4)`. Consequently it
covers every canonical ABI call `balanceOf(owner)` for every 160-bit owner. It
also faithfully covers the old compiler's implemented decoding behavior when
the high 96 padding bits of the address word are nonzero, because those bits
are masked by the runtime. The current contract address and caller range over
all 160-bit values. Storage is a symbolic current-account map whose selected
balance word is a well-formed 256-bit EVM word; missing entries are included
because bundled KEVM `#lookup` supplies the EVM default zero. Call value is
zero.

The unsuccessful claim covers the same selector/decoded-owner calldata domain
and addresses, an arbitrary symbolic current-account storage map, and every
nonzero 256-bit call value. Nonzero is written equivalently as
`bool2Word(VALUE ==Int 0) ==Int 0`, matching the compiler's branch expression.
It captures the compiled nonpayable guard. Other calldata lengths, unknown
selectors, transaction-envelope validity, call-stack entry, and out-of-gas
behavior are outside the requested function-call domain.

The initial execution context is `NORMAL` mode, `BYZANTIUM` schedule,
non-static direct runtime entry, depth zero, empty call stack, program counter
zero, empty local memory and word stack, and gas accounting disabled
(`useGas = false`). Gas disabling excludes out-of-gas paths but does not alter
the bytecode control path used by either claim.

## Observable final state

For success, the observed result is `EVMC_SUCCESS` with the runtime's exact
return-buffer term. The term records the compiler's memory operations without
candidate simplification: memory word 0 is the masked decoded owner, word 1 is
the mapping base slot `1`, `keccak(memory[0..64])` selects the original
storage-map word, that word is written at the free-memory pointer `0x60`, and
the resulting 32-byte slice is returned. Thus it is precisely the ABI word for
`balances[owner]`, represented in the normal form produced by the bundled
semantics. For unsuccessful nonzero-value calls, the observed result is
`EVMC_REVERT` with empty output. In both claims the current account's storage
map is framed unchanged; thus `balanceOf` is read-only, including on failure.

The final internal program counter, stack, local memory, and memory-use counter
are existentially framed because they are not externally observable here.
All other world-state, substate, block, and transaction-context cells are
unobserved and framed by the configuration; the function reads none of them on
these paths.

## Intended property

If a zero-value call in the stated selector/decoder domain terminates, it
succeeds and returns the stored token balance of `owner` without changing
storage. If the same call carries a nonzero value, it terminates by reverting
with empty output and without changing storage.

## Chosen contract readings

- The task's “HKG contract” names the supplied compiled artifact; the complete
  source declares the implementation as `StandardToken`. The theorem embeds
  that artifact's exact runtime bytes rather than assigning a new contract
  identifier.
- Solidity inheritance layout places `totalSupply` at slot 0 and the
  `balances` mapping at slot 1. The target mapping word is therefore the
  Solidity hash location with base slot 1.
- “Unsuccessful calls” is read as calls that select the implemented
  `balanceOf(address)` entry but fail its generated nonpayable guard. Unknown
  selectors and calldata outside the stated 36-byte decoder domain do not call
  this verified function domain.
- `BYZANTIUM` is the minimum fork schedule that decodes the runtime's
  compiler-emitted `REVERT` opcode. Gas is disabled so fork-dependent gas
  pricing is not part of the theorem.
- The theorem is partial correctness: it constrains every terminating path in
  the stated domain and does not itself assert termination.
