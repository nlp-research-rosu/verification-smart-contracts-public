STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `HKG:transfer`

## What is proven

Under pinned `evm` semantics revision `4f4c3843076c`, the exact 2,091-byte runtime in `/app/contract.bin` implements the following behavior for canonical ABI calls to `StandardToken.transfer(address,uint256)` from PC 0, with symbolic contract address, caller, recipient, uint256 value, complete contract storage map, and prior log list:

- With zero call value, a positive `VALUE` no greater than the caller balance returns ABI boolean true, deducts `VALUE` from the caller, then adds `VALUE` to the recipient with EVM word arithmetic, and appends the exact `Transfer(CALLER_ID, TO, VALUE)` event.
- With zero call value, `VALUE == 0` or caller balance below `VALUE` returns ABI boolean false with storage and logs unchanged.
- With positive uint256 call value, the nonpayable guard reverts with empty output and leaves storage and logs unchanged.

The success storage writes are sequential, so the theorem includes the exact self-transfer/aliased-key behavior. Recipient addition wraps modulo `2^256`, as the EVM and Solidity 0.4.x implementation do.

## Formal claim (from `spec.k`)

`SPEC.transfer-success`, `SPEC.transfer-false`, and `SPEC.transfer-nonpayable` each execute:

```k
<k> #execute => #halt ... </k>
```

against the literal supplied runtime, with canonical `#abiCallData("transfer", #address(TO), #uint256(VALUE))`, `BYZANTIUM`, normal non-static execution, and gas disabled. They constrain output, status, full contract storage, and logs. Final stack, memory, PC, and memory-use are existential internal scratch state.

The claim guards partition the represented canonical calls as follows:

```text
call value = 0 and 0 < VALUE <= caller balance       -> true return
call value = 0 and (VALUE = 0 or caller balance < VALUE) -> false return
0 < call value < 2^256                               -> revert
```

The theorem is symbolic, not a finite test or bounded unrolling.

## Proof-extension inventory

There are no candidate-added proof extensions.

| Module/item | Inventory result |
|---|---|
| `VERIFICATION-SUMMARIES` | Imports pinned bundled `EDSL`; defines no candidate function, equation, rule, claim, macro, bridge, or opaque symbol |
| `VERIFICATION` | Imports `VERIFICATION-SUMMARIES` and pinned bundled `LEMMAS`; defines no candidate extension |
| `SPEC` | Contains only the three target reachability claims |

No trusted claim, totality attribute, simplification rule, concrete rule, priority rule, ordinary rewrite, auxiliary claim, operational bridge, or fresh program-derived abstraction is present. The bundled `EDSL`/`LEMMAS` theory is part of the immutable selected semantics and is recorded in the trust boundary below.

## Exact commands and actual outputs

### Pin and clean room

```text
kprover session show be08e0e3-e40e-4601-8a5d-f2c542d32676
```

Exit 0: semantics ID `evm`, repo `https://github.com/nlp-research-rosu/semantics-evm`, commit `4f4c3843076c`.

```text
kprover semantics
kprover semantics fetch evm
kprover session start --project /app --semantics evm
```

Each exited 0. The fresh session is `ab991c17-8c1c-4216-a9f0-d11868972d84`, independently pinned to the same repo/commit. Only `spec.k` and `verification.k` were initially copied into its `inputs/`; their hashes matched the candidate.

Runtime identity command output:

```text
runtime-bytes=2091 runtime-hex-chars=4182 literals=6 mismatches=0 selector-offset=88
```

### Candidate validation

```text
kprover validate --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION
```

The accepted validation was repeated after the first local output stream yielded. Both accepted tasks are retained and succeeded:

- `e3c17f66-b2bf-441e-b258-209eac1bc73f`: exit 0, `completed`, `valid: true`.
- `e95687d4-ab23-4449-8546-2e77f849db99`: exit 0, `completed`, `valid: true`.

Downloaded stdout for each is the actual `kore-exec ... --module VERIFICATION --prove ... --spec-module SPEC ...` dry-run command. Downloaded stderr contains only unused-variable warnings from bundled sources and intentionally existential scratch-state variables. Full logs are retained in `output/evidence/audit/clean-room-ab991c17/validation-001-result.json` and `validation-002-result.json`.

### Positive proof replays

```text
kprover prove --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC.transfer-success
```

Actual terminal result:

```text
task.id: c7128012-a7cd-44e9-a717-c742a7cf312b
task.status: completed
task.result.outcome: proved
task.result.residual: null
toolRuns[-1].exitCode: 0
stdout: PROOF PASSED: SPEC.transfer-success\n
stderr: WARNING 2026-09-15 15:46:39,977 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc\n
```

```text
kprover prove --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC.transfer-false
```

Actual terminal result:

```text
task.id: 064d72e3-c56b-46f8-a4e8-23f6dbac599c
task.status: completed
task.result.outcome: proved
task.result.residual: null
toolRuns[-1].exitCode: 0
stdout: PROOF PASSED: SPEC.transfer-false\n
stderr: WARNING 2026-09-15 15:48:50,106 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc\n
```

```text
kprover prove --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC.transfer-nonpayable
```

Actual terminal result:

```text
task.id: b58bbf4c-162e-4e10-ac4f-1db2df830a59
task.status: completed
task.result.outcome: proved
task.result.residual: null
toolRuns[-1].exitCode: 0
stdout: PROOF PASSED: SPEC.transfer-nonpayable\n
stderr: WARNING 2026-09-15 15:51:40,698 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc\n
```

No command used `--depth` or `--trusted`. The backend-native raw closure marker is `PROOF PASSED: <claim>`; each retained response also has typed `proved`, exit 0, and null residual.

Before task `c7128012-a7cd-44e9-a717-c742a7cf312b` was accepted, two identical commands exited 1 without creating a task or consuming an attempt. Their exact local response was:

```json
{
  "message": "Prover returned HTTP 500 Internal Server Error: STORAGE_EXHAUSTED: The configured data directory is full.",
  "status": "failure"
}
```

The subsequent accepted tasks completed; this transient event is not used as proof evidence.

### Fresh A5 false-postcondition mutation

Mutation source: `output/audits/a5-false-output.k`, SHA-256 `fe6354e02ffb0faf59acf99cb6f8a4d7608495df817dd48877780ea85c888169`.

Exact semantic mutation:

```diff
-    <output> .Bytes => #buf(32, 0) </output>
+    <output> .Bytes => #buf(32, 1) </output>
```

It also uses distinct module `SPEC-MUTATION-A5` and claim `transfer-false-mutant`.

Satisfiable witness: `ACCT=256`, `CALLER_ID=257`, `TO=258`, `VALUE=1`, call value `0`, caller balance `0`, and empty prior log. This lies on `callerBalance < VALUE` and must return false.

```text
kprover validate --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/a5-false-output.k --spec-module SPEC-MUTATION-A5 --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC-MUTATION-A5.transfer-false-mutant
```

Task `1d4bb030-2240-43a8-a092-b1d0ff396585`: exit 0, `completed`, `valid: true`.

```text
kprover prove --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/a5-false-output.k --spec-module SPEC-MUTATION-A5 --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC-MUTATION-A5.transfer-false-mutant
```

Actual terminal result:

```text
task.id: 0000303d-5d88-476b-b5e9-61bc9bb615d8
task.status: completed
task.result.outcome: notProved
toolRuns[-1].exitCode: 1
stderr: WARNING ...; Terminating proof early because fail_fast is set: SPEC-MUTATION-A5.transfer-false-mutant
stdout: PROOF FAILED: SPEC-MUTATION-A5.transfer-false-mutant
        2 Failure nodes. (1 pending and 1 failing)
        Failure reason: Matching failed.
        OUTPUT_CELL: b"\x00...[32 zero bytes]" #Implies b"\x00...[31 zero bytes]\x01"
        Path condition: #lookup(STORAGE, callerSlot) <Int VALUE
```

The complete unabridged stdout/stderr is retained at `output/evidence/audit/clean-room-ab991c17/proof-004-a5-mutation-result.json`.

## Per-gate results

### Gate A — PASS

Every claim directly executes the exact runtime under fixed semantics. All six embedded runtime literals match `/app/contract.bin`; no candidate bridge, summary, equation, or opaque result can bypass execution. Output, status, storage, and logs are constrained. The fresh false-output mutation was rejected with an explicit output-cell mismatch on a satisfiable path.

### Gate B — PASS

The three guards are disjoint and exhaustive over canonical represented `transfer` calls in the stated environment. They match the source guard, ordered storage updates, event, returns, and compiled nonpayable rejection. Symbolic addresses, uint256 values, arbitrary storage, and arbitrary prior logs are covered without bounds. No proof-stage narrowing, strengthened precondition, missing branch, changed summary, trusted claim, or bounded execution was introduced.

### Gate C — PASS

All accepted audit tasks, exact invocations, typed results, task IDs, exit codes, stdout, and stderr are retained. The trust ledger and exclusions below distinguish proved, conditional, static/empirical, and excluded facts. No differential-test claim is made.

## Trust boundary

The formal result is conditional on:

- the soundness of K, kore-rpc, SMT solving, and the remote Prover service;
- the correctness of the immutable bundled `evm` semantics at `nlp-research-rosu/semantics-evm@4f4c3843076c`, including bundled `EDSL`, optimizations, `LEMMAS`, ABI, hashing, storage, event, and word operations;
- `/app/contract.bin` being the intended target runtime.

The theorem proves the supplied runtime. Source-to-bytecode compiler correctness is not proved; source lines 94–110, selector routing, and the exact runtime literal were checked for attribution and adequacy.

## Empirically supported facts

- All six bytecode literals in `spec.k` equal the 2,091-byte target runtime; mismatch count is zero.
- The runtime contains the `0xa9059cbb` selector route to offset `0x0192`.
- Manual inspection aligns the source transfer guard, sequential writes, event, and returns with the formal postconditions.
- The A5 mutation is finite non-vacuity evidence that the proof discriminates false from true return bytes; it is not a substitute for the symbolic positive proofs.

No differential test or universal source-compilation equivalence is claimed.

## Excluded behavior

Malformed or noncanonical calldata; other selectors/functions; static-call rejection; gas use and out-of-gas behavior; schedules other than BYZANTIUM; transaction-envelope validation or rollback after the current EVM frame halts/reverts; compiler correctness; and behavior outside values/configurations represented by the pinned semantics.
