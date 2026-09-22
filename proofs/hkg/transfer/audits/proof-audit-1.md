# Proof audit 1

## Verdict summary

All three gates pass. The final proof status is `VALIDATED` within the explicitly recorded functional EVM boundary.

This audit did not read or rely on a constructor report. It used only the dispatched paths, the original task statement, the approved specification-audit baseline, the pinned semantics sources, and fresh clean-room Prover results.

## Artifacts examined

| Artifact | SHA-256 / identity |
|---|---|
| `/app/output/spec.k` | `86aa840da9b4e405e267241d2c19b7b43396ad5a46123d511e2b0c2f00c461b2` |
| `/app/output/verification.k` | `9b1277b71ad8a1f946e0398a67a42d4c5b54c936ae72b7ba6ecf8478ca0e8507` |
| `/app/output/SCOPE.md` | `1f00219689f47682a1390246857e9d11634e57455695f98d2ae55ffb9be57481` |
| `/app/output/prove.sh` | `f6b0bab4237b3957eeb43804478c16f58acde26a6fb72445f248e8e913d5d036` |
| `/app/contract.bin` | 2,091 bytes; `71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73` |
| `/app/contract.sol` | `cee59f7cb8d3245e61fab5bb037753500cf71e19be40184acb1a8306dc05106b` |
| `/app/output/audits/spec-audit-1.md` | `6cf2b7fe0b0ec8ab6ee37e44fa07c6c35b4f38a7eb56fefd0e7a48ca60c23c1a` |
| construction session | `be08e0e3-e40e-4601-8a5d-f2c542d32676` |
| audit session | `ab991c17-8c1c-4216-a9f0-d11868972d84` |
| semantics | `evm`, `https://github.com/nlp-research-rosu/semantics-evm`, commit `4f4c3843076c` |

The candidate files retained the hashes above after all audit operations. The only authored proof mutation is `/app/output/audits/a5-false-output.k` (`fe6354e02ffb0faf59acf99cb6f8a4d7608495df817dd48877780ea85c888169`). It is not a candidate file.

## Clean-room reconstruction

### Independent semantics pin

`kprover session show be08e0e3-e40e-4601-8a5d-f2c542d32676` exited 0 and independently reported construction semantics ID `evm`, repository `https://github.com/nlp-research-rosu/semantics-evm`, commit `4f4c3843076c`.

`kprover semantics` exited 0 and listed exactly that current server-supported `evm` repository and commit. `kprover semantics fetch evm` exited 0 and returned the immutable source directory `/home/node/.config/kprover/semantics/nlp-research-rosu/semantics-evm/4f4c3843076c`.

`kprover session start --project /app --semantics evm` exited 0 and created audit session `ab991c17-8c1c-4216-a9f0-d11868972d84`, independently pinned to the same repository and commit. Thus the construction and audit revisions match the requested `4f4c3843076c` exactly.

Initially, only `spec.k` and `verification.k` were copied into the clean-room `inputs/` directory. Their hashes matched the candidate. The A5 mutation source was added later as a distinct audit input. No bundled semantics source was copied.

### Validation

Exact candidate validation command:

```text
kprover validate --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION
```

The command was accepted twice because the first local output stream yielded before its terminal response was observed. Both accepted validations are accounted for and completed successfully:

| Task | Exit | Status | Result | Retained evidence |
|---|---:|---|---|---|
| `e3c17f66-b2bf-441e-b258-209eac1bc73f` | 0 | `completed` | `valid: true` | `output/evidence/audit/clean-room-ab991c17/validation-001-result.json` |
| `e95687d4-ab23-4449-8546-2e77f849db99` | 0 | `completed` | `valid: true` | `output/evidence/audit/clean-room-ab991c17/validation-002-result.json` |

The downloaded stdout contains the actual `kore-exec ... --module VERIFICATION --prove ... --spec-module SPEC ...` dry-run invocation. Downloaded stderr contains only compiler warnings about an unused bundled variable and intentionally existential/unobserved final scratch-state variables; there is no compile error.

### Positive claim replay

Each claim was replayed individually with no depth bound and no `--trusted` option. Before the accepted `transfer-success` task, two identical submissions exited 1 locally with the exact response:

```json
{
  "message": "Prover returned HTTP 500 Internal Server Error: STORAGE_EXHAUSTED: The configured data directory is full.",
  "status": "failure"
}
```

