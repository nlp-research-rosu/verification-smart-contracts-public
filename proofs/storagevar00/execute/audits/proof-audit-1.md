# Proof audit 1

## Artifacts examined

- Construction session identity (pin comparison only): `00599ca4-f253-4bff-8222-619c376a46e8`.
- Candidate proof sources: `/app/output/spec.k` and `/app/output/verification.k`.
- Scope and executable evidence: `/app/output/SCOPE.md` and `/app/output/prove.sh`.
- Programs: `/app/contract.sol` and the 161-byte `/app/contract.bin`.
- Approved baseline: `/app/output/audits/spec-audit-2.md`.
- Immutable bundled semantics fetched at `/home/node/.config/kprover/semantics/nlp-research-rosu/semantics-evm/4f4c3843076c`.
- Clean-room session: `371c6e0b-661a-4ca6-9a33-58fd02158e9b`.
- Clean-room evidence: `validation-001` through `validation-003` and `proof-001` through `proof-004` under that session.

No constructor report was read or used. Candidate hashes before and after the audit were identical:

```text
70beacc0083abeb5b90bb59b1a0a4985b13c8f34f01756affdbd0f2655f50f3c  /app/output/spec.k
7337f14fb1adce20923c483e19822f9e98f331851b4d51ef606797a6d8c5cb1a  /app/output/verification.k
0b99e1eeac067d7ceceaedc126e19d3d9a237bd4781721e410611151f589152b  /app/output/SCOPE.md
eb1d7ae6a5efa3446771aae6991f828f4a197f8fb0f6b6c4c307ff571ef729cc  /app/output/prove.sh
85e23dc4240de48b536fc9bfabd622ad25bcc5862cb9497837309bece7ee2266  /app/contract.sol
d4f641117a2c9887cd8788c822a2b80852c6664e52f60f2b27e5e6300dbf2172  /app/contract.bin
dc99c89a9d0d99f6735f9446ceb3eacfabeee8e6d50d413fd37527469cff021d  /app/output/audits/spec-audit-2.md
```

## Clean-room semantics and sources

The registry, construction session, clean-room session, and independently fetched sources all reported exactly:

```text
id: evm
repo: https://github.com/nlp-research-rosu/semantics-evm
commit: 4f4c3843076c
```

The audit session was started with:

```sh
kprover session start --project /app --semantics evm
```

Exit 0; session `371c6e0b-661a-4ca6-9a33-58fd02158e9b`, zero initial counters. Only `spec.k` and `verification.k` were copied from the candidate into the initial clean-room `inputs/`; both clean-room hashes equal the candidate hashes above. The two audit-authored mutation specs were subsequently added as distinct proof sources. No constructor evidence directory or task was reused.

`kprover health`, `kprover config`, `kprover semantics`, `kprover session show` for both sessions, and `kprover semantics fetch evm` all exited 0. Health was `ok`; the fetched source status was `ready`.

## Rebuilt proof-extension inventory

The candidate adds exactly one extension:

| Field | Reconstructed record |
|---|---|
| Extension | Nullary symbol `#storageVar00Runtime` and its sole equation in `VERIFICATION-SUMMARIES` |
| Class | Definitional summary |
| Semantic role | Names the concrete program byte string; it does not replace or accelerate program execution |
| Domain | Nullary and unconditional; its complete domain is its one possible call |
| Matched context | Equational occurrence only, principally the `<program>` cell and the argument of `#computeValidJumpDests`; no continuation, control stack, binding, or configuration cell is matched |
| Justification scope | Exact equality to the supplied 161-byte `/app/contract.bin` |
| Context containment | Context-independent equality of a closed byte value |
| State footprint | Reads and writes no EVM cell; expansion supplies bytes only |
| Value influence | Selects the bytecode executed and from which valid jump destinations are computed |
| Value justification | Complete byte comparison: `contract.bin` is 161 bytes, the helper literal is 322 hex characters, and equality test exits 0 |
| Justification | `#parseByteStack` from the pinned semantics parses precisely the same hex bytes |
| Dependents | `SPEC.execute-success` and `SPEC.execute-nonpayable-revert` |
| Control validation | Not an operational bridge; the body-sensitivity mutation below nevertheless changes the actual `<program>` and is rejected |
| Value validation | Exact, exhaustive byte identity; no fresh or opaque result exists and no opposite interpretation is admitted by the closed equation |
| Validation | Candidate validation passed; both dependent claims proved independently; false-postcondition and wrong-body mutations failed meaningfully |

