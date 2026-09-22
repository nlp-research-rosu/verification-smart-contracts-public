# Independent proof audit

The twelve candidate claims pass a fresh, unfiltered replay in audit session
`1780f457-da0a-48bc-b9fe-eaf832efe9fb`. Gates A, B, and C pass for the stated
functional model.

## Artifacts and reconstruction

Examined `../spec.k`, `../verification.k`, `../dstoken-bin.k`, `../SCOPE.md`,
`../prove.sh`, approved spec audits 4 and 3, the original Solidity source and
runtime binary, and all seven `transfer-*.k` references with their imports
and README. No constructor report was used. Only the three proof sources
were copied for the positive replay; controls have distinct source files.
Candidate proof sources, `SCOPE.md`, and `prove.sh` were not edited.

The audit and construction pins independently agree on `evm`, repository
`https://github.com/nlp-research-rosu/semantics-evm`, revision
`4f4c3843076cfa7c30b7fbffa731f3346cf379bb` (service ID `4f4c3843076c`).
The full commit was independently resolved. The runtime is 6,955 bytes,
SHA-256 `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`.
All 21 runtime constants in the seven references match it exactly.

[Complete source inventory](../logs/evidence/audit/independent-inventory.json) and
[static review](../logs/evidence/audit/static-review.md) record the inputs, rule
classification, guards, framing, program route, trust boundary, and
per-reference implication. The proof contains one local definitional
constant equation and twelve proved claims; it adds no operational bridge,
opaque program result, trusted claim, simplification, or priority rule.

## Commands and actual results

[Exact client commands and exit statuses](../logs/evidence/audit/commands.md) and
[task ledger](../logs/evidence/audit/task-ledger.json) preserve every accepted
validation and proof, including the failed control preparation.
Each ledger entry links the complete downloaded stdout, stderr, and
server response. Client wall times include polling and, for the early
witness-validation command, waiting on the session lock.

| Operation | Task ID | Typed result | CLI / K exits | Execution / total seconds |
|---|---|---|---|---|
| replay-validation | `4bff38cf-6ae2-4e9d-88e9-2e955c893b31` | valid | 0 / 0 | 27.549 / 32.273 |
| replay | `487c0300-1608-4ca7-a68e-f0a7cc13e39f` | proved | 0 / 0 | 1696.355 / 1701.435 |
| witness-validation | `f03306ab-d5e7-45ae-aeea-8b29db7379f0` | valid | 0 / 0 | 27.304 / 32.106 |
| witness | `fca12717-e5a1-401a-89f2-ee935a1a712b` | proved | 0 / 0 | 162.643 / 167.500 |
| false-validation | `a08038f3-8dbd-4018-b444-0864254d49ad` | valid | 0 / 0 | 25.586 / 30.332 |
| false | `a6f79d35-ae0f-425d-89e3-5f7f871512af` | notProved | 1 / 1 | 168.686 / 173.127 |
| body-validation | `80175f9c-91a2-486a-9ec4-39e52bc5e5a6` | preparation error | 1 / not run | 0.647 / 5.577 |
| body-root-validation | `a13ee45e-2af9-4b69-9e88-80646110ae2f` | valid | 0 / 0,0 | 87.113 / 92.249 |
| body | `e7de0ffb-acbe-4f90-b592-edbdab05c743` | notProved | 1 / 1 | 168.505 / 173.304 |

The positive replay reports `proved`, a null structured residual, and
K/CLI exit 0. Its actual stdout contains these twelve labels:

```text
PROOF PASSED: SPEC.raw-transfer-failure-insufficient-balance
PROOF PASSED: SPEC.transfer-success-distinct
PROOF PASSED: SPEC.transfer-failure-insufficient-balance
PROOF PASSED: SPEC.raw-transfer-failure-stopped
PROOF PASSED: SPEC.transfer-success-same-slot
PROOF PASSED: SPEC.raw-transfer-failure-overflow
PROOF PASSED: SPEC.transfer-failure-nonpayable
PROOF PASSED: SPEC.transfer-failure-stopped
PROOF PASSED: SPEC.transfer-failure-overflow
PROOF PASSED: SPEC.raw-transfer-failure-nonpayable
PROOF PASSED: SPEC.raw-transfer-success-same-slot
PROOF PASSED: SPEC.raw-transfer-success-distinct
```