Those two rejected submissions created no server task and consumed no proof attempt; `kprover session show` still reported `attemptsUsed: 0`. A third identical submission was accepted. The server remained healthy, and all subsequent tasks completed, so this was a transient instrument event rather than candidate evidence.

Exact accepted commands and terminal results:

```text
kprover prove --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC.transfer-success
```

- Task: `c7128012-a7cd-44e9-a717-c742a7cf312b`
- Exit/status/result: `0`, `completed`, `outcome: proved`, `residual: null`
- Downloaded stdout: `PROOF PASSED: SPEC.transfer-success\n`
- Downloaded stderr: `WARNING 2026-09-15 15:46:39,977 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc\n`
- Evidence: `output/evidence/audit/clean-room-ab991c17/proof-001-transfer-success-result.json`

```text
kprover prove --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC.transfer-false
```

- Task: `064d72e3-c56b-46f8-a4e8-23f6dbac599c`
- Exit/status/result: `0`, `completed`, `outcome: proved`, `residual: null`
- Downloaded stdout: `PROOF PASSED: SPEC.transfer-false\n`
- Downloaded stderr: `WARNING 2026-09-15 15:48:50,106 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc\n`
- Evidence: `output/evidence/audit/clean-room-ab991c17/proof-002-transfer-false-result.json`

```text
kprover prove --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC.transfer-nonpayable
```

- Task: `b58bbf4c-162e-4e10-ac4f-1db2df830a59`
- Exit/status/result: `0`, `completed`, `outcome: proved`, `residual: null`
- Downloaded stdout: `PROOF PASSED: SPEC.transfer-nonpayable\n`
- Downloaded stderr: `WARNING 2026-09-15 15:51:40,698 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc\n`
- Evidence: `output/evidence/audit/clean-room-ab991c17/proof-003-transfer-nonpayable-result.json`

The EVM backend emits the raw terminal closure marker `PROOF PASSED: <claim>` rather than printing a literal KAST `#Top`; in all three retained server responses, that raw marker is accompanied by the client's typed `outcome: proved`, K exit 0, and null residual. No success is inferred from exit status alone.

## Rebuilt proof-extension inventory

The candidate source inventory was rebuilt with a declaration/attribute scan and manual inspection.

| Candidate item | Classification | Behavior / dependents | Audit result |
|---|---|---|---|
| `VERIFICATION-SUMMARIES` | No extension | Imports pinned bundled `EDSL`; contains no syntax, function, rule, equation, claim, macro, or attribute | No candidate summary or oracle exists; identical to the approved baseline |
| `VERIFICATION` | No extension | Imports `VERIFICATION-SUMMARIES` and pinned bundled `LEMMAS`; contains no candidate declaration | No candidate bridge, rewrite, lemma, priority rule, or totality assertion exists |
| `SPEC.transfer-success` | Target reachability claim | Executes the literal runtime under fixed semantics and constrains success output, status, storage, and log | Replayed and proved |
| `SPEC.transfer-false` | Target reachability claim | Executes the literal runtime under fixed semantics and constrains false output with storage/log unchanged | Replayed and proved |
| `SPEC.transfer-nonpayable` | Target reachability claim | Executes the literal runtime under fixed semantics and constrains revert output/status with storage/log unchanged | Replayed and proved |

The declaration scan found exactly three claims in `spec.k` and no candidate rules, functions, macros, totality attributes, simplifications, concrete rules, priority rules, ordinary rewrites, auxiliary claims, or trusted claims in either candidate K file. There are no proof-local imported modules beyond those two files.

`EDSL` and `LEMMAS` are immutable parts of the pinned bundled `evm` semantics, not candidate proof extensions. Their inspected source hashes are respectively `cd26dcacb348955a49cfe7d804191ece0bab24d88040a03bc0af65bf19096c4f` and `4167738dde6fb2caf6493f03dc54f2b5d75f4a7dd4250b51287e219a3ea09460`.

There is no operational bridge, so there is no candidate matched context, preempted fixed-semantics behavior, connection theorem, broader suffix, abrupt effect, or operational-sensitivity test to audit. There is no fresh/opaque program-derived result. The existential final stack, memory, PC, and memory-used variables affect only deliberately unobserved internal scratch cells and cannot influence output, status, storage, log, or a postcondition.

