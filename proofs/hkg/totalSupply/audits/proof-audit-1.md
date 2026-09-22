# KIT proof audit 1

## Audit boundary and artifacts

This audit did not read or use a constructor proof report. It reconstructed the
candidate from the frozen on-disk inputs in a new session and treated all prior
proof outcomes as untrusted.

Artifacts examined:

- `/app/output/spec.k`, SHA-256
  `a7c84e0a292efb41e4a1a5e23f94030cd6ac9b87b925bce4d52d229e4a28dd3e`
- `/app/output/verification.k`, SHA-256
  `00739fb2c3ab9af88f55ef7ec52ba3988b9f92d8f6259d0c6dc8ab4b4f606fce`
- `/app/output/SCOPE.md`, SHA-256
  `89470d655c3893cf4eda893d05b837c7679da83421367ec29d3c491b32b31859`
- `/app/output/prove.sh`, SHA-256
  `00021ec41c557dbe8ab994a44dbd9ed10bf80b5121402e3dee6b7ff62b6149f8`
- `/app/contract.bin`, 2,091 bytes, SHA-256
  `71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`
- `/app/contract.sol`, SHA-256
  `cee59f7cb8d3245e61fab5bb037753500cf71e19be40184acb1a8306dc05106b`
- approved residual-Gate-B baseline
  `/app/output/audits/spec-audit-3.md`, SHA-256
  `bb87385f6a87593fe266b6929371b6844bc6f239554cba2e6309616c013d00b4`
- `/app/output/evidence/bytecode-dispatch.md`

The frozen candidate hashes were rechecked after all audit mutations and were
unchanged.

## Semantics and clean-room reconstruction

`kprover health` exited 0 with `{"kVersion":"7.1.337","status":"ok"}`.
`kprover semantics` exited 0 and independently listed `evm` at repository
`https://github.com/nlp-research-rosu/semantics-evm`, revision
`4f4c3843076c`. The following command exited 0:

```sh
kprover session show --project /app 34aef060-d0b8-47bc-8577-d4fdb4c1f87e
```

It confirmed that the construction session was pinned to that same repository
and revision. No construction evidence directory was read.

The following command exited 0 and created independent audit session
`e84902e9-86da-44c9-9992-7f77eecf0043` with zero counters and the same pin:

```sh
kprover session start --project /app --semantics evm
```

Only `spec.k` and `verification.k` were copied to that session's `inputs/`.
Their hashes matched the frozen candidate. `kprover semantics fetch --project
/app evm` exited 0 and returned the same immutable revision for read-only
inspection; no bundled semantics was copied into the candidate or audit inputs.

### Candidate validation

This exact command exited 0:

```sh
kprover validate --project /app \
  --session e84902e9-86da-44c9-9992-7f77eecf0043 \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Task `408a256a-e444-44c1-b730-d2bd059f8bc8` completed with
`result.valid: true` and K exit 0. Its stdout is the actual `kore-exec ...
--module VERIFICATION --prove ... --spec-module SPEC ...` invocation retained
in `validation-001/result.json`. Its stderr contains only compiler warnings
that `?FINAL_STACK`, `?FINAL_MEMORY`, `?FINAL_PC`, `LOGS`, and `STORAGE` are
syntactically unused variables; there is no compile error.

### Positive proof

This unbounded command, with no trusted or excluded claim, exited 0:

```sh
kprover prove --project /app \
  --session e84902e9-86da-44c9-9992-7f77eecf0043 \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Typed terminal result:

```text
task.id: b4bfcdf2-e8d8-43d9-bd59-8a1a173b3e47
task.status: completed
task.result.outcome: proved
task.result.residual: null
task.toolRuns[-1].exitCode: 0
definitionId: 7_1_337-haskell-evm-4f4c3843076c-928d5ea5baba6e410c3482bb175c00506daf73d596a5da883cbfdeb8596f4913
```

Downloaded stdout, verbatim:

```text
PROOF PASSED: SPEC.totalSupply-always-reverts
```

Downloaded stderr, verbatim:

```text
WARNING 2026-09-15 10:05:48,607 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

The client contract classifies `outcome: proved` with null residual as closure
with `#Top`; this KEVM frontend renders that closed result as `PROOF PASSED` in
the downloaded raw stdout. Full evidence is retained at
`/app/.kprover/sessions/e84902e9-86da-44c9-9992-7f77eecf0043/proof-001/result.json`.

## Rebuilt proof-extension inventory

The exhaustive candidate scan found only the one claim declaration in
`spec.k`. `VERIFICATION-SUMMARIES` imports the pinned EDSL and has no contents;
`VERIFICATION` only imports `VERIFICATION-SUMMARIES`.

| Extension class | Candidate inventory | Consequence |
|---|---|---|
| Definitional summaries | None | No candidate equation, total function, guard, overlap, coverage, or descent obligation. |
| Derived lemmas or auxiliary claims | None | No claim is trusted or used as a circularity. |
| Operational bridges | None | No candidate rule preempts bytecode execution or changes binding, evaluation, continuation, control, or any cell. |
| Trusted primitives | None added by the candidate | `#parseByteStack`, `#computeValidJumpDests`, `#abiCallData`, EVM execution, and status codes are from the immutable selected semantics, not proof-local extensions. |

There are no proof-local imported modules beyond the two audited files. No
candidate edit was made to the approved empty `VERIFICATION-SUMMARIES` module.
There are no priority rules, ordinary rewrites, simplification/concrete rules,
totality attributes, opaque program-derived terms, or framed bridge contexts to
inventory. `ACCT_ID`, `CALL_VALUE`, `STORAGE`, and `LOGS` are symbolic inputs,
not opaque abstractions. The fresh final stack, memory, and program-counter
variables are explicit existential outputs that do not influence the status,
return data, storage, log, or postcondition.

## Gate A — real-program soundness: PASS

### A1 and program pinning

The entry claim executes `#execute` over a literal `#parseByteStack` program,
not a source file or summary. Both literal byte strings in `spec.k` have 4,182
hex digits. The originally published comparison in
`output/evidence/bytecode-dispatch.md` was reproduced exactly and exited 1,
because its `sed` command extracts both the `<program>` and `<jumpDests>`
literals and concatenates them. That documentation defect is not used as proof
evidence. This corrected exact comparison exited 0:

```sh
cmp -s /app/contract.bin <( \
  sed -n 's/.*#parseByteStack("\([0-9a-f]*\)").*/\1/p' /app/output/spec.k \
    | head -n 1 | tr -d '\n' \
    | perl -pe 's/([0-9a-f]{2})/chr(hex($1))/ge' \
)
```

The decoded literal hash was
`71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`,
identical to `/app/contract.bin`. The postcondition directly constrains halt,
`EVMC_REVERT`, empty output, unchanged storage, and unchanged logs.

Body sensitivity was tested in audit-only
`inputs/spec-body-mutation.k`: in both literal occurrences, byte `fd` at the
executed fallback sequence `5b600080fd5b3415` was changed to `00`, yielding
`5b600080005b3415` (`STOP` in place of `REVERT`). The module and label were
changed so the original claim was not selected. Validation command:

```sh
kprover validate --project /app \
  --session e84902e9-86da-44c9-9992-7f77eecf0043 \
  --semantics evm \
  --spec inputs/spec-body-mutation.k --spec-module SPEC-BODY-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION
```

It exited 0; task `8b4937f0-e64c-44ce-9284-9412799d3c99` was valid. The same
command with `prove` exited 1; task
`94208cdc-3ef0-41f0-841b-69fc59f2db71` completed with `notProved`, K exit 1.
Actual stdout was:

```text
PROOF FAILED: SPEC-BODY-MUTATION.mutated-fallback-still-reverts
1 Failure nodes. (0 pending and 1 failing)

Failing nodes:

  Node id: 3
  Failure reason:
    Matching failed.
    The following cells failed matching individually (antecedent #Implies consequent):
    STATUSCODE_CELL: EVMC_SUCCESS #Implies EVMC_REVERT
  Path condition:
    #Top

Join the Runtime Verification Discord server (https://discord.com/invite/CurfmXNtbN) or Telegram group (https://t.me/rv_kontrol) for support.
```

Its stderr recorded the non-booster warning and fail-fast termination for the
named mutation. This witness shows that a material change to the program term
the claim actually executes changes the reached result and invalidates the
claim.

### A2–A4

No proof-local operational bridge exists, so there is no skipped state
footprint, broader continuation, binding assumption, return/frame effect, or
result-bearing abstraction requiring a connection theorem or opposite
interpretation witness. The proved claim runs fixed bytecode semantics and
preserves the same symbolic `<storage>` and `<log>` while constraining the
status and empty output. There are no candidate equations or rules whose truth,
overlap, coverage, descent, priority, or totalization guard could fail.

### A5 non-vacuity

A concrete satisfiable pre-state is `ACCT_ID = 1`, `CALL_VALUE = 0`, empty
account storage, and empty pre-existing log; it satisfies both range guards.
The symbolic claim includes this witness and all other guarded states.

Audit-only `inputs/spec-mutation.k` retained the same literal bytecode,
precondition, and symbolic domain but changed the module to `SPEC-MUTATION`,
the label to `totalSupply-falsely-succeeds`, and exactly this postcondition:

```diff
- <statusCode> .StatusCode => EVMC_REVERT </statusCode>
+ <statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
```

This validation command exited 0, with valid task
`31a27d98-845d-49d6-8e70-c71f9bed9d5e`:

```sh
kprover validate --project /app \
  --session e84902e9-86da-44c9-9992-7f77eecf0043 \
  --semantics evm \
  --spec inputs/spec-mutation.k --spec-module SPEC-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION
```

This unbounded proof command exited 1:

```sh
kprover prove --project /app \
  --session e84902e9-86da-44c9-9992-7f77eecf0043 \
  --semantics evm \
  --spec inputs/spec-mutation.k --spec-module SPEC-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Task `be2728c1-5cf2-4b76-b5f8-0942fbc796ac` completed with `notProved` and K
exit 1. Actual stdout was:

```text
PROOF FAILED: SPEC-MUTATION.totalSupply-falsely-succeeds
1 Failure nodes. (0 pending and 1 failing)

