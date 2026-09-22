STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `DSToken:totalSupply`

## What is proven

For the exact 6,955-byte runtime in `/app/contract.bin`, under bundled `evm`
semantics commit `4f4c3843076c` and the `SHANGHAI` schedule:

- every canonical `totalSupply()` call with value zero, symbolic 160-bit
  executing address, and symbolic EVM storage map halts successfully, returns
  the 32-byte ABI encoding of storage slot 0, and preserves the whole storage
  map; and
- every canonical `totalSupply()` call with an arbitrary nonzero uint256 value
  halts with `EVMC_REVERT`, empty return data, and the whole storage map
  unchanged.

These are functional direct-runtime results with gas accounting disabled.

## Formal claim (from `spec.k`)

`SPEC.totalSupply-success` executes `#binRuntime(DSTOKEN)` from PC 0 with
canonical `#abiCallData("totalSupply", .TypedArgs)`, empty stack and memory, and
call value 0. Its observable postcondition is `EVMC_SUCCESS`, output
`#buf(32, #lookup(STORAGE, 0))`, and the unchanged `STORAGE` map.

`SPEC.totalSupply-nonzero-value-reverts` uses the same entry configuration with
`#rangeUInt(256, CV)` and `CV =/=Int 0`. Its observable postcondition is
`EVMC_REVERT`, unchanged empty output, and unchanged storage.

Both claims were proved independently and unbounded, with no trusted claims.

## Proof-extension inventory

The only candidate extension is the ground definitional bytecode rule
`#binRuntime(DSTOKEN) => #parseByteStack("0x...")`, plus its `DSTOKEN` syntax.
Its payload equals `/app/contract.bin` byte for byte and has SHA-256
`65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`.
It names the program bytes and does not replace execution, control, or state.
Its one ground case has no guard, overlap, recursion, totality, or priority
interaction.

`VERIFICATION-SUMMARIES` adds no mathematical summary. There are no candidate
operational bridges, derived lemmas, trusted primitives, opaque results,
auxiliary claims, or fresh result-bearing abstractions. Bundled `EDSL`,
`EVM-OPTIMIZATIONS`, and `LEMMAS` belong to the pinned immutable semantics and
are listed below as foundational trust.

## Exact commands and actual outputs

Audit session `c9daec22-c065-4961-a57f-e2633a3988cc` independently pinned the
same repository and commit as construction session
`446149a2-f38c-4c76-9ec9-b7953d48233c`.

Positive source validation:

```sh
kprover validate --project /app --session c9daec22-c065-4961-a57f-e2633a3988cc --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k
```

Exit 0; task `5a11bbd3-bbee-4ae7-b10d-68f24ca8a77a`; `valid: true`; final K
tool exit 0.

Success proof:

```sh
kprover prove --project /app --session c9daec22-c065-4961-a57f-e2633a3988cc --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k --claim SPEC.totalSupply-success
```

Exit 0; task `ab5cd61b-0ac6-4dcd-9432-16f8a90e0b79`; `outcome: proved`;
`residual: null`; actual stdout:

```text
PROOF PASSED: SPEC.totalSupply-success
```

Nonzero-value proof:

```sh
kprover prove --project /app --session c9daec22-c065-4961-a57f-e2633a3988cc --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k --claim SPEC.totalSupply-nonzero-value-reverts
```

Exit 0; task `4e623e8b-9f3f-4925-aa9e-38b3bd0086d6`; `outcome: proved`;
`residual: null`; actual stdout:

```text
PROOF PASSED: SPEC.totalSupply-nonzero-value-reverts
```

The client contract defines `outcome: proved` as closure with a `#Top` KAST;
the KEVM adapter renders that raw success as `PROOF PASSED`.

Audit-authored false-postcondition mutation:

```sh
kprover prove --project /app --session c9daec22-c065-4961-a57f-e2633a3988cc --semantics evm --spec inputs/spec-false.k --spec-module SPEC-FALSE --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k --claim SPEC-FALSE.totalSupply-success-false-slot0-plus-one
```

Exit 1; task `7b946812-c2a2-4fc2-8312-a00985f733a8`; `outcome: notProved`.
The actual failure identifies the result constraint:

```text
OUTPUT_CELL: #buf ( 32 , #lookup ( STORAGE:Map , 0 ) #Implies #lookup ( STORAGE:Map , 0 ) +Int 1 )
Path condition:
  #Top
```

Audit-only body-sensitivity mutation, changing runtime byte `0x959` from `00`
to `01` so the body loads slot 1:

```sh
kprover prove --project /app --session c9daec22-c065-4961-a57f-e2633a3988cc --semantics evm --spec inputs/spec-body-mutated.k --spec-module SPEC --verification inputs/verification-body-mutated.k --verification-module VERIFICATION --source inputs/dstoken-bin-body-mutated.k --claim SPEC.totalSupply-success
```

Exit 1; task `52008ac3-6228-4e80-97ff-dc21c6d463a9`; `outcome: notProved`.
The actual failure is:

```text
OUTPUT_CELL: #buf ( 32 , #lookup ( STORAGE:Map , 1 #Implies 0 ) )
Path condition:
  #Top
```

Unmodified stdout, stderr, typed task results, and final tool exits are in
`/app/output/evidence/audit/session-c9daec22-c065-4961-a57f-e2633a3988cc/`.

## Per-gate results

- **Gate A — PASS.** The claims execute the exact pinned runtime through the
  dispatcher and body. No candidate bridge skips execution. Full observable
  result and storage constraints are present. The false postcondition and
  one-byte body mutation both fail on satisfiable symbolic paths.
- **Gate B — PASS.** Proving retained both approved claims and their full
  symbolic address, storage, and call-value domains. It introduced no stronger
  precondition, finite bound, trusted claim, depth bound, or summary shift.
  The formal behavior matches the supplied runtime and source intent.
- **Gate C — PASS.** Every assumption and exclusion is named, all validation
  and proof evidence is preserved with task IDs and logs, and no finite test is
  presented as universal proof.

## Trust boundary

The result trusts the immutable bundled `evm` definition at repository
`https://github.com/nlp-research-rosu/semantics-evm`, commit `4f4c3843076c`,
including its EDSL, optimization, lemma, ABI, and EVM modules. It also trusts
the K/KEVM compiler, Kore executor, SMT reasoning, and remote Prover reporting.
Both claims depend on those components.

The supplied `contract.bin` is the selected executable. Byte identity is
checked, but source-to-bytecode compilation equivalence is not claimed.

## Empirically supported facts

No differential or finite semantic test is used to justify a universal
equivalence. The byte comparison is exact artifact identity. Static byte
inspection confirms selector `0x18160ddd`, its branch at `0x01fb`, the
nonpayable revert guard, and the slot-0 `SLOAD` body at `0x0957`. The mutation
runs are formal discrimination and body-sensitivity evidence.

## Excluded behavior

Excluded are malformed, short, trailing noncanonical, or differently selected
calldata; other contract functions; constructor and deployment execution;
exact gas cost and out-of-gas behavior; transaction-level wrapping; Solidity
recompilation equivalence; and final stack, memory, memory high-water mark, and
PC values. These exclusions do not remove either requested canonical-call
behavior.
