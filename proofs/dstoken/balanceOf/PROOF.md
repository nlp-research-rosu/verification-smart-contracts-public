STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `DSToken:balanceOf`

## What is proven

For the exact 6,955-byte runtime in `/app/contract.bin` (SHA-256 `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`), under immutable semantics `evm@4f4c3843076c` with schedule `BYZANTIUM` and gas disabled:

- Every canonical `balanceOf(address)` call with call value 0, symbolic 160-bit address `WHO`, valid symbolic contract/caller addresses, and arbitrary storage reaches `EVMC_SUCCESS` and returns one 32-byte ABI word equal to `#lookup(STORAGE, #hashedLocation("Solidity", 1, WHO .IntList))`.
- Every such call with a nonzero 256-bit call value reaches `EVMC_REVERT` with empty output.
- The selected account storage is unchanged in both claims.

The result is partial correctness for the direct runtime-call model stated in `SCOPE.md`.

## Formal claim (from `spec.k`)

- `SPEC.balanceOf-success` in `/app/output/spec.k`.
- `SPEC.balanceOf-nonzero-value-reverts` in `/app/output/spec.k`.

Both start at `<k> #execute </k>`, PC 0, empty stack and memory, canonical ABI calldata, and the exact `DSTOKEN_RUNTIME`. Both were proved separately in the independent audit session.

## Proof-extension inventory

The candidate defines one extension: `DSTOKEN_RUNTIME`, a closed definitional macro equal byte-for-byte to `/app/contract.bin`. `VERIFICATION-SUMMARIES` defines no functions, equations, rewrites, priorities, totality rules, or auxiliary/trusted claims. There is no candidate operational bridge and no fresh or opaque candidate result.

The proof imports the pinned bundle's `EDSL-SUMMARY`, `LEMMAS`, and `EVM-OPTIMIZATIONS` modules. On the selected no-gas paths, applicable opcode accelerators cover push/stack arithmetic, calldata access, memory access, SHA3, SLOAD, RETURN, and REVERT. They are part of the immutable semantics pin rather than candidate-authored theory. Static audit confirmed that the relevant one-opcode rules retain their continuation and complete observable footprint; `SLOAD` reads `#lookup` without writing storage, while `RETURN`/`REVERT` set the exact output/status and halt.

The bundled Keccak hook is an external result-bearing primitive. The theorem is conditional on that pinned primitive contract; it does not claim to verify the cryptographic implementation.

## Exact commands and actual outputs

Audit session:

```sh
kprover session start --project /app --semantics evm
```

Actual result: session `12f2b534-7086-4f21-b291-d4473cbf1844`, semantics `evm`, repository commit `4f4c3843076c`, zero initial counters.

Validation:

```sh
kprover validate --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

Actual result: task `86ca29fa-9ba9-42ba-a9ac-f897ce88a87b`, status `completed`, `valid: true`, exit 0. An accidental duplicate submission, task `b0a70582-935b-4059-8943-66dd7b953b0d`, also returned `valid: true`, exit 0; both are retained.

Successful call:

```sh
kprover prove --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC.balanceOf-success
```

Actual result: task `3507a1aa-ff2f-4592-8a22-11924d8337aa`, status `completed`, outcome `proved`, residual `null`, exit 0; stdout: `PROOF PASSED: SPEC.balanceOf-success`.

Nonzero-value call:

```sh
kprover prove --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC.balanceOf-nonzero-value-reverts
```

Actual result: task `8993885f-4be8-46fe-8593-fc47640a4f20`, status `completed`, outcome `proved`, residual `null`, exit 0; stdout: `PROOF PASSED: SPEC.balanceOf-nonzero-value-reverts`.

Mutation validations:

```sh
kprover validate --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-false-output.k --spec-module SPEC-FALSE-OUTPUT --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-FALSE-OUTPUT.balanceOf-success-false
kprover validate --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-body-stop.k --spec-module SPEC-BODY-STOP --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-BODY-STOP.balanceOf-success-body-stop
kprover validate --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-false-revert-status.k --spec-module SPEC-FALSE-REVERT-STATUS --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-FALSE-REVERT-STATUS.balanceOf-nonzero-value-reverts-false
```

Actual results: tasks `b6bdfd45-5883-49d4-9628-6d5fed6b203b`, `4c5d340e-bd24-4610-83a8-a4a798b3b126`, and `7f88afdf-028c-49b4-be0b-c02d26afd592` each completed with `valid: true`, exit 0.

Fresh success off-by-one mutation:

```sh
kprover prove --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-false-output.k --spec-module SPEC-FALSE-OUTPUT --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-FALSE-OUTPUT.balanceOf-success-false
```

Actual result: task `055355b8-a66e-4798-b4d2-56337ceca5b5`, outcome `notProved`, exit 1. The failure node has path condition `#Top` and output mismatch `#lookup(...) #Implies #lookup(...) +Int 1`.

