# Same-slot storage specification review

The two same-slot success postconditions now describe the exact final
storage map: `STORAGE [balanceSlot <- SRCBAL]`. Their preconditions, return
value, status and events are unchanged. No claim was removed and no proof
rule was added.

The pinned `evm.md` SSTORE rule updates the map even for zero. The pinned
`evm-types.md` missing-key lookup rule returns zero. A concrete witness to
the former map-identity defect is an empty storage map, equal source and
destination addresses, and zero transfer amount: execution inserts an
explicit zero balance entry. The replacement preserves every effective
storage value and states this representation change exactly.

The reference self-transfer prestate explicitly contains a uint256 source
balance entry. On that domain the new map update is identical to the
reference's unchanged map. Distinct-slot requirements and all rejection
cases remain unchanged.

Validation command:

```sh
kprover validate --session 9de91c94-5dde-4768-8d0d-ed007c7d6069 \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/dstoken-bin.k
```

Executed with the case's isolated XDG configuration. Validation task
`5bc4bd3f-2e10-492b-be75-3dab3a4323d6` returned `valid: true`, exit 0.
Evidence: `validation-003/result.json` in the construction session.
This review does not replace the independent final proof audit.

VERDICT: PASS
REASON: Exact map updates preserve effective storage and the reference domain.
