# KIT specification audit 5

## Artifacts examined

- `/app/contract.sol`, `/app/contract.bin`
- revised `/app/output/spec.k`, `/app/output/verification.k`, `/app/output/SCOPE.md`
- proof-003 evidence identifying the stopped-flag encoding split
- pinned `evm` semantics commit `4f4c3843076c`

## Mechanical checks

1. `kprover validate --session 0965306b-374d-4868-a291-37d3096894d4 --spec inputs/spec.k --spec-module TRANSFER-FROM-SPEC --verification inputs/verification.k --verification-module VERIFICATION`
   - Exit 0; validation 8; task `8c33a16c-d97c-4b61-abb3-53cff52f0586`; `valid: true`.
   - Evidence `/app/.kprover/sessions/0965306b-374d-4868-a291-37d3096894d4/validation-008/result.json`.
2. `python3 /app/output/audits/check-spec-summaries.py`
   - Exit 0; exact runtime/selector/note checks passed, and 10,000 deterministic uint256 stopped-byte equivalence samples passed.

## Changed definition

The old helper computed the stopped byte as integer `(slot4 / 2^160) mod 256`. The revised `#stoppedByteIsZero(STORAGE)` compares the exact final one-byte slice of `#buf(32, slot4 / 2^160)` to `#buf(1, 0)`, which is the expression reached by the fixed bytecode's `SLOAD`, division, `0xff` masking, and zero test under the pinned simplifier.

For every uint256 storage word, the final byte of the quotient is zero exactly when bits 160 through 167 of slot 4 are zero. Thus the revised predicate has the same source-level meaning as `!stopped`; it changes representation, not domain or behavior. Its single unconditional equation terminates, has no overlap, and covers every claim use under the existing uint256 slot-4 guard. It is definitional and does not replace execution.

## Adequacy review

All other claims, call-configuration cells, input/storage partition, status/output/storage/log postconditions, successful self/distinct behavior, rollback behavior, and explicit scope boundaries are unchanged from passing audit 4. Proof 3 independently closed non-payable, balance, allowance, and overflow branches under the prior equivalent definition; the repair targets only the backend's inability to connect integer and byte encodings on stopped/success branch pruning.

No new trusted claim, proof lemma, operational bridge, or restriction was introduced.

VERDICT: PASS
REASON: The exact byte-slice stopped predicate is extensionally faithful on the full uint256 slot domain and removes only an unproved representation conversion.
