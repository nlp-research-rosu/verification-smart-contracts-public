# Two-write storage specification review

The same-slot success postconditions preserve the exact execution shape:

```text
STORAGE [sourceSlot <- SRCBAL - WAD] [destinationSlot <- SRCBAL]
```

The unchanged precondition states that the two locations are equal.
Consequently the second write overwrites the first and restores the
original effective balance. Every other map entry is unchanged. This is
mathematically equivalent to the one-write postcondition reviewed in
`spec-audit-3.md`, including its handling of absent zero-valued entries.
It is identical to the reference's unchanged storage on the reference's
explicit-entry uint256 domain.

The retained focused proof residual reached this two-write storage shape
with the required return, status and logs. Its matching failure motivates
the representation change; it does not justify a new proof axiom. No
requires clause, claim label, imported module, or local rule was changed.

Validation command:

```sh
kprover validate --session 9de91c94-5dde-4768-8d0d-ed007c7d6069 \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/dstoken-bin.k
```

Executed with the case's isolated XDG configuration. Validation task
`2ddb6d81-b635-4d06-aee1-60a9a37d7478` returned `valid: true`, exit 0.
Evidence: `validation-004/result.json` in the construction session.

VERDICT: PASS
REASON: The exact two-write map preserves the effective-storage guarantee.