The symbol is `[function, total]`; its sole unconditional equation covers the nullary domain, has no overlapping candidate equation, terminates in the bundled parser, and does not recurse. `VERIFICATION` otherwise only imports immutable bundled `EDSL` and `LEMMAS`. There are no candidate operational bridges, trusted primitives, priority rules, ordinary rewrites, simplifications beyond the closed byte definition, auxiliary claims, opaque values, framed bridge cells, or proof-local imported modules. The approved `VERIFICATION-SUMMARIES` content remained hash-identical during audit.

The byte comparison command was:

```sh
bin_hex=$(od -An -tx1 -v /app/contract.bin | tr -d ' \n')
helper_hex=$(sed -n 's/.*#parseByteStack("\([0-9a-f]*\)").*/\1/p' /app/output/verification.k)
test "$bin_hex" = "$helper_hex"
```

Exit 0. `wc -c /app/contract.bin` printed `161`; the extracted helper contained 322 hex characters.

Because there is no operational bridge or fresh/opaque/result-bearing abstraction, the operational-bridge context and opposite-interpretation procedures have no applicable extension. Fixed EVM execution is not preempted.

## Clean-room commands and results

### Candidate validation

```sh
kprover validate --project /app \
  --session 371c6e0b-661a-4ca6-9a33-58fd02158e9b \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Exit 0; task `eb10890e-d19a-4ca4-bae2-807dfed6cbd9`; `status: completed`; `valid: true`; evidence `validation-001`. Stdout records the unbounded `kore-exec ... --module VERIFICATION --prove ... --spec-module SPEC ...` dry-run command. Stderr contains only unused-variable warnings, including existential final internal cells; no error.

### Positive claim: success

```sh
kprover prove --project /app \
  --session 371c6e0b-661a-4ca6-9a33-58fd02158e9b \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --claim SPEC.execute-success
```

Exit 0; task `5517bb54-408d-429f-b7f4-befec24bf64a`; evidence `proof-001`; `status: completed`; `outcome: proved`; `residual: null`; no depth bound and no trusted claim. The client contract defines `proved` as closure with the raw `#Top` KAST. The EVM wrapper's retained stdout renders that closure as:

```text
PROOF PASSED: SPEC.execute-success
```

Retained stderr:

```text
WARNING ... kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

### Positive claim: nonpayable revert

```sh
kprover prove --project /app \
  --session 371c6e0b-661a-4ca6-9a33-58fd02158e9b \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --claim SPEC.execute-nonpayable-revert
```

Exit 0; task `ac596094-b651-4909-94f1-c4380ac2f5d2`; evidence `proof-002`; `status: completed`; `outcome: proved`; `residual: null`; no depth bound and no trusted claim. Retained stdout:

```text
PROOF PASSED: SPEC.execute-nonpayable-revert
```

Retained stderr is the same non-booster warning as the success task and contains no proof error.

### Fresh A5 false-postcondition mutation

Audit source `inputs/audit-mutation.k`, SHA-256 `156cfafbd68022c2c466833071df1b62cfa25496bd4feb7c4c8b9ad6003a80d1`, uses distinct module `SPEC-AUDIT-MUTATION`. Relative to the success claim it replaces exactly:

```k
<output> .Bytes => #buf(32, #lookup(STORAGE, 0)) </output>
```

with:

```k
<output> .Bytes => #buf(32, #lookup(STORAGE, 0) +Int 1) </output>
```

and removes the unrelated revert claim. A satisfiable witness is `ACCT = 0`, `STORAGE = .Map`, and call value 0: the real body returns the 32-byte word 0 while the mutation demands word 1.

Validation command (same session/semantics/verification options as above, with `--spec inputs/audit-mutation.k --spec-module SPEC-AUDIT-MUTATION`) exited 0; task `4b1ce8d2-f924-4df0-b283-32a3b8e3b7bb`; `valid: true`; evidence `validation-002`.

Proof command:

```sh
kprover prove --project /app \
  --session 371c6e0b-661a-4ca6-9a33-58fd02158e9b \
  --semantics evm \
  --spec inputs/audit-mutation.k --spec-module SPEC-AUDIT-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Exit 1; task `1b1bb2ec-12d9-4dc6-9a4e-011e3f7792b7`; evidence `proof-003`; `status: completed`; `outcome: notProved`. The wrapper leaves the structured `residual` field null but retains the meaningful failing-node residual in stdout:

