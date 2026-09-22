STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `HKG:transferFrom`

## What is proven

Under the pinned `evm` semantics at commit `4f4c3843076c`, the exact supplied
2,091-byte HKG runtime correctly implements `transferFrom` for every canonical
typed call in the formal entry configuration:

- A positive `VALUE` no greater than both `balances[FROM]` and
  `allowed[FROM][CALLER_ID]` returns ABI boolean true, performs the three
  sequential EVM-word storage updates, and emits exactly one indexed
  `Transfer(FROM,TO,VALUE)` log.
- `VALUE == 0`, insufficient source balance, or sufficient source balance but
  insufficient caller allowance returns ABI boolean false, leaves the complete
  contract storage unchanged, and emits no log.
- All four cases return with `EVMC_SUCCESS` and halt normally.

This conclusion is conditional on the trust boundary recorded below.

## Formal claim (from `spec.k`)

The proved `SPEC` module contains four symbolic reachability claims:

1. `SPEC.transferFrom-success`
2. `SPEC.transferFrom-fail-zero`
3. `SPEC.transferFrom-fail-balance`
4. `SPEC.transferFrom-fail-allowance`

Together their guards partition all 160-bit values of `ACCT`, `CALLER_ID`,
`FROM`, and `TO`, all uint256 `VALUE`s, and otherwise arbitrary symbolic HKG
storage for canonical `transferFrom(address,address,uint256)` calldata. Each
claim starts at `<k> #execute </k>`, PC 0, with
`<program> #binRuntime(HKG) </program>`, and reaches `#halt` while directly
constraining output, status, complete HKG storage, and complete log.

The success post-state states the bytecode's writes in execution order. This
covers aliasing such as `FROM == TO` and equality among computed storage keys;
there is no address-distinctness or hash-collision assumption. Final stack,
memory, PC, and memory-use counter are existential internal values after halt.

## Proof-extension inventory

The audit rebuilt this inventory from the files, not from construction notes.

| Extension | Class | Role and complete domain | Justification and dependents |
|---|---|---|---|
| `syntax Contract ::= "HKG"`; `#binRuntime(HKG) => <ground Bytes>` | Definitional summary | Names the exact supplied runtime for the sole ground constructor `HKG`. It matches no EVM cell, continuation, binding, state, or control context and replaces no opcode execution. | Literal reconstruction is 2,091 bytes and has the same SHA-256 as `/app/contract.bin`. All four claims depend on it. One nonrecursive, unguarded ground equation has no overlap and covers every local use. |
| `VERIFICATION-SUMMARIES` | No added extension | Imports the runtime constant and contains no equations, rewrites, totality declarations, claims, or opaque values. | It is unchanged from the approved specification baseline. |
| Bundled `LEMMAS` import | Immutable semantics dependency, not proof-local | Resolves from the pinned `evm` bundle; the clean room uploads no shadowing source. | Included in the pinned-semantics trust boundary; all four claims depend on it. |

There is no proof-local operational bridge, trusted primitive, fresh
result-bearing abstraction, opaque oracle, auxiliary claim, trusted claim,
priority rule, ordinary rewrite over EVM execution, or result-characterizing
lemma. Accordingly, no connection theorem or operational-continuation test is
required: no local extension displaces fixed-semantics execution.

## Exact commands and actual outputs

Audit session `2579e61c-a36a-4955-8f43-da6c9ce35ffb` was started separately
from construction session `b35c50df-236f-408a-864d-02f003f9759e`. Both report:

```text
id: evm
repo: https://github.com/nlp-research-rosu/semantics-evm
commit: 4f4c3843076c
```

### Source identity

```sh
sha256sum /app/contract.bin
perl -ne 'while (/\\x([0-9a-f]{2})/g) { print pack("H2", $1) }' \
  /app/output/hkg-bin-runtime.k | sha256sum
```

Exit 0. Actual output from both commands:

```text
71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73
```

The reconstructed literal and binary are both exactly 2,091 bytes. `cmp` of
each clean-room source against its candidate exited 0. `diff -qr` of the
independently fetched pinned source against `/app/semantics` exited 0 with no
output.

### Positive validation

```sh
kprover validate --project /app \
  --session 2579e61c-a36a-4955-8f43-da6c9ce35ffb \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/hkg-bin-runtime.k
```

Exit 0. Task `4341e9aa-f4d2-4b02-ae7c-295c81419e5f` completed with
`result.valid: true`; final tool `kprove` exited 0. Complete actual stdout and
stderr: [positive-validation-result.json](logs/evidence/audit/positive-validation-result.json).

### Unfiltered positive proof

```sh
kprover prove --project /app \
  --session 2579e61c-a36a-4955-8f43-da6c9ce35ffb \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/hkg-bin-runtime.k
```

No depth bound, trust option, inclusion filter, or exclusion filter was used.
Exit 0. Task `7c658e49-b3e2-498d-a8ea-cd6a41319767` completed with outcome
`proved`, null residual, and `kprove` exit 0. The client defines `proved` as
closure to raw `#Top`. Actual stdout:

```text
PROOF PASSED: SPEC.transferFrom-fail-allowance
PROOF PASSED: SPEC.transferFrom-fail-zero
PROOF PASSED: SPEC.transferFrom-fail-balance
PROOF PASSED: SPEC.transferFrom-success
```

Actual stderr:

```text
WARNING 2026-09-15 16:03:43,065 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

Complete typed result: [positive-proof-result.json](logs/evidence/audit/positive-proof-result.json).

### Fresh false-postcondition mutation

The distinct module [spec-mutation.k](logs/evidence/audit/spec-mutation.k)
keeps the success claim and executed bytecode unchanged but demands
`#buf(32, 0)` instead of `#buf(32, 1)`. A satisfiable witness is `VALUE=1`
with source balance `1` and caller allowance `1` (using in-range addresses and
otherwise consistent storage).

```sh
kprover validate --project /app \
  --session 2579e61c-a36a-4955-8f43-da6c9ce35ffb \
  --semantics evm \
  --spec inputs/spec-mutation.k --spec-module SPEC-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/hkg-bin-runtime.k \
  --claim SPEC-MUTATION.transferFrom-success-false-output
```

Exit 0. Task `4ce9476c-f8e4-4acc-ba2c-4d753833e50b` reported
`result.valid: true` and final `kprove` exit 0. Complete output:
[mutation-validation-result.json](logs/evidence/audit/mutation-validation-result.json).

```sh
kprover prove --project /app \
  --session 2579e61c-a36a-4955-8f43-da6c9ce35ffb \
  --semantics evm \
  --spec inputs/spec-mutation.k --spec-module SPEC-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/hkg-bin-runtime.k \
  --claim SPEC-MUTATION.transferFrom-success-false-output
```

Exit 1. Task `abf25e0f-c41d-4577-85d2-55899348a2d7` completed with outcome
`notProved`. Actual failure output identifies one failing node, path condition
`#Top`, and this unmet result constraint:

```text
OUTPUT_CELL: b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01" #Implies b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
```

Complete actual stdout and stderr:
[mutation-proof-result.json](logs/evidence/audit/mutation-proof-result.json).

The full command ledger and source hashes are in
[audit-manifest.md](logs/evidence/audit/audit-manifest.md).

## Per-gate results

- **Gate A — PASS.** The actual ground runtime executes under fixed EVM
  semantics. No bridge or abstraction replaces program execution. The only
  local equation is an exact, nonoverlapping runtime constant. The meaningful
  false result mutation fails on a satisfiable success path with the precise
  output mismatch.
- **Gate B — PASS.** The four unfiltered claims cover the complete stated typed
  canonical-call domain without stronger proof-time guards, dropped cases, or
  bounded unrolling. They directly state the source function's condition,
  sequential writes, event, and return behavior. All model and entry-condition
  boundaries are explicit.
- **Gate C — PASS.** Every assumption is named below. Client task IDs, commands,
  input scope, exit codes, typed results, stdout, stderr, source identity, and
  mutation evidence are retained. Formal, conditional, finite, and excluded
  statements are separated.

## Trust boundary

- The correctness of the immutable bundled `evm` model at repository commit
  `4f4c3843076c`, including `EDSL`, ABI helpers, hashed-location functions, and
  bundled `LEMMAS`. This affects value, control, state, and termination; every
  claim depends on it.
- The soundness of K 7.1.337, `kore-rpc`, its SMT reasoning, and the proof
  driver's interpretation of `#Top`; every formal closure conclusion depends
  on it.
- The choice of `/app/contract.bin` as the authoritative runtime. Exact
  embedding of that binary is checked, but no compiler-correctness theorem from
  `/app/contract.sol` to the binary is claimed. The Solidity source supplies
  intent, names, types, and storage layout.

There is no proof-local trusted primitive, assumed claim, program-derived
oracle, or unproved local connection theorem.

## Empirically supported facts

No differential test is used to claim universal equivalence. Mechanical finite
evidence consists of:

- exact length and SHA-256 equality between the embedded literal and supplied
  runtime binary;
- clean-room source equality and semantics-tree equality;
- the satisfiable false-output mutation, which demonstrates result sensitivity
  but does not replace the positive symbolic proof.

The universal transfer behavior over the formal domain comes from the four
symbolic `#Top` closures, not from finite testing.

## Excluded behavior

- Transaction-envelope validation, fee payment, block finalization, and exact
  gas or out-of-gas behavior; `<useGas>` is false.
- Short, overlong, malformed, or noncanonical calldata, fallback dispatch, and
  calls to other selectors.
- Nonzero `msg.value`, static-call mode, nested-call contexts, or a missing
  contract account.
- Other schedules or execution models beyond the pinned CANCUN EVM setup.
- Gas/refund accounting, access-list bookkeeping, touched-account bookkeeping,
  and other framed, unobserved cells.
- A compiler-correctness theorem relating the Solidity source to the supplied
  runtime, and broader ERC-20 properties involving functions other than this
  `transferFrom` call.
