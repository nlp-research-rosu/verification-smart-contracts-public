# Proof audit 1

## Artifacts examined

- Construction-session identifier `b35c50df-236f-408a-864d-02f003f9759e`
  (used only to compare the semantics pin)
- `/app/output/spec.k`
- `/app/output/verification.k`
- `/app/output/hkg-bin-runtime.k`
- `/app/output/SCOPE.md`
- `/app/output/prove.sh`
- `/app/contract.sol`
- `/app/contract.bin`
- `/app/output/audits/spec-audit-1.md`
- Independently fetched immutable `evm` semantics at commit `4f4c3843076c`
- Clean-room audit session `2579e61c-a36a-4955-8f43-da6c9ce35ffb`
- Retained audit evidence under `/app/output/evidence/audit/`

No constructor report was read. The candidate files were not repaired or
modified.

Candidate SHA-256 values are recorded in
`/app/output/evidence/audit/audit-manifest.md`. After all dynamic checks, the
candidate hashes were unchanged. The audit-session copies of `spec.k`,
`verification.k`, and `hkg-bin-runtime.k` compare byte-for-byte equal to the
candidates.

## Clean-room reconstruction

`kprover session start` created audit session
`2579e61c-a36a-4955-8f43-da6c9ce35ffb`. Independent `session show` calls gave
the following identity for both the construction and audit sessions:

```text
id: evm
repo: https://github.com/nlp-research-rosu/semantics-evm
commit: 4f4c3843076c
```

Only the three proof sources were initially copied into the clean room's
`inputs/`: `spec.k`, `verification.k`, and `hkg-bin-runtime.k`. The mutation
artifact was added later under a distinct filename. No bundled semantics
source was uploaded.

### Commands and terminal results

Environment and pin checks:

```sh
kprover health
```

Exit 0; actual result: `{"kVersion":"7.1.337","status":"ok"}`.

```sh
kprover semantics
kprover session show b35c50df-236f-408a-864d-02f003f9759e
kprover session start --project /app --semantics evm
kprover session show 2579e61c-a36a-4955-8f43-da6c9ce35ffb
kprover semantics fetch evm
```

Each exited 0. The registry, both sessions, and the fetched source all reported
the same `evm` repository and commit above. `kprover config` also exited 0 and
reported a 20-attempt proof budget and a 1,200-second task timeout.

Source identity checks:

```sh
cmp /app/output/spec.k \
  /app/.kprover/sessions/2579e61c-a36a-4955-8f43-da6c9ce35ffb/inputs/spec.k
cmp /app/output/verification.k \
  /app/.kprover/sessions/2579e61c-a36a-4955-8f43-da6c9ce35ffb/inputs/verification.k
cmp /app/output/hkg-bin-runtime.k \
  /app/.kprover/sessions/2579e61c-a36a-4955-8f43-da6c9ce35ffb/inputs/hkg-bin-runtime.k
diff -qr /app/semantics \
  /home/node/.config/kprover/semantics/nlp-research-rosu/semantics-evm/4f4c3843076c
sha256sum /app/contract.bin
perl -ne 'while (/\\x([0-9a-f]{2})/g) { print pack("H2", $1) }' \
  /app/output/hkg-bin-runtime.k | sha256sum
```

Each exited 0 and each comparison was silent. Both SHA-256 outputs were:

```text
71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73
```

The Perl reconstruction and `/app/contract.bin` were both exactly 2,091 bytes.

Positive validation:

```sh
kprover validate --project /app \
  --session 2579e61c-a36a-4955-8f43-da6c9ce35ffb \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/hkg-bin-runtime.k
```

Exit 0. Task `4341e9aa-f4d2-4b02-ae7c-295c81419e5f` completed with
`result.valid: true`; final `kprove` exit 0. The complete stdout and stderr are
preserved in `positive-validation-result.json`. Compiler warnings concern
unused existential final-state variables and do not change claim meaning.

Unfiltered positive proof replay:

```sh
kprover prove --project /app \
  --session 2579e61c-a36a-4955-8f43-da6c9ce35ffb \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/hkg-bin-runtime.k
```

Exit 0. No `--claim`, `--exclude-claim`, `--trusted`, or `--depth` option was
used. Task `7c658e49-b3e2-498d-a8ea-cd6a41319767` completed with typed outcome
`proved`, null residual, and final `kprove` exit 0. Per the client contract,
`proved` denotes raw `#Top` closure. Actual stdout was:

```text
PROOF PASSED: SPEC.transferFrom-fail-allowance
PROOF PASSED: SPEC.transferFrom-fail-zero
PROOF PASSED: SPEC.transferFrom-fail-balance
PROOF PASSED: SPEC.transferFrom-success
```

Actual stderr was:

```text
WARNING 2026-09-15 16:03:43,065 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

The complete typed result and both logs are preserved in
`positive-proof-result.json`.

### Fresh false-postcondition mutation

The audit copied `spec.k` to `inputs/spec-mutation.k`, renamed its module to
`SPEC-MUTATION`, renamed the success claim to
`transferFrom-success-false-output`, and made exactly one semantic mutation:

```diff
-    <output> .Bytes => #buf(32, 1) </output>
+    <output> .Bytes => #buf(32, 0) </output>
```

The mutation keeps the real program, state postcondition, event, status, and
success guard unchanged. It is false on a satisfiable instance such as
`ACCT=1`, `CALLER_ID=2`, `FROM=3`, `TO=4`, `VALUE=1`, with the initial source
balance and caller allowance storage lookups both equal to `1` (and the
remaining storage chosen consistently).

Mutation validation:

```sh
kprover validate --project /app \
  --session 2579e61c-a36a-4955-8f43-da6c9ce35ffb \
  --semantics evm \
  --spec inputs/spec-mutation.k --spec-module SPEC-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/hkg-bin-runtime.k \
  --claim SPEC-MUTATION.transferFrom-success-false-output
```

Exit 0. Task `4ce9476c-f8e4-4acc-ba2c-4d753833e50b` completed with
`result.valid: true` and final `kprove` exit 0.

Mutation proof:

```sh
kprover prove --project /app \
  --session 2579e61c-a36a-4955-8f43-da6c9ce35ffb \
  --semantics evm \
  --spec inputs/spec-mutation.k --spec-module SPEC-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/hkg-bin-runtime.k \
  --claim SPEC-MUTATION.transferFrom-success-false-output
```

Exit 1 as required. Task `abf25e0f-c41d-4577-85d2-55899348a2d7`
completed with typed outcome `notProved`. Its failing node had path condition
`#Top` and the following unmet output condition:

```text
OUTPUT_CELL: b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01" #Implies b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
```

The complete mutation, typed result, stdout, and stderr are preserved as
`spec-mutation.k`, `mutation-proof-result.json`, and
`mutation-validation-result.json`.

Two non-evidentiary convenience commands were unavailable: `jq` exited 127 and
`xxd` was not found. Raw JSON was inspected directly, and the independent Perl
byte reconstruction above supplied the required identity check. A probe of
`/app` with Git exited 128 because `/app` is not a Git worktree; semantics
revision identity was instead established by the Prover session pins and the
independent immutable fetch.

## Rebuilt proof-extension inventory

### Local extension: `HKG` runtime constant

- **Exact extension:** `syntax Contract ::= "HKG"` and the single rule
  `#binRuntime(HKG) =>` the ground 2,091-byte `Bytes` expression in
  `hkg-bin-runtime.k`.
- **Class:** definitional summary.
- **Semantic role:** names the supplied executable byte sequence; it does not
  replace execution of any EVM opcode or program-defined helper.
- **Domain and guards:** the single ground constructor `HKG`; no guard,
  recursion, totality attribute, priority, or `owise` case.
- **Matched context:** only the functional term `#binRuntime(HKG)`; no EVM
  cell, continuation, control stack, binding, or state pattern is matched.
- **Justification scope and containment:** exact ground-byte equality. Every
  local use is the same ground term in `<program>` and `jumpDests`, so every use
  lies within that equality.
- **State footprint:** none; it reads and writes no execution cell.
- **Value influence:** selects the code executed by all four claims.
- **Value justification:** reconstructing all literals yields the exact length
  and SHA-256 of `/app/contract.bin`.
- **Dependents:** all four `SPEC` claims.
- **Control validation:** not applicable; this is not an operational bridge.
- **Value validation:** exact byte identity, not an opaque result oracle.
- **Overlap, coverage, and descent:** one nonrecursive equation over one ground
  constructor; no pairwise overlap and complete coverage of all local uses.

### Empty summary module

`VERIFICATION-SUMMARIES` imports `HKG-BIN-RUNTIME` and contains no function,
equation, simplification, concrete rule, priority rule, ordinary rewrite,
totality attribute, auxiliary claim, or opaque value. This is the same empty
summary structure approved by `spec-audit-1.md`; no extension edits that module.

### Verification imports and claims

`VERIFICATION` adds no rule or claim. Its `LEMMAS` import resolves from the
immutable bundled `evm` revision, not a proof-local source. It is part of the
named fixed proof infrastructure trust boundary and was neither shadowed nor
modified in the clean room.

The spec has exactly four positive reachability claims and no auxiliary or
trusted claim. The entry configuration executes `#execute` with the exact
runtime term. Returned bytes, status, complete target storage, and complete log
are constrained. Final stack, memory, program counter, and memory-use counter
are explicit existential internals; other unmentioned cells are framed. No
fresh or opaque proof-local symbol can influence a branch, result, observable
state, exception, or postcondition.

There is no proof-local operational bridge. Consequently there is no displaced
fixed-semantics behavior, widened suffix, abrupt control effect, connection
theorem obligation, or opposite-interpretation witness to apply. The special
generated-counter claim/rule rendering case does not arise.

## Gate A — real-program soundness: PASS

- **A1 / program identity:** every claim's `<program>` is
  `#binRuntime(HKG)`, whose sole equation is byte-identical to the supplied
  runtime. `#execute` starts at PC 0, and no rule replaces any program opcode or
  program-defined function. The proof therefore executes the actual runtime
  under the pinned fixed semantics.