```text
PROOF FAILED: SPEC-AUDIT-MUTATION.execute-success-false-output
1 Failure nodes. (0 pending and 1 failing)
Failure reason:
  Matching failed.
  The following cells failed matching individually (antecedent #Implies consequent):
  OUTPUT_CELL: #buf ( 32 , #lookup ( STORAGE:Map , 0 ) #Implies #lookup ( STORAGE:Map , 0 ) +Int 1 )
Path condition:
  #Top
```

This is a proof rejection with the unmet condition, not a parse error, timeout, or unreachable claim.

### Actual-body sensitivity mutation

Audit source `inputs/audit-body-mutation.k` changes the exact program term and corresponding jump-destination term from `#storageVar00Runtime` to `#parseByteStack("00")` while retaining the original success postcondition. With `STORAGE = .Map`, the one-byte `STOP` body emits empty bytes rather than a 32-byte zero word.

Validation command (same options, with `--spec inputs/audit-body-mutation.k --spec-module SPEC-AUDIT-BODY-MUTATION`) exited 0; task `e3b16cdf-cf76-4451-8837-713edec9970e`; `valid: true`; evidence `validation-003`.

Proof command:

```sh
kprover prove --project /app \
  --session 371c6e0b-661a-4ca6-9a33-58fd02158e9b \
  --semantics evm \
  --spec inputs/audit-body-mutation.k --spec-module SPEC-AUDIT-BODY-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Exit 1; task `b9e484e1-fd3f-4806-9654-825515197db1`; evidence `proof-004`; `status: completed`; `outcome: notProved`. Retained residual:

```text
PROOF FAILED: SPEC-AUDIT-BODY-MUTATION.execute-success-wrong-body
1 Failure nodes. (0 pending and 1 failing)
Failure reason:
  Matching failed.
  OUTPUT_CELL: b"" #Implies #buf ( 32 , #lookup ( STORAGE:Map , 0 ) )
Path condition:
  #Top
```

### Mechanical command ledger

- Candidate/source `sed`, `wc`, `od`, `sha256sum`, `diff`, `find`, `rg`, `test`, and session-inspection commands used above: exit 0, except `diff` intentionally returned a difference internally and was followed by `|| true` for display.
- `install -d` for the clean-room `inputs/`: exit 0. Copy of only `spec.k` and `verification.k`: exit 0.
- `kprover --help` and all relevant subcommand help invocations: exit 0.
- Optional display attempts `xxd -g 1 /app/contract.bin` and `jq ... proof-001/result.json`: exit 127 because those utilities are absent. They were replaced by successful `od`, `sed`, and direct retained-JSON inspection; no required check was lost.
- Audit session final counters: four proof attempts, three validations, zero concrete runs; `kprover session show` exit 0.

## Gate A — real-program soundness: PASS

- **A1 / identity and body sensitivity:** The entry `<k>` executes `#execute` with `<program>` equal to the exact supplied runtime and PC 0. The closed helper expands byte-for-byte to `contract.bin`; the success and revert claims execute fixed bundled EVM semantics rather than a bridge. The wrong-body mutation changes the actual program term and fails on the output cell.
- **A2 / state preservation:** No operational bridge exists. Fixed semantics executes the SLOAD/return path or nonpayable revert path. The account `<storage> STORAGE </storage>` has no rewrite in either claim and therefore constrains the complete map to remain unchanged.
- **A3 / binding, evaluation, and control:** No bridge pins or bypasses binding, evaluation, continuation, return, or exception behavior. Canonical ABI calldata is supplied to the real dispatcher, and the real fixed-semantics paths reach `EVMC_SUCCESS` or `EVMC_REVERT` as constrained. No fresh or opaque result-bearing abstraction exists.
- **A4 / rule validity:** The one candidate equation is a true closed byte equality, total over its nullary domain, non-overlapping, nonrecursive, and terminating. There are no candidate totalization, priority, or simplification interactions to create inconsistency.
- **A5 / non-vacuity:** `ACCT = 0`, empty storage, and zero call value satisfy the success precondition. Observable output, status, and storage are constrained; final internal machine cells alone are existential. The fresh off-by-one postcondition mutation is source-valid and rejected with the exact unmet output relation under `#Top`.