The service returned these labels rather than a raw `#Top` serialization.
No missing `#Top` artifact is fabricated or attributed to the backend.

## Gate A — PASS

The original runtime executes from PC 0. All program-defined transfer,
modifier, arithmetic, event, and return instructions execute under the
fixed semantics. The enclosing-call claims use fixed snapshot and return
operations for rollback. The sole local bytecode equation has a singleton
match domain, one literal result, no recursion, and no overlapping local
equation. Its bytes were checked independently. The fixed bundled EDSL,
optimizations, and lemmas remain explicit trusted semantics, not newly
proved local extensions.

The independently authored witness has token address 0, source and
destination address 1, amount 3, source balance 7, stopped word 0, and empty
logs. Its isolated one-claim proof returns ABI word 1 and preserves the
self-transfer balance. Its typed result is `proved`, null residual, exit 0.

The false-postcondition control keeps that runtime and prestate but
requires ABI word 2. It is `notProved`, exit 1, with zero pending nodes and
one failed matching node: `OUTPUT_CELL` contains actual ABI word **1**
against required word **2**. This is a semantic rejection, not a timeout,
syntax failure, or unexercised branch.

The body control changes only runtime byte `0x1af7` (decimal 6903), from
`01` to `00`, changing the transfer body's `PUSH1 true` to `PUSH1 false`
after its Transfer event. The claim still requires ABI word 1. It is
`notProved`, exit 1, with the actual output word **0** failing to match
required word **1**. The mutated runtime has a different compiled
definition ID and is the program term actually executed.

Both structured negative residual fields are null, but the retained stdout
contains the full matching residual. Their printed `#Top` is the ground
path condition inside the failure report, not a successful proof result.
[Control evidence and parsed mismatches](../logs/evidence/audit/negative-check-review.json)
record the exact cells and outcomes.

The first body-control validation failed before K ran because nested
imports sought `body/edsl.md`. Relocating the same control to root input
paths corrected that packaging problem. Only local require paths changed;
the runtime mutation and candidate were unchanged. The failed validation
is retained and is not counted as a negative check.

## Residual Gate B — PASS

All twelve approved claim families remain present. The current same-slot
postcondition has the approved two-write form and preserves the effective
balance; it preserves the literal map on the reference's explicit-entry
domain. No trusted claim, filter, depth limit, bounded input sample, or
stronger guard replaces the symbolic candidate theorem. The approved
baseline reports describe the accepted form but do not include a complete
historical source snapshot; adequacy was rechecked from the current inputs.

All seven reference requirements map to raw claims, sometimes by a union
of stopped, insufficient-balance, and overflow branches. These claims
include direct non-static execution at every 160-bit contract address.
The additional enclosing-call claims require `TOKEN > 8`; that restriction
is not applied to the raw reference comparison.

The comparison projects away gas/refund bookkeeping, normalizes reference
infinite `#gas(_)` to disabled gas accounting, and compares the shared
functional operations of Byzantium, Constantinople, and Istanbul on the
selected bytecode path. That path has no GAS, MSIZE, external call, or
fork-added opcode. Initial status/output are not read by that path; status
and successful output are overwritten, and failure reference outputs are
unconstrained. These are checked static normalizations, not a formal
cross-revision simulation theorem.

## Gate C — PASS

The trust ledger covers the pinned semantics and bundled rules, K compiler
and backend, SMT solver, cryptographic/bytes hooks, and faithful Prover
execution. No symbolic hash injectivity is assumed. The theorem targets
the supplied runtime; source-to-bytecode compilation equivalence was not
proved. All claimed proof and control artifacts, commands, exit statuses,
and timings exist. No independent external EVM differential test is
claimed. No upstream reference replay or timing is claimed or inferred.
Finite gas limits, malformed calldata, other methods, deployment, and a
complete outer Ethereum transaction are outside this theorem.

VERDICT: PASS
REASON: Gates A, B, and C pass; the scoped pinned-model result is VALIDATED.
