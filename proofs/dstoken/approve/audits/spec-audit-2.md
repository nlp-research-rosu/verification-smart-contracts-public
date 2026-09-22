# Specification audit 2

## Reason for repeat

Proof 001 showed that the audited mathematical modulo form of the packed
`stopped` byte did not simplify to the exact byte-range expression used by the
pinned semantics. The spec stage replaced only that definition and its two uses
with `stoppedClear`; all other claims and summaries remain as audited in
`spec-audit-1.md`. Because a definitional summary changed, this report repeats
the affected adequacy and mechanical checks before proving resumes.

## Artifacts examined

- `/app/output/spec.k` (`cec842a3...8a56`)
- `/app/output/verification.k` (`57d5ca8d...89b6`)
- `/app/output/bytecode.k` (`4ebbab4e...2821`)
- `/app/output/SCOPE.md` (`d1f5b2f1...1c4d`)
- `/app/contract.sol` and `/app/contract.bin`
- proof-001 evidence identifying the opposite stopped branches

## Commands and results

| Command/check | Exit | Result |
|---|---:|---|
| `sha256sum` over the four current candidate artifacts | 0 | Hashes shown above; bytecode and scope are unchanged from audit 1. |
| Node boundary evaluation for packed slot words `0`, `1`, `2^160`, `255*2^160`, and lower-owner-bits plus `7*2^160` | 0 | Extracted bytes were `0, 0, 1, 255, 7`; zero tests were correct. |
| `kprover validate --session 504ef65f-e09d-448d-ad55-5e374d7ecf1c --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/bytecode.k` | 0 | Validation 006, task `7263056c-0884-4ffc-bd7f-4c5388ba44f7`, reports `valid: true`. |

## Affected summary review

`stoppedClear(STORAGE)` compares byte 31 of the 32-byte encoding of
`lookup(STORAGE,4) / 2^160` with zero. This is the exact term reached by the
runtime's `SLOAD`, `DIV`, and `AND 0xff` sequence. It is true precisely when
bits 160 through 167 of slot 4 are zero; lower owner bits and higher unrelated
bits do not alter that byte. The single unguarded equation is total,
terminating, and has no overlap.

The success and stopped claims now use complementary Boolean preconditions,
`stoppedClear(STORAGE)` and `notBool stoppedClear(STORAGE)`. Together they cover
every well-formed 256-bit slot-4 word, so the repair neither narrows the domain
nor changes the intended postconditions. The nonpayable claim remains
independent of stopped state, matching the runtime guard order.

## Gate B

- B1 input-domain alignment: PASS; the branch partition is exhaustive and all
  typed symbolic inputs and storage remain covered.
- B2 language-model adequacy: PASS; the definition now mirrors the fixed EVM
  term instead of asking the solver to establish an equivalent arithmetic
  normal form.
- B3 summary-to-property adequacy: PASS; boundary checks and the runtime
  instruction sequence agree.
- B4 implementation-to-intent alignment: PASS; no source/runtime discrepancy
  is introduced or concealed.

The remaining summary, event, bytecode-identity, and postcondition findings of
specification audit 1 remain applicable and passing.

VERDICT: PASS
REASON: The exact packed-byte predicate is mechanically valid, exhaustive, and faithful to the runtime stopped check without narrowing or changing the approved behavior.
