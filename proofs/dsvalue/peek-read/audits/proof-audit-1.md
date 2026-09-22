# DSValue proof audit

## Artifacts and reconstruction

Reviewed the frozen `spec.k`, `verification.k`, `SCOPE.md`, `prove.sh`,
`audits/spec-audit-1.md`, supplied program bytes and Solidity text, both RV
claims and their local dependencies, construction session metadata, and the
pinned semantics. No constructor report was used. Original and audit input
SHA-256 inventories are in `../logs/evidence/audit/input-hashes.json` and
`../logs/evidence/audit/audit-input-hashes.json`.

The audit used a separate session `2c58a1ff-a790-457f-8840-7959eb7f879f` with only the selected proof files
uploaded per task. The semantics repository and revision independently match
construction: `nlp-research-rosu/semantics-evm`, `4f4c3843076c`.
The unchanged 2,874-byte runtime matches both original and reference exactly.
The three local helper equations were inspected individually: an exact runtime
literal, the slot-1 byte-20 projection, and the exact error payload. Each is a
nonrecursive definitional summary. There are no local operational bridges,
custom simplification rules, opaque result oracles, or trusted claims.

## Commands and terminal results

The following operations each ran once with unchanged configured limits:

| Check | Task ID | Result | Exit |
|---|---|---|---|
| validation-positive | `ec7080c3-ddfa-48a3-adb5-4849da86cc9d` | valid=true | 0 |
| proof-positive | `f3ae02fa-5eb5-441e-8491-f0665ecec69c` | proved | 0 |
| validation-context | `ac0bb3b7-ab3c-47c4-b468-b3bcff42c310` | valid=true | 0 |
| validation-witnesses | `9b531199-14a5-413c-bb2e-4245e8ec549b` | valid=true | 0 |
| proof-context | `47fa255e-65a4-4381-8e47-69106697616e` | proved | 0 |
| proof-witnesses | `59ca5dfe-5e20-429e-9dd9-67654e549965` | proved | 0 |
| validation-false | `79cf5bc4-e7b6-4d67-9f8e-710e493fb4f2` | valid=true | 0 |
| proof-false | `9b927c53-76e5-44cc-8991-52d213b45e38` | notProved | 1 |
| validation-body | `641dd7a4-1a38-48d7-ad7b-0edf4b94e0d3` | valid=true | 0 |
| proof-body | `cac891d0-367e-4f40-9b31-adece3d46a96` | notProved | 1 |

Every exact client command appears in `../PROOF.md` and in
`../logs/evidence/audit/evidence-index.json`, alongside task IDs, exit codes and
hashes of retained raw evidence. Session creation, pin inspection and semantics
fetch are recorded by `session-start.json`, `semantics-fetch.json` and the
metadata in the indexed terminal results. Exact supporting invocations and
local preparation diagnostics are retained in
`../logs/evidence/audit/supporting-command-record.json` and
`../logs/evidence/audit/local-preparation-notes.json`. The supporting command
`python3 audit-work/inspect-inputs.py` exited 0 and verified frozen inputs,
runtime identity and one independently reconstructed ABI error payload.
`python3 audit-work/collect-evidence.py` extracts logs without changing the
original evidence. No bounded proof or assumed claim was used.

The typed `proved` outcome, null residual, exit 0 and explicit per-claim
`PROOF PASSED` lines are the EVM backend's closure evidence. This wrapper does
not expose a literal `#Top` KAST; the report quotes its actual outputs.

## Gate A: PASS

Program identity is pinned by exact bytes and SHA-256. The five source claims
execute the program from PC 0. No summary skips its body. Totality and coverage
hold for all three local equations; the lookup's normalization makes the packed
byte projection well-defined for every storage map. Each has exactly one
unconditional equation, so no overlap or priority ambiguity arises.

The six independently authored ground-input claims close, covering each target
path with valid addresses and ordinary storage. Zero/one has states return
different observable outcomes. The successful-read witness uses slot 1 = 2^160,
slot 2 = 42, no calldata suffix, value 0, account 100, caller 101, static false,
and gas metadata 10000. Its precondition is satisfiable by an account with the runtime code, this
storage and ordinary empty/zero ancillary state. The rejection witnesses similarly use
has = 0 or call value 1. All final output/status constraints are substantive.

