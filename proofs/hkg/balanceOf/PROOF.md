STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `HKG:balanceOf`

## What is proven

The exact 2,091-byte supplied runtime succeeds with the selected stored balance
and preserves storage for every zero-value call in the candidate's symbolic
36-byte balanceOf decoder domain. For every nonzero uint256 call value in that
domain, it reverts with empty output and preserves storage. These are partial
correctness claims under pinned `evm` revision `4f4c3843076c`.

## Formal claim (from `spec.k`)

The initial program counter is 0, with empty stack/memory, NORMAL mode,
BYZANTIUM schedule, disabled gas, depth 0, and empty call stack. Owner,
contract, and caller are arbitrary 160-bit addresses. Calldata has the
balanceOf selector and a decoded, masked owner. Successful storage is symbolic
with a well-formed selected uint256 word. The postcondition is `#halt`,
EVMC_SUCCESS, the exact ABI word of the slot-1 mapping lookup, and unchanged
storage. The failure claim instead constrains EVMC_REVERT and empty output.

The separate [RV comparison](audits/reference-comparison.md) establishes the
same observable balanceOf property over RV's canonical ABI domain. A fresh
universal audit probe additionally closes for Istanbul, positive-infinite gas,
arbitrary reference-range depth, arbitrary call stack, and arbitrary initial
output/status. The candidate's formal configurations remain unchanged.

## Proof-extension inventory

There are no candidate functions, axioms, lemmas, operational bridges, or
trusted claims. Both claims execute the actual bytecode through the fixed
semantics. Only internal final PC, stack, memory, and memory-use cells are
existential; returned bytes, status, and storage are constrained.

## Exact commands and actual outputs

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/spec.k --spec-module SPEC --source inputs/verification.k
```

Exit status: 0.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/spec.k --spec-module SPEC --source inputs/verification.k
```

Exit status: 0.

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/witness.k --spec-module WITNESS --source inputs/verification.k
```

Exit status: 0.

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/false-result.k --spec-module FALSE-RESULT --source inputs/verification.k
```

Exit status: 0.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/witness.k --spec-module WITNESS --source inputs/verification.k
```

Exit status: 0.

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/false-status.k --spec-module FALSE-STATUS --source inputs/verification.k
```

Exit status: 0.

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/body-mutant.k --spec-module BODY-MUTANT --source inputs/verification.k
```

Exit status: 0.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/false-result.k --spec-module FALSE-RESULT --source inputs/verification.k
```

Exit status: 1.

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/reference-context.k --spec-module REFERENCE-CONTEXT --source inputs/verification.k
```

Exit status: 0.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/false-status.k --spec-module FALSE-STATUS --source inputs/verification.k
```

Exit status: 1.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/body-mutant.k --spec-module BODY-MUTANT --source inputs/verification.k
```

Exit status: 1.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/reference-context.k --spec-module REFERENCE-CONTEXT --source inputs/verification.k
```

Exit status: 0.

All task IDs, actual stdout/stderr, exact source hashes, and per-command exit
statuses are in [the audit](audits/proof-audit-1.md) and the retained evidence
under `logs/evidence/audit/`. The unchanged replay task is
`08feb7a6-31c4-494d-b322-d5fa6e6ca46d`:

```text
PROOF PASSED: SPEC.balanceOf-success
PROOF PASSED: SPEC.balanceOf-nonzero-value-reverts
```

Typed result: `proved`; K tool exit: 0; structured residual: null. The backend
exposes KEVM closure lines rather than raw successful KAST; none is fabricated.

## Per-gate results

Gate A PASS: unchanged replay, realizable input witnesses, and rejected wrong
return, wrong status, and executed-body mutations. Gate B PASS: faithful
balance semantics and independently checked RV observable coverage. Gate C
PASS: complete retained evidence and explicit trust boundary.

## Trust boundary

The claim is conditional on correctness of the pinned EVM/K semantics,
KEVM/K tooling, solver, and primitive implementations. The runtime SHA-256 is
`71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`.
No candidate axiom, bridge, or program-defined helper is trusted.

## Empirically supported facts

Concrete zero/default storage, maximum owner/balance, and nonzero-value
witnesses pass. A false zero-balance return of 1 is rejected at OUTPUT_CELL;
false success on nonpayable input and the RETURN-to-REVERT body change are
rejected at STATUSCODE_CELL. These are finite checks in addition to the
symbolic positive claims. The output-expression reduction to the RV ABI word
is documented from the pinned byte and map definitions.

## Excluded behavior

Finite-gas exhaustion, transaction envelopes, caller continuations after
#halt, other calldata lengths/selectors, and other HKG functions are excluded.
No compiler-correctness or deployed-bytecode theorem is claimed. The original
RV reference was not itself replayed, and no reference proof timing or success
is inferred from these results.