## Gate A — real-program soundness: PASS

### A1: program identity and body sensitivity

The entry computation in every claim is `<k> #execute => #halt ... </k>` with PC 0, empty word stack, empty local memory, the canonical ABI call data for `transfer(address,uint256)`, and a literal `<program>` term. A binary-to-hex comparison reported:

```text
runtime-bytes=2091 runtime-hex-chars=4182 literals=6 mismatches=0 selector-offset=88
```

All three `<program>` literals and all three `jumpDests` literals therefore equal `/app/contract.bin` byte-for-byte. The runtime contains `63a9059cbb14610192`, routing selector `0xa9059cbb` to the transfer entry. There is no summary or bridge that can bypass body execution. A body-sensitivity mutation is unnecessary because the claim directly executes the literal body under fixed semantics; changing that literal changes the actual program term submitted.

### A2/A3: state, binding, evaluation, and control fidelity

No candidate operational bridge exists. Fixed semantics performs dispatcher selection, ABI decoding, SLOAD/SSTORE, branching, event emission, return encoding, nonpayable revert, and halting. Binding is pinned by the literal runtime plus canonical selector call data. Observable output, status, complete contract storage, and log are constrained. Other accounts/cells are framed; stack, local memory, PC, and memory-use are explicitly existential internal scratch state. Thus no candidate rule preempts control or omits an executed state transition.

### A4: logical consistency

There is no candidate equation, total function, simplification, priority rule, or opaque value to check for truth, overlap, coverage, descent, or totalization. `VERIFICATION-SUMMARIES` is empty apart from its bundled import.

### A5: satisfiability and fresh false-postcondition mutation

The candidate preconditions are satisfiable. One concrete false-return witness is `ACCT = 256`, `CALLER_ID = 257`, `TO = 258`, `VALUE = 1`, zero call value, empty prior log, and a storage map whose caller-balance slot contains `0`. It satisfies all range guards and `callerBalance < VALUE`.

Fresh mutation `/app/output/audits/a5-false-output.k` changes only:

```diff
-module SPEC
+module SPEC-MUTATION-A5
-  claim [transfer-false]:
+  claim [transfer-false-mutant]:
-    <output> .Bytes => #buf(32, 0) </output>
+    <output> .Bytes => #buf(32, 1) </output>
```

Exact validation command:

```text
kprover validate --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/a5-false-output.k --spec-module SPEC-MUTATION-A5 --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC-MUTATION-A5.transfer-false-mutant
```

Task `1d4bb030-2240-43a8-a092-b1d0ff396585` completed with exit 0 and `valid: true`. Evidence: `output/evidence/audit/clean-room-ab991c17/validation-003-a5-mutation-result.json`.

Exact proof command:

```text
kprover prove --session ab991c17-8c1c-4216-a9f0-d11868972d84 --semantics evm --spec inputs/a5-false-output.k --spec-module SPEC-MUTATION-A5 --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC-MUTATION-A5.transfer-false-mutant
```

Task `0000303d-5d88-476b-b5e9-61bc9bb615d8` completed with exit 1 and `outcome: notProved`. Downloaded stderr records fail-fast termination on `SPEC-MUTATION-A5.transfer-false-mutant`. Downloaded stdout records a failing node whose exact unmet condition is:

```text
OUTPUT_CELL: b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" #Implies b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01"
```

Its path condition is `#lookup(STORAGE, callerSlot) <Int VALUE`, which the concrete witness above satisfies (`0 < 1`). The mutation therefore exercises and discriminates the false-return result. Evidence: `output/evidence/audit/clean-room-ab991c17/proof-004-a5-mutation-result.json`.

## Residual Gate B — intent adequacy: PASS

The audit rechecked adequacy independently against `contract.sol`, `contract.bin`, the task request, `SCOPE.md`, and the approved baseline.