Failing nodes:

  Node id: 3
  Failure reason:
    Matching failed.
    The following cells failed matching individually (antecedent #Implies consequent):
    STATUSCODE_CELL: EVMC_REVERT #Implies EVMC_SUCCESS
  Path condition:
    #Top

Join the Runtime Verification Discord server (https://discord.com/invite/CurfmXNtbN) or Telegram group (https://t.me/rv_kontrol) for support.
```

Its stderr recorded the non-booster warning and fail-fast termination for the
named mutation. This is a reached failing node with a satisfiable top path
condition and the exact unmet status condition, not a parser error, timeout, or
unreachable claim.

## Residual Gate B — intent adequacy: PASS

- **B1:** `totalSupply()` has no ABI arguments. The theorem ranges over all
  160-bit executing addresses and all 256-bit call values, and leaves storage
  and the pre-existing log symbolic. It does not strengthen the approved
  precondition, drop a claim, or bound symbolic execution. Canonical ABI
  calldata is the relevant operation domain.
- **B2:** The fixed model is the requested pinned EVM semantics. BYZANTIUM is
  the first selected schedule with opcode `0xfd` as `REVERT`; the reached path
  uses no later-fork opcode. Disabled gas and direct runtime entry are explicit
  model boundaries, not hidden theorem restrictions. The result does not make
  a claim about out-of-gas or transaction-wrapper effects.
- **B3:** There is no candidate summary-to-property bridge. The fixed EVM
  status, output, storage, and log are observed directly.
- **B4:** `rg -n 'totalSupply|function[[:space:]]+totalSupply'
  /app/contract.sol` exited 0 and printed only `14:    uint totalSupply;`.
  The first 128 runtime bytes contain the five dispatcher constants
  `095ea7b3`, `23b872dd`, `70a08231`, `a9059cbb`, and `dd62ed3e`; a full-runtime
  search for `18160ddd` exited 1. Bytes 109–113 are
  `5b 60 00 80 fd`. The symbolic fixed-semantics proof establishes that the
  canonical `totalSupply()` selector reaches that revert. Thus the supplied
  implementation has no successful ABI branch: the successful subset is empty
  and the unsuccessful subset is the full formal domain. This implementation
  discrepancy is reported rather than replaced by a nonexistent getter.

The proven theorem has the same claim, domain, and empty summary module as the
approved spec-audit baseline. Proving introduced no trusted claims, stronger
guards, filtering, bounded depth, or added equations.

## Gate C — trust and evidence auditability: PASS

### Trust ledger

| Assumption or boundary | Effect | Dependents | Evidence/status |
|---|---|---|---|
| Immutable bundled `evm@4f4c3843076c` definition and K/solver implementation are correct | Defines all EVM execution, ABI helper, control, status, and state behavior | The sole claim | Explicit foundational trust boundary; session pin and definition ID recorded. |
| `/app/contract.bin` is the target runtime supplied for verification | Selects the program being proved | The sole claim and source-level reading | Candidate literal equality was independently checked byte-for-byte. Recompilation from Solidity is not claimed. |
| Direct runtime entry, BYZANTIUM schedule, and disabled gas are the intended model | Excludes transaction-wrapper and out-of-gas effects | Interpretation of the sole claim | Explicit in `SCOPE.md` and in the formal cells; exclusions repeated below. |

There are no unproved candidate summaries, lemmas, operational bridges,
trusted claims, differential oracles, or program-derived opaque symbols.

### Evidence inventory and reproducibility

- Positive proof artifact: `proof-001/result.json`; exact command, full domain,
  task ID, typed outcome, exit code, stdout, and stderr are recorded above.
- False-postcondition artifact: `inputs/spec-mutation.k` and
  `proof-002/result.json`; exact mutation, witness, command, task result, and
  failed status match are recorded above.
- Body-sensitivity artifact: `inputs/spec-body-mutation.k` and
  `proof-003/result.json`; exact byte mutation, command, task result, and
  opposite reached status are recorded above.
- Source and bytecode scans: their input scope is the entire source or runtime,
  their oracle is literal text/byte equality, and their actual exit results are
  recorded above. These are finite artifact checks, not universal semantic
  evidence.
- `output/evidence/bytecode-dispatch.md` exists, but its published process-
  substitution command actually exits 1 because it decodes two concatenated
  copies of the runtime. The corrected single-literal command and actual exit 0
  are preserved above. This documentation defect does not support the proof and
  does not affect the independent exact comparison or fixed-semantics proof.

Formal, conditional, finite, and excluded conclusions are separated in this
audit and in `PROOF.md`.

## Per-gate result and final status

- Gate A: **PASS** — direct fixed-semantics proof, no proof extension, a
  discriminating false-status mutation, and a discriminating executed-body
  mutation.
- Gate B: **PASS** — the symbolic theorem matches the complete canonical-call
  behavior implemented by the supplied runtime, including the empty successful
  subset and universal unsuccessful subset.
- Gate C: **PASS** — all assumptions and actual evidence are ledgered; the one
  malformed pre-existing comparison command is exposed and replaced by an
  independently reproducible exact comparison.
- Final status: **VALIDATED**.

VERDICT: PASS
REASON: VALIDATED — all three gates pass for the symbolic fixed-semantics proof that every canonical totalSupply() call to the supplied runtime reverts with empty output and unchanged storage and logs.
