# Proof audit 1

## Verdict summary

Independent clean-room reconstruction and static theory review pass Gates A,
B, and C. The final proof status is `VALIDATED`.

## Artifacts examined

- `/app/output/spec.k`
- `/app/output/verification.k`
- `/app/output/dstoken-bin.k`
- `/app/output/SCOPE.md`
- `/app/output/prove.sh`
- `/app/contract.sol`
- `/app/contract.bin`
- `/app/output/audits/spec-audit-1.md`
- the immutable bundled `evm` sources at repository
  `https://github.com/nlp-research-rosu/semantics-evm`, commit
  `4f4c3843076c`, fetched only into the shared kprover cache for inspection

No constructor report or construction proof result was read. Construction
session `446149a2-f38c-4c76-9ec9-b7953d48233c` was queried only for its pin:
semantics ID `evm`, the repository above, and commit `4f4c3843076c`.

The clean-room audit session is `c9daec22-c065-4961-a57f-e2633a3988cc`.
Its independently resolved pin is identical. Its positive inputs contain only
copies of `spec.k`, `verification.k`, and `dstoken-bin.k`; the other inputs are
distinct audit-authored mutation sources. Bundled semantics were not copied or
uploaded.

Final SHA-256 checksums of the frozen candidate files are:

```text
eb1dbf5f7c3e7e875b5bac50baca4513a7dc0de573afe94f86c494d109c08893  /app/output/spec.k
ce17116341d12b53b73f3647b5ca0d47d4ed585e616f17da1fd7ba82aaa5c958  /app/output/verification.k
7517f1cc63f9f3ac2cbdc4d5d28823f7e7d6fe663e6ab63fc1437d870b4d52d3  /app/output/dstoken-bin.k
5699524fc13b07d9859ba3211de6a5bad5981ba775587d5ac89af7630dbfb674  /app/output/SCOPE.md
7a87e2809e485ade2b837f8c3ce443a5ea1356ad5c3417148405da33b8aa8c2a  /app/output/prove.sh
bf0c92c2f49ef6ffa855c6aa5e955b7558dcdb527f83116e8d83dfcc3a0ad2ba  /app/output/audits/spec-audit-1.md
```

## Clean-room proof reconstruction

Both source sets compiled before proving. The positive validation command was:

```sh
kprover validate --project /app --session c9daec22-c065-4961-a57f-e2633a3988cc --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k
```

It exited 0. Task `5a11bbd3-bbee-4ae7-b10d-68f24ca8a77a` completed with
`valid: true`; the final `kprove` tool exit was 0.

The success claim was replayed alone, without a depth bound or trusted claim:

```sh
kprover prove --project /app --session c9daec22-c065-4961-a57f-e2633a3988cc --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k --claim SPEC.totalSupply-success
```

Shell and final K exit: 0. Task
`ab5cd61b-0ac6-4dcd-9432-16f8a90e0b79` completed with
`outcome: proved` and `residual: null`. Actual stdout was:

```text
PROOF PASSED: SPEC.totalSupply-success
```

The nonzero-value claim was replayed alone under the same controls:

```sh
kprover prove --project /app --session c9daec22-c065-4961-a57f-e2633a3988cc --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k --claim SPEC.totalSupply-nonzero-value-reverts
```

Shell and final K exit: 0. Task
`4e623e8b-9f3f-4925-aa9e-38b3bd0086d6` completed with
`outcome: proved` and `residual: null`. Actual stdout was:

```text
PROOF PASSED: SPEC.totalSupply-nonzero-value-reverts
```

The KEVM adapter prints `PROOF PASSED` rather than a literal `#Top` term. The
typed `kprover prove` contract defines `outcome: proved` as closure with a
`#Top` KAST; the null residual, final exit 0, task status, and unmodified stdout
and stderr are preserved together in `proof-001/result.json` and
`proof-002/result.json` under the audit evidence tree.

## Rebuilt proof-extension inventory

`verification.k` defines an empty `VERIFICATION-SUMMARIES` body apart from
importing `DSTOKEN-BIN`, then imports that module together with bundled `EDSL`
and bundled `LEMMAS`. It adds no candidate summary, simplification, concrete or
priority rule, ordinary operational rewrite, totality axiom, auxiliary claim,
or opaque result. This is the same summaries module approved by the spec audit.

There is one candidate extension, considered together with its constructor
syntax:

- **Extension:** `syntax Contract ::= "DSTOKEN" [symbol(DSTOKEN)]` and the
  ground rule `#binRuntime(DSTOKEN) => #parseByteStack("0x...")`.
- **Class:** definitional summary.
- **Semantic role:** names the exact runtime byte string; it does not replace
  any opcode, dispatcher, body, return, or continuation execution.
- **Domain and coverage:** the single ground `DSTOKEN` case. Every candidate
  use is that case. There is no recursion, guard, overlap, `owise`, priority,
  totality attribute, or competing candidate equation.
- **Matched context:** the pure term `#binRuntime(DSTOKEN)` only. It matches no
  `<k>` continuation, stack, binding, control, account, or other state cell.
