# Specification audit 1

## Artifacts and inputs examined

- `/app/output/spec.k`
- `/app/output/verification.k`, specifically `VERIFICATION-SUMMARIES`
- `/app/output/bytecode.k`
- `/app/output/SCOPE.md`
- `/app/contract.sol`
- `/app/contract.bin`
- pinned semantics `evm` at commit `4f4c3843076c`
- construction session `504ef65f-e09d-448d-ad55-5e374d7ecf1c`

This audit treated the on-disk candidate as untrusted and compared it with the
source contract and the supplied runtime image.

## Commands and results

| Command/check | Exit | Result |
|---|---:|---|
| `sha256sum` over the two inputs and four drafted artifacts | 0 | Input hashes: source `f4bcfc92...cf0e`, bytecode `65b31113...1a82`; artifact hashes recorded in the command output. |
| Node byte-for-byte comparison of the `#parseByteStack` payload with `/app/contract.bin` | 0 | Both are 6,955 bytes and `identical: true`. |
| Bounded Node disassembly and stack trace of runtime offsets `0x168`, `0x79e`, and `0x14a4` | 0 | Confirmed the approve selector path, stopped test, anonymous `LOG4`, nested-map `SSTORE`, `Approval` `LOG3`, and ABI-true return. |
| Decimal-to-hex conversion for the two log topic constants | 0 | Recovered `095ea7b3` left-aligned to 32 bytes and `8c5be1e5...c3b925`. |
| `kprover validate --session 504ef65f-e09d-448d-ad55-5e374d7ecf1c --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/bytecode.k` | 0 | Validation 005, task `fc3de887-8c2f-4252-bb39-fd6aed368b5b`, reports `valid: true`. |

Earlier validation 001 found an unquoted K terminal, and validation 002 found
the reserved token `CALLER` used as a variable. Both parser defects were fixed.
Validation 004 applied to the prior event-data definition; inspection then
found that this compiler logs 164 bytes rather than a 32-byte-padded 192-byte
tail. The candidate was corrected and validation 005 is the evidence for the
artifacts audited here.

## Formal meaning and source comparison

The three claims partition canonical typed calls as follows:

1. Zero value and stopped byte zero: execution succeeds, returns one as a
   32-byte ABI word, changes only the nested allowance location for
   `(CALLER_ID, GUY)` to `WAD`, and appends `LogNote` followed by `Approval`.
2. Zero value and stopped byte nonzero: execution reaches the Solidity 0.4
   assertion's `INVALID`, leaves storage and logs unchanged, and returns no
   bytes.
3. Nonzero value: the generated nonpayable guard executes `REVERT` before the
   modifier and leaves storage and logs unchanged.

This matches `DSToken.approve`, whose modifier order checks `stoppable`, then
emits `note`, then calls `DSTokenBase.approve`. The runtime independently shows
that `_approvals` uses base slot 2 and that `stopped` is byte 20 of slot 4. The
map helper expands to Solidity's `keccak(GUY . keccak(CALLER_ID . slot(2)))`
layout in the pinned semantics.

The preconditions cover every 160-bit account/spender address, every 256-bit
amount, every nonzero 256-bit call value for the nonpayable case, and symbolic
storage subject only to well-formedness of the word actually read. No relation
between the addresses is imposed. The canonical ABI restriction, non-static
context, Cancun schedule, and gas-disabled functional model are all explicit in
`SCOPE.md`; none silently narrows the typed source function's argument domain.

## Summary faithfulness

- `approveCallData` uses the pinned ABI helper with the source argument types
  and order. Boundary values zero and maximum uint/address remain covered by
  the claim guards.
- `approveSlot` follows the two `MSTORE`/`SHA3` pairs at `0x14a8..0x1523`.
- `stoppedByte` matches `SLOAD(4) / 2^160 & 255`. Hand checks give zero for
  slot word zero, one for `2^160`, and 255 for `255 * 2^160`; low 160 owner bits
  do not influence it.
- `approveNoteData` is `value=0`, dynamic offset 64, byte length 68, and the
  exact 68-byte calldata. Its total length is 164, matching the LOG4 width
  constructed by this runtime (`96 + CALLDATASIZE`) rather than assuming ABI
  tail padding the implementation does not log.
- `approveNoteLog` topics are the left-aligned selector, caller, calldata word
  at offset 4, and calldata word at offset 36. `approvalLog` uses the exact
  event signature, caller, and spender topics and the 32-byte amount data.

All summary equations are terminating, non-overlapping single equations. Their
claim guards cover every call on which ABI encoding or fixed-width buffers are
used.

## Gate B findings

- B1 input-domain alignment: PASS. The three claims cover the full symbolic
  typed inputs and both implemented failure partitions in the recorded call
  model.
- B2 language-model adequacy: PASS. The exact supplied runtime executes under
  the pinned EVM model. The explicitly excluded static and finite-gas contexts
  are environment variants, not hidden argument restrictions.
- B3 summary-to-property adequacy: PASS. Every summary is a transparent
  encoding, storage-location, packed-byte, or event constructor checked against
  the runtime.
- B4 implementation-to-intent alignment: PASS. The source-level behavior and
  supplied runtime agree for all observed outcomes. No discrepancy was found.

No adequacy or summary-faithfulness finding remains.

VERDICT: PASS
REASON: The three mechanically valid claims faithfully cover symbolic typed approve calls, including both implemented unsuccessful outcomes, with exact storage, output, status, and log behavior.
