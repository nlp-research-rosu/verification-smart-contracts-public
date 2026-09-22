# Specification audit 2

This audit supersedes `spec-audit-1.md`; the claim representation changed after
that earlier audit. The review below uses the final on-disk claims and does not
rely on the earlier verdict.

## Artifacts examined

- `/app/output/spec.k` (SHA-256
  `f07fcfde1b6fe74b98a235ce6258c8495b0c8046ff647bc93f30d9041b989188`)
- `/app/output/verification.k` (SHA-256
  `b920c53e6e08f8690b50e4b14bbe61258ddb98ef5c7a948d67d6f759a83bbfd9`)
- `/app/output/SCOPE.md`
- `/app/contract.sol` (SHA-256
  `cee59f7cb8d3245e61fab5bb037753500cf71e19be40184acb1a8306dc05106b`)
- `/app/contract.bin` (2,091 bytes; SHA-256
  `71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`)
- pinned bundled semantics `evm`, revision `4f4c3843076c`

The final output copies were byte-for-byte identical to the construction
session inputs used by validation 020.

## Formal contract restatement

`balanceOf-success` begins the exact runtime at PC 0 with empty stack and
memory, zero call value, a symbolic 36-byte calldata buffer whose dispatcher
selector is `0x70a08231`, and an `OWNER` equal to the runtime's masked
`CALLDATALOAD(4)`. Owner, current contract, and caller are arbitrary 160-bit
addresses. The current account has arbitrary symbolic storage with a
well-formed uint256 at the selected balance location. If execution terminates,
it must halt with `EVMC_SUCCESS`, unchanged storage, and the exact 32-byte
return buffer constructed by the runtime from the slot-1 mapping lookup.

`balanceOf-nonzero-value-reverts` has the same selector and decoded-owner
domain, arbitrary symbolic storage, and every uint256 `VALUE` for which
`bool2Word(VALUE ==Int 0) ==Int 0`. If execution terminates, it must halt with
`EVMC_REVERT`, empty output, and unchanged storage.

## Gate B adequacy

The source implementation at `/app/contract.sol` lines 161--163 returns
`balances[owner]`. Inherited declaration order places `totalSupply` at slot 0
and `balances` at slot 1. The supplied runtime dispatch witness at offsets
`0x145`--`0x17b` selects `0x70a08231`, rejects nonzero `CALLVALUE` with
`REVERT(0,0)`, and decodes the owner with a 160-bit mask. The body at
`0x5c6`--`0x60e` writes the decoded owner and slot 1 to memory, hashes the
64-byte pair, performs `SLOAD`, writes that word at free-memory offset `0x60`,
and returns 32 bytes.

The successful output term mirrors those operations directly. Its initial
96-byte memory constant ends in `0x60`; updates at offsets 0 and 32 contain the
masked owner and slot 1; its `keccak(#range(..., 0, 64))` indexes the original
`STORAGE`; the lookup is padded to 32 bytes at the free-memory pointer; and the
outer `#range` is the runtime's exact return slice. This is the bundled KEVM
normal form of the ABI word for `balances[OWNER]`, not a free result variable.

The owner, address, and storage domains are symbolic rather than enumerated.
Every canonical ABI encoding is included. The theorem additionally includes
36-byte calls with nonzero high padding in the address word because this old
runtime masks those bits; that broadening agrees with implemented behavior.
The Boolean form used for nonzero call value is equivalent for all integers,
and the adjacent uint256 range constraint gives exactly all nonzero EVM words.
The chosen direct-entry context, BYZANTIUM schedule, disabled gas accounting,
failure reading, and partial-correctness boundary are disclosed in `SCOPE.md`.

## Summary faithfulness

`VERIFICATION-SUMMARIES` declares no candidate symbol or equation, and
`VERIFICATION` contains no proof rule or auxiliary claim. The long return term
is part of the claim postcondition itself. There is therefore no candidate
summary with guard, overlap, termination, or differential-test obligations.

## Mechanical checks

Validation command:

```sh
kprover validate \
  --session 532621c2-2524-4276-84ba-ff40d78ab73e \
  --semantics evm \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --source inputs/verification.k
```

Exit status: 0. Evidence:
`/app/.kprover/sessions/532621c2-2524-4276-84ba-ff40d78ab73e/validation-020/result.json`.
The task reports `status: completed`, `valid: true`, definition
`7_1_337-haskell-evm-4f4c3843076c-none`, and a final K tool exit code of 0.

The runtime literal embedded in each claim is the lowercase contents of
`contract.bin`, and its computed jump destinations are derived from that same
literal. `CALLER_ID` and the remaining uppercase identifiers parse as K
variables; no contract identifier or opcode-token collision is present.

## Findings

None.

VERDICT: PASS
REASON: The final claims cover the symbolic `balanceOf` success and nonpayable failure domains and faithfully constrain status, returned slot-1 balance, and unchanged storage for the exact supplied runtime.
