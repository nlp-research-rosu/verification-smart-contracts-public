# KIT specification audit 8

## Artifacts and evidence examined

- `/app/contract.sol`, `/app/contract.bin`
- revised `/app/output/spec.k`, `/app/output/verification.k`, `/app/output/SCOPE.md`
- focused success residual `/app/.kprover/sessions/0965306b-374d-4868-a291-37d3096894d4/proof-006/result.json`
- pinned `evm` semantics commit `4f4c3843076c`

## Mechanical checks

- Validation 11: infrastructure failure after task acceptance; task `bfeb6223-79aa-4e39-842a-1c6f15dc01d7` remained queued while the Prover health endpoint returned HTTP 502. Evidence: `/app/.kprover/sessions/0965306b-374d-4868-a291-37d3096894d4/validation-011/result.json`.
- Unchanged retry after `kprover health` returned `status: ok`:
  `kprover validate --session 0965306b-374d-4868-a291-37d3096894d4 --spec inputs/spec.k --spec-module TRANSFER-FROM-SPEC --verification inputs/verification.k --verification-module VERIFICATION`
  - Validation 12: exit 0; task `81a252db-3c3c-49ae-b80b-3b9e7c5a4057`; `valid: true`.
  - Evidence: `/app/.kprover/sessions/0965306b-374d-4868-a291-37d3096894d4/validation-012/result.json`.
- `python3 /app/output/audits/check-spec-summaries.py`: exit 0, including assertions that all seven claims start with an empty log substate.

## Boundary review

The claims now start the EVM log substate at `.List`. This is the ordinary fresh external-call/transaction theorem boundary and is stated explicitly in `SCOPE.md`. It eliminates a purely associative residual between `(LOGS ListItem(note)) ListItem(transfer)` and `LOGS (ListItem(note) ListItem(transfer))` seen in proof 6 without adding a semantic rule, simplifier, or proof extension.

The change does not constrain any requested symbolic argument or storage value. Addresses, amount, caller, token address, and the complete token storage map remain symbolic under the existing range and mapping-location assumptions. Successful claims still require the exact two emitted logs; every exceptional claim still requires rollback to the initial empty log substate. No branch guard, result, storage postcondition, runtime pin, or call rollback condition changed.

## Adequacy review

An arbitrary pre-existing log prefix is not part of a fresh-call contract and is unnecessary for the requested `transferFrom` behavior. Starting the substate empty accurately models the chosen public-call boundary, keeps all implemented success and failure paths, and makes the observable event sequence exact. The seven claims still form the audited partition for canonical calldata and all symbolic inputs/storage in scope.

VERDICT: PASS
REASON: The explicit fresh-call log boundary is faithful to EVM call entry, preserves the complete requested symbolic domain and branch partition, and introduces no trusted proof rule.