- **Justification scope and containment:** the extracted hex payload equals all
  6,955 bytes of `/app/contract.bin`; the comparison exited 0 and both hash to
  `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`.
- **State footprint:** none. The value becomes the `<program>` bytes consumed
  by fixed EVM execution.
- **Value influence:** selects the complete executable image for both target
  claims. It does not independently choose the branch, result, status, storage,
  exception, or continuation.
- **Dependents:** both target claims.
- **Validation:** byte identity, clean-room positive proofs, the A5 mutation,
  and the body-sensitivity mutation described below.

There are no candidate operational bridges, derived lemmas, trusted primitives,
fresh opaque values, or newly summarized result-bearing values. Consequently
the operational-bridge context and opposite-interpretation procedures have no
candidate instance to test. Bundled `EDSL`, `EVM-OPTIMIZATIONS`, and `LEMMAS`
are part of the immutable selected semantics and are recorded in the trust
boundary, not misclassified as candidate proof-local extensions.

## Gate A — real-program soundness: PASS

### A1 and program pinning

Each claim starts fixed execution at `<k> #execute`, program counter 0, empty
stack and memory, and sets `<program>` to `#binRuntime(DSTOKEN)`. The byte
identity check therefore pins the term actually executed, not an unused source
file. The image contains selector `18 16 0d dd` dispatching to `0x01fb`, the
nonpayable `CALLVALUE; ISZERO; ...; REVERT(0,0)` guard there, and the body at
`0x0957`, `JUMPDEST; PUSH1 0; DUP1; SLOAD; ...`.

The audit-only body mutation changed exactly byte offset `0x959` from `00` to
`01`, changing the implemented load from slot 0 to slot 1 while leaving the
claim unchanged. After relocating the sources to root-level inputs, validation
task `b5cb4fd9-344b-421d-bd56-647cc4d302e6` returned `valid: true`, exit 0.
The unbounded command was:

```sh
kprover prove --project /app --session c9daec22-c065-4961-a57f-e2633a3988cc --semantics evm --spec inputs/spec-body-mutated.k --spec-module SPEC --verification inputs/verification-body-mutated.k --verification-module VERIFICATION --source inputs/dstoken-bin-body-mutated.k --claim SPEC.totalSupply-success
```

It exited 1. Task `52008ac3-6228-4e80-97ff-dc21c6d463a9` completed with
`outcome: notProved`. Actual failure output includes:

```text
PROOF FAILED: SPEC.totalSupply-success
1 Failure nodes. (0 pending and 1 failing)
...
OUTPUT_CELL: #buf ( 32 , #lookup ( STORAGE:Map , 1 #Implies 0 ) )
Path condition:
  #Top
```

For example, address 0 and storage with slot 0 equal to 0 and slot 1 equal to 1
is a ground witness distinguishing the original and mutated programs. This
confirms body sensitivity of the exact term under proof.

### A2–A4

There is no candidate operational bridge and therefore no skipped state or
control footprint. The dispatcher, binding, argument-free canonical calldata,
nonpayable check, `SLOAD`, memory write, `RETURN`/`REVERT`, and halt all execute
under the pinned fixed semantics. The only candidate equation is the truthful
ground byte constant, with complete coverage for its uses and no overlap.

The success postcondition constrains status to `EVMC_SUCCESS` and output to the
32-byte buffer of fixed-semantics `#lookup(STORAGE, 0)`. The unchanged
`<storage> STORAGE </storage>` term preserves the whole map. The nonzero-value
postcondition constrains status to `EVMC_REVERT`; its unchanged `.Bytes` output
and `_STORAGE` storage terms require empty output and whole-map preservation.
Existential stack, memory, memory-use, and PC values cannot satisfy either
observable result constraint by themselves.

### A5 non-vacuity

The audit-authored `spec-false.k` changes only the success output to:

```k
<output> .Bytes => #buf(32, #lookup(STORAGE, 0) +Int 1) </output>
```

A satisfiable witness is `ACCT = 0` and `STORAGE = .Map`: the real result is
`#buf(32, 0)`, while the mutation requires `#buf(32, 1)`. Mutation validation
task `dce46b69-b159-4c73-a647-3b9119227ad6` was valid with exit 0. The proof
command was:

```sh
kprover prove --project /app --session c9daec22-c065-4961-a57f-e2633a3988cc --semantics evm --spec inputs/spec-false.k --spec-module SPEC-FALSE --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k --claim SPEC-FALSE.totalSupply-success-false-slot0-plus-one
```

It exited 1. Task `7b946812-c2a2-4fc2-8312-a00985f733a8` completed with
`outcome: notProved`. Actual failure output includes:

```text
PROOF FAILED: SPEC-FALSE.totalSupply-success-false-slot0-plus-one
1 Failure nodes. (0 pending and 1 failing)
...
OUTPUT_CELL: #buf ( 32 , #lookup ( STORAGE:Map , 0 ) #Implies #lookup ( STORAGE:Map , 0 ) +Int 1 )
Path condition:
  #Top
```

This is a semantic result mismatch on a reachable claim, not a parser error,
timeout, or unreachable precondition.

## Residual Gate B — intent adequacy: PASS