Fresh body mutation:

```sh
kprover prove --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-body-stop.k --spec-module SPEC-BODY-STOP --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-BODY-STOP.balanceOf-success-body-stop
```

Actual result: task `e036e8e2-2bd8-40b4-bebb-dcf35dd29e66`, outcome `notProved`, exit 1. The failure node has path condition `#Top` and output mismatch `b"" #Implies #buf(32, #lookup(...))`.

Fresh revert-status mutation:

```sh
kprover prove --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-false-revert-status.k --spec-module SPEC-FALSE-REVERT-STATUS --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-FALSE-REVERT-STATUS.balanceOf-nonzero-value-reverts-false
```

Actual result: task `5766d827-8689-42fc-a732-64d1d197a2d5`, outcome `notProved`, exit 1. The failure node has path condition `#Top` and status mismatch `EVMC_REVERT #Implies EVMC_SUCCESS`.

Complete stdout/stderr and typed task results are retained in `/app/output/evidence/audit/session-12f2b534-7086-4f21-b291-d4473cbf1844/`.

## Per-gate results

- Gate A — real-program soundness: PASS. Exact runtime execution is pinned; no candidate bridge exists; storage/output/status effects align with the bytecode; both postcondition mutations and the actual-program mutation are rejected on satisfiable paths.
- Gate B — intent adequacy: PASS. The claims symbolically cover the full canonical address/storage domain and partition zero versus every nonzero 256-bit call value, without bounded unrolling or strengthened proof-time preconditions.
- Gate C — trust and evidence auditability: PASS. All assumptions and exclusions are ledgered, every accepted audit task is accounted for, and complete replay/mutation evidence is retained.

## Trust boundary

The proof is conditional on:

- the pinned `evm@4f4c3843076c` semantics faithfully modeling the relevant Byzantine EVM instructions, ABI encoding, storage, and bundled accelerator/lemma modules;
- the bundled Keccak hook implementing the EVM hash primitive;
- `/app/contract.bin` being the intended target runtime; and
- the chosen unmetered direct-call execution model being the intended functional verification model.

The source-to-binary compilation process and cryptographic implementation are not themselves proved.

## Empirically supported facts

No differential test is used as universal evidence. Artifact checks establish that `runtime.k` contains exactly the bytes of `contract.bin`, and static byte inspection witnesses selector `0x70a08231`, mapping base slot 1, `SLOAD`, and the value-guard revert path. Fresh machine-checked mutations demonstrate result and body sensitivity.

## Excluded behavior

Malformed or noncanonical calldata, trailing calldata, unknown selectors, invalid account identifiers, negative or wider-than-256-bit call values, constructor behavior, other exported functions, transaction-envelope validation, metered/out-of-gas execution, and schedules other than the pinned Byzantine configuration are outside the claims. The theorem does not assert an independent total-termination result beyond the reachability claims' partial-correctness meaning.