## Residual Gate B — intent adequacy: PASS

No proof-time narrowing occurred relative to the approved spec or original task. `execute()` has no Solidity parameters. The success claim covers arbitrary complete symbolic EVM storage at call value 0; the unsuccessful claim covers the same arbitrary storage and every nonzero 256-bit call value. Together these cover the implemented nonpayable value split. The success output is the ABI uint256 encoding of total slot-0 lookup (including absent-key zero); both branches preserve the complete storage map.

The direct-runtime, canonical-selector, CANCUN, sufficient-gas functional boundary is explicit and matches the requested function verification. No bounded unrolling, finite-size restriction, strengthened storage condition, dropped positive claim, altered summary equation, or trusted auxiliary claim appears. Malformed selectors/calldata, fallback behavior, deployment, out-of-gas thresholds, and transaction accounting are explicitly outside this function-call theorem rather than silently narrowed.

## Gate C — trust and evidence auditability: PASS

### Trust ledger

| Assumption | Effect and dependents | Evidence/boundary |
|---|---|---|
| Correctness of K 7.1.337, `kore-exec`/SMT, the Prover service, and immutable bundled `evm` semantics at `4f4c3843076c` | Value, control, state, and termination interpretation of both claims | Named foundational tool/model boundary; pin independently matched and fetched |
| Bundled `EDSL`, `LEMMAS`, ABI, byte parser, `#lookup`, and `#buf` definitions faithfully implement their documented EVM/mathematical operations | Both claims' calldata, bytecode, storage lookup, encoding, and symbolic simplification | Immutable parts of the pinned semantics, not candidate axioms; relevant definitions inspected |
| Supplied `contract.bin` is the intended compiled runtime corresponding to `contract.sol` | Implementation-to-source identification | The formal theorem executes the supplied bytes; byte identity with the proof helper is complete. Compiler provenance/source-to-bytecode equivalence is not itself formally proved and remains an explicit external artifact assumption |
| Direct runtime execution with gas disabled is the intended functional-call boundary | Excludes transaction wrapper and out-of-gas behavior | Explicit in `SCOPE.md` and in both claims; does not affect the within-scope result |

There are no candidate trusted claims, operational bridges, fresh values, opaque program-derived functions, or empirical summary equations.

### Reproducible evidence

All audit validations, proofs, mutations, task IDs, exit codes, inputs, and retained stdout/stderr are recorded above and remain in the clean-room evidence directories. The complete byte comparison is deterministic equality, not sampling. The approved spec audit's earlier concrete slot-0-equals-42 smoke artifact exists at construction `run-001` with input `inputs/smoke.json`; its likely invocation is the standard `kprover run --session 00599ca4-f253-4bff-8222-619c376a46e8 --program .kprover/sessions/00599ca4-f253-4bff-8222-619c376a46e8/inputs/smoke.json`. Its oracle was a 32-byte return ending in `2a`; stdout contains that terminal configuration, but `krun` exited 1 and the task status is `failed`. It is retained only as a diagnostic and is not counted as validation, differential evidence, or proof.

### Honest result language

- Formally established: the two K reachability claims over the pinned EVM semantics and supplied runtime.
- Conditional: correspondence to real EVM execution and to the Solidity source rests on the named tool/model and supplied-artifact assumptions.
- Empirically supported: no finite differential test is used to justify a universal summary; mutations provide discrimination evidence, not replacement semantics.
- Excluded: the behaviors listed under Gate B and in `SCOPE.md`.

## Final status

All three gates pass. Final status: `VALIDATED`.

VERDICT: PASS
REASON: VALIDATED — both claims replayed to the Prover's typed #Top closure in a pinned clean room, Gate A mutations failed meaningfully, and Gates B and C pass.