- **B1:** The exact proven claims retain the approved domain: all 160-bit
  executing addresses and symbolic EVM storage maps for zero call value, plus
  every nonzero uint256 call value for the revert case. There is no size bound,
  concrete storage restriction, trusted claim, depth bound, dropped target
  claim, or strengthened proof-time `requires` clause.
- **B2:** The theorem is about direct runtime execution under the pinned
  `SHANGHAI` EVM model with gas accounting disabled. The functional paths use
  no fork-sensitive opcode affecting the result. Exact gas and out-of-gas
  behavior are explicitly excluded rather than silently modeled. The fixed
  semantics, including its ABI helper and EVM word/storage operations, is a
  named trust boundary.
- **B3:** No candidate summary stands between execution and the requested
  result. Fixed execution itself produces the slot-0 value or the revert.
- **B4:** `contract.sol` declares `_supply` first in `DSTokenBase` and returns
  it from `totalSupply`; the supplied runtime body loads slot 0. The theorem
  deliberately selects the supplied runtime image and makes no unproved claim
  that recompiling the source reproduces it.

The proof used the exact spec approved by `spec-audit-1.md` and added no
equation that shifted summary meaning. Proving did not narrow the theorem.

## Gate C — trust and evidence auditability: PASS

### Trust ledger

| Assumption or boundary | Effect | Dependents | Evidence/status |
|---|---|---|---|
| Immutable `evm` semantics, bundled EDSL/optimizations/lemmas, and ABI helper at `4f4c3843076c` correctly model the selected EVM execution | Value, control, storage, status, and termination | Both claims and both sensitivity checks | Exact server pin independently confirmed; definition IDs and commit are in every result JSON. This remains foundational semantics trust, not a candidate extension. |
| K/KEVM compilation, Kore execution, SMT reasoning, and the remote Prover report closure soundly | Formal proof result | Both claims | Typed completed tasks, final tool exits, stdout, stderr, and residual fields are preserved. |
| `/app/contract.bin` is the runtime selected by the task | Program identity | Both claims | Exact 6,955-byte equality to the candidate constant and SHA-256 identity. No source-compilation equivalence is claimed. |

No claim was accepted with `--trusted`. There is no candidate opaque primitive
or empirical value oracle. No differential test is claimed as universal proof.
The byte comparison is exact artifact identity; the proof and body mutations
are formal sensitivity checks.

### Evidence preservation

All clean-room sources and unmodified validation/proof `result.json` files are
under `/app/output/evidence/audit/session-c9daec22-c065-4961-a57f-e2633a3988cc/`.
Supplied artifacts are snapshotted under `/app/output/evidence/audit/artifacts/`.
`/app/output/evidence/audit/README.md` gives hashes, byte windows, task IDs, and
the evidence map.

The first body-mutation validation used subdirectory-local sources and failed
before any K tool ran because the server resolved the bundled import as missing
`body-mutation/edsl.md`. Command:

```sh
kprover validate --project /app --session c9daec22-c065-4961-a57f-e2633a3988cc --semantics evm --spec inputs/body-mutation/spec.k --spec-module SPEC --verification inputs/body-mutation/verification.k --verification-module VERIFICATION --source inputs/body-mutation/dstoken-bin.k --claim SPEC.totalSupply-success
```

It exited 1; task `d70f75fe-d0f4-43fb-8241-93c7acdd7057` reported
`DEFINITION_PREPARATION_FAILED`. Relocating the same mutation to distinct
root-level input names fixed only that path issue; validation-004 and proof-004
are the operative evidence. This failed instrument attempt does not count as a
mutation result and remains visible.

Read-only inspection used `sha256sum`, `test`, `od`, `stat`, `nl`, `sed`,
`find`, and `rg`; the material identity and byte-window commands exited 0.
`kprover health`, `kprover semantics`, `kprover semantics fetch evm`, both
session-show commands, and all help queries exited 0. Optional local `jq` and
`ps` commands were unavailable (127) and were replaced by `sed` and retained
kprover session/evidence inspection; they did not affect a submission or gate.
An attempted display of the fetch response's nominal `semantics.k` entry path
exited 2 because that file is absent from the source archive; inspection used
the returned source directory's actual `edsl.md`, `evm.md`, `evm-types.md`,
`optimizations.md`, and `lemmas/lemmas.k`. The expected `cmp -l` difference for
the body mutation exited 1 and printed its sole differing character. All other
commands material to the verdict and all copy/evidence commands exited 0.

## Excluded behavior

The validated theorem does not cover malformed, short, trailing noncanonical,
or differently selected calldata; other DSToken functions; constructor or
deployment execution; exact gas cost or out-of-gas behavior; transaction-level
rollback/wrapping; recompilation equivalence between Solidity and the supplied
runtime; or final stack, memory, memory high-water mark, and PC values. These
are explicit scope exclusions and do not narrow the requested successful
zero-value and unsuccessful nonzero-value canonical calls.

VERDICT: PASS
REASON: VALIDATED: both symbolic canonical-call claims close under the pinned runtime and semantics, the theory contains no unsound candidate extension, independent result and body mutations fail meaningfully, and Gates A, B, and C pass.