- Source lines 94–110 implement `balances[msg.sender] >= value && value > 0`, sequential sender subtraction and recipient addition, `Transfer(msg.sender,to,value)`, true return, and an otherwise false return. The symbolic claims state exactly those branches against the authoritative runtime.
- At zero call value, the success and false guards are disjoint and exhaustive over every represented uint256 `VALUE` and every symbolic storage map: `(0 < VALUE && VALUE <= balance)` versus `(VALUE == 0 || balance < VALUE)`.
- Positive represented call values are exhaustively covered by the nonpayable revert claim. Address and value guards cover their complete ABI ranges.
- The success storage RHS performs sequential EVM word writes, preserving self-transfer aliasing and uint256 wraparound. The false and revert claims preserve complete storage and log. Success appends the exact ABI `Transfer` event.
- The theorem is symbolic over contract address, caller, recipient, value, complete storage map, and initial log list; it is not bounded by examples or unrolling.
- `BYZANTIUM`, functional execution with gas disabled, canonical ABI calldata, non-static context, and a single EVM frame are explicit boundaries. Malformed calldata, other selectors, static-call rejection, transaction-envelope processing, gas consumption, and out-of-gas behavior are honestly excluded. These do not narrow the requested canonical `transfer` function behavior.
- Proving added no strengthened precondition, dropped claim, bounded execution depth, trusted claim, or changed summary meaning relative to the approved spec. `VERIFICATION-SUMMARIES` remains empty.

The supplied runtime is the program identity proved. Source/runtime compilation correspondence is not itself a formal theorem, but manual source/runtime alignment is sufficient for the requested implemented-behavior reading because the dispatched runtime is authoritative.

## Gate C — trust and evidence auditability: PASS

### Trust ledger

| Unproved component / assumption | Effect | Dependents | Support / boundary |
|---|---|---|---|
| Pinned `evm` semantics and its bundled `EDSL`, EVM optimizations, `LEMMAS`, ABI, hashing, storage, event, and word-arithmetic definitions | Execution, value, state, control, termination model | All three claims | Immutable server-selected semantics `4f4c3843076c`; independently pinned and fetched for inspection |
| K/kore-rpc backend, SMT solver, and Prover service soundness | Logical closure | All formal results | Standard formal-tool trusted computing base; exact versions/pin and raw task evidence retained |
| Supplied `contract.bin` is the intended deployed runtime | Program identity | All claims | Dispatched target; 2,091-byte literal match checked at all six occurrences |
| Source-to-runtime compilation correspondence | Human source attribution only | Statement that this is `StandardToken.transfer` | Runtime is authoritative; selector route and source body manually aligned; no compiler-reproducibility claim is made |
| Disabled gas accounting | Excludes resource failure and gas cost | All claims | Explicit `<useGas> false`; no gas/OOG conclusion is claimed |
| BYZANTIUM, canonical ABI call, non-static single-frame environment | Execution-model boundary | All claims | Explicit in each claim and `SCOPE.md`; excluded behavior listed below |

No candidate trusted primitive, opaque result, operational bridge, summary equation, assumed claim, or empirical differential oracle exists.

### Reproducibility

All server-accepted validations and proofs are retained under `/app/output/evidence/audit/clean-room-ab991c17/`. Each JSON contains the server task ID, semantics pin, status, typed result, tool exit code, complete downloaded stdout, and complete downloaded stderr. The mutation source and exact diff are retained under `/app/output/audits/`. Exact commands, input scope, witness, oracle (the unchanged runtime execution), and result are recorded above.

The audit claims no differential testing. The byte comparison and selector/source inspection are finite identity/adequacy checks, not universal execution evidence. Universal behavior comes from the three symbolic reachability proofs under the named trust boundary.

### Honest result language

- Formally established: the three reachability claims close for their full symbolic preconditions under pinned `evm` semantics.
- Conditional: the result depends on the pinned semantics, backend/solver soundness, and the supplied runtime being the intended target.
- Empirically/static supported: exact byte-literal identity, selector route, and source-body alignment.
- Excluded: behavior outside the stated execution boundary below.

## Findings

No soundness, adequacy, evidence, or candidate-mutation finding remains. The two pre-task storage errors were transient and are fully disclosed; they neither consumed attempts nor replace proof evidence.

## Excluded behavior

Malformed or noncanonical calldata; selectors other than `transfer(address,uint256)`; static-call rejection; gas use and out-of-gas termination; transaction-envelope validation or rollback outside the current EVM frame; schedules other than BYZANTIUM; source-to-bytecode compiler correctness; other contract functions; and any behavior not represented by the pinned fixed semantics.

VERDICT: PASS
REASON: All three gates pass and the final status is VALIDATED for symbolic canonical `transfer` calls within the recorded functional EVM boundary.