- **A2 / operational state:** no operational bridge exists. The positive
  claims directly constrain status, output, complete contract storage, and the
  complete log; no local extension abstracts their transitions.
- **A3 / binding, evaluation, and control:** selector dispatch, ABI decoding,
  storage reads and writes, branching, LOG3, return encoding, and halt are all
  reached by EVM execution. No local rule pins a binding, changes evaluation
  order, matches a continuation, returns abruptly, or introduces an exception.
- **A4 / rule validity:** the only local equation is the exact ground runtime
  constant. It is nonrecursive, nonoverlapping, and true by the independent
  byte identity check. No local totality, simplification, result-characterizing
  lemma, or opaque result exists.
- **A5 / non-vacuity:** the success guard has the explicit satisfiable witness
  above. The fresh false-output claim validated, then failed with exit 1 and a
  concrete `01` versus `00` output-cell mismatch under path condition `#Top`.
  This demonstrates that the result is constrained and the success claim is
  exercised.
- **Program pinning:** changing the demanded result while keeping the executed
  program term unchanged was rejected. The entry term is not a free variable,
  tautology, or implication that omits the result.

## Residual Gate B — intent adequacy: PASS

This audit rechecked the source contract and `SCOPE.md` rather than adopting the
spec-audit verdict.

- **B1:** address variables range over all 160-bit addresses and `VALUE` over
  uint256. The four guards are disjoint and exhaustive for canonical typed
  calls: zero; positive insufficient balance; positive sufficient balance but
  insufficient allowance; and positive sufficient balance and allowance.
  Storage is otherwise symbolic. The successful post-state expresses the three
  writes sequentially, so aliasing among addresses or storage keys is not
  silently excluded. All four claims were replayed without filtering or
  bounding; proving introduced no strengthened precondition, dropped claim, or
  bounded unrolling.
- **B2:** the theorem explicitly chooses CANCUN, normal non-static top-level
  execution, zero call value, and disabled gas accounting. The fixed semantics
  models the EVM word arithmetic, storage, return, and log behavior used here.
  Gas exhaustion, transaction finalization, and malformed/noncanonical calls
  are explicit theorem-boundary exclusions, not candidate-caused narrowing of
  the stated typed-call contract.
- **B3:** there is no result-bearing summary. The property is stated directly
  over fixed-semantics output, storage, status, and log cells.
- **B4:** the claim partition, update order, allowance key
  `(FROM,CALLER_ID)`, Transfer event arguments, and true/false returns match the
  supplied `transferFrom` body. The scope makes the supplied runtime
  authoritative and uses the Solidity source for intent and layout.

The theorem proved is the approved theorem: no post-audit equation changes a
summary's meaning, and no proof control narrowed its domain.

## Gate C — trust and evidence auditability: PASS

### Named trust boundary and dependents

- **Pinned EVM model:** correctness of bundled semantics ID `evm`, repository
  and commit `4f4c3843076c`, including its `EDSL`, ABI helpers, hashed-location
  functions, and imported `LEMMAS`. This can affect value, control, state, and
  termination. Every claim depends on it. Evidence: matching independent
  session pins, fetched sources identical to `/app/semantics`, and the complete
  dynamic replay.
- **Proof infrastructure:** sound execution of K 7.1.337, `kore-rpc`, the
  backend proof driver, and its SMT reasoning. This affects all formal closure
  conclusions. Every claim depends on it. Evidence: retained typed tasks, exact
  tool exits, stdout/stderr, source hashes, and the discriminating mutation.
- **Program authority:** `/app/contract.bin` is the authoritative deployed
  runtime named by the theorem; `/app/contract.sol` supplies human intent and
  layout rather than an independently proved compilation theorem. Every claim
  depends on that choice. The local runtime definition is not assumed: its
  exact length and hash were checked against the binary.

There is no proof-local trusted primitive, trusted claim, assumed auxiliary
claim, opaque program-derived value, or empirically substituted universal
summary.

### Reproducible evidence

Every claimed dynamic artifact exists under `/app/output/evidence/audit/`.
Commands, task IDs, selected input scope, actual stdout/stderr, and exit status
are recorded above and in the raw result JSON. The positive proof covers all
four claims; the mutation selects only the deliberately false success result.
The mutation's oracle is fixed-semantics execution of the unchanged runtime,
which produced ABI true and rejected ABI false. The byte-identity oracle is the
supplied binary compared with an independent literal reconstruction. No
differential test is claimed.

### Honest result language

The four reachability claims are formally closed conditional on the named
semantics and proof-infrastructure trust boundary. Exact byte identity and the
mutation are reproducible finite/mechanical evidence, not a substitute for the
formal closure. Behavior outside the formal entry configuration is excluded
below and is not described as proved.

## Final status

Gate A PASS; Gate B PASS; Gate C PASS. Final status: `VALIDATED`.

VERDICT: PASS
REASON: Gates A, B, and C pass, so the final proof status is VALIDATED.