The false-postcondition artifact changes the successful-read output to ABI word
43 while retaining storage value 42. The body-sensitivity artifact changes
runtime byte 1415 (0x587) from 0x02 to 0x03, making the helper load slot 3 while
the postcondition still demands slot 2. Storage 2 = 42 and 3 = 43 makes that a
material executed-body change. Both mutations compile and terminate with a
stuck residual. Neither parser errors nor timeouts count as evidence.
The candidate's runtime and claims were not repaired or changed.

### False-postcondition check

Task `9b927c53-76e5-44cc-8991-52d213b45e38` returned `notProved`, exit 1.
The exact artifact is retained in the audit session inputs and hash manifest.
Full residual and logs: `../logs/evidence/audit/session-2c58a1ff-a790-457f-8840-7959eb7f879f/proof-004/result.json`,
`../logs/evidence/audit/proof-false.stdout.log`, and
`../logs/evidence/audit/proof-false.backend.stderr.log`. The structured residual field is null;
the meaningful failing-cell residual is in the raw stdout:

```text
PROOF FAILED: FALSE-POST.read-wrong-result
1 Failure nodes. (0 pending and 1 failing)

Failing nodes:

  Node id: 3
  Failure reason:
    Matching failed.
    The following cells failed matching individually (antecedent #Implies consequent):
    OUTPUT_CELL: b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00*" #Implies b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00+"
  Path condition:
    #Top
```

### Body-sensitivity check

Task `cac891d0-367e-4f40-9b31-adece3d46a96` returned `notProved`, exit 1.
The exact artifact is retained in the audit session inputs and hash manifest.
Full residual and logs: `../logs/evidence/audit/session-2c58a1ff-a790-457f-8840-7959eb7f879f/proof-005/result.json`,
`../logs/evidence/audit/proof-body.stdout.log`, and
`../logs/evidence/audit/proof-body.backend.stderr.log`. The structured residual field is null;
the meaningful failing-cell residual is in the raw stdout:

```text
PROOF FAILED: BODY-CHECK.read-body-mutated
1 Failure nodes. (0 pending and 1 failing)

Failing nodes:

  Node id: 3
  Failure reason:
    Matching failed.
    The following cells failed matching individually (antecedent #Implies consequent):
    OUTPUT_CELL: b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00+" #Implies b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00*"
  Path condition:
    #Top
```


## Gate B: PASS

The two retained RV success properties match the proved observable results,
calldata bound, ISTANBUL fork, infinite-gas model, read gas decrement and storage
frame. Candidate symbolic storage contains the reference's packed Owner/Ok
states; for a ranged Owner and Ok in {0,1}, the candidate byte projection and
normalization equal Ok, and its slot-2 lookup equals reference Value.

The candidate's canonical initial output/status and empty continuation were
investigated, rather than classified as missing behavior based on syntax.
RETURN/REVERT and `#end` overwrite those initial values. A separate symbolic
audit proof, task `47fa255e-65a4-4381-8e47-69106697616e`, also closes peek and successful read with
arbitrary initial output, arbitrary initial status and arbitrary K continuation.
Thus the independent evidence covers the reference entry context without
modifying the frozen candidate. This probe is a universal claim, not a finite
substitute for the reference domain.

The candidate's storage and unaffected cell frames are at least as strong as
the reference. Its extra no-value/nonpayable rejection cases are additional
results; they are not credited as substitutes for a missing reference claim.
No missing reference scope was identified within the stated model assumptions.

## Gate C: PASS

The proof is conditional on the pinned EVM rules, bundled lemmas and
optimizations, builtin arithmetic/byte/ABI operations, and the K/KEVM/Prover
backend. These named dependencies and affected claims are ledgered in
`../PROOF.md`. The runtime is the supplied bytecode; source compilation is not
claimed. Reference meaning is compared from its actual saved claims and helper
rules; original RV proof execution logs were not supplied and no independent
baseline timing or historical success is inferred.

All positive and negative inputs, hashes, command arguments, tool exit codes,
terminal responses and logs are retained. The independent finite ABI layout
check has one input and zero mismatches. The witnesses and mutation outcomes
are finite checks, clearly separated from the general symbolic theorems.
The candidate inventory contains no abstraction justified only by tests.

## Findings

No unsound extension, vacuous theorem, missing reference behavior or unrecorded
material assumption was found. The apparent entry-context restriction was
resolved by the independent symbolic probe. Finite-gas sufficiency, transaction
setup/finalization, other forks/selectors, mutating DSValue methods and Solidity
compilation remain outside the theorem, as described in `../PROOF.md`.

VERDICT: PASS
REASON: VALIDATED; all gates pass and the independent context proof establishes the full supplied RV peek/read properties within the pinned-model trust boundary.
