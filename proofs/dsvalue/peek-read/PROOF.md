STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `DSValue:peek() / read()`

The five DSValue peek/read claims close for the unchanged runtime under the
pinned EVM semantics. Independent audit evidence also establishes the broader
entry context used by the two RV reference claims. This is a theorem about
bytecode execution from the stated call state, conditional on the fixed
semantics and proof backend; it is not a finite-gas or whole-transaction proof.

## What is proven

The 2,874-byte runtime is identical in the supplied binary, candidate helper,
and RV runtime definition. Its SHA-256 is
`21c8127cb5702347f975ff7668975d24547bd1fe2cd0532443e2b5375dc98797`.
Execution starts at PC 0 with empty stack and memory, ISTANBUL gas accounting,
and infinite `#gas(VGAS)` with tracked cost metadata. The current account exists.
Calldata contains the canonical peek/read selector and any byte suffix of
length at most 1,250,000,000. Addresses and call value have their stated EVM
ranges; storage and the static flag are symbolic.

## Formal claim (from `spec.k`)

Write `V = #lookup(STORAGE, 2)` and
`H = (#lookup(STORAGE, 1) /Int 2^160) &Int 255`.

- `peek`, call value 0: success with two ABI words `(V, H != 0)`.
- `read-success`, call value 0 and `H != 0`: success with ABI word `V`,
  and final gas metadata `VGAS - 2043`.
- `read-revert`, call value 0 and `H = 0`: revert with `Error("haz-not")`.
- Each selector with positive call value: revert with empty output.

Every claim preserves the complete current-account storage map. Output and
status are constrained; final stack, memory, memory size and PC are existential.
Final gas is existential except for successful read. Other cells are framed.
The claims specify execution through the halt configuration, before any
surrounding transaction continuation runs.

## Proof-extension inventory

The inventory was rebuilt from `spec.k`, `verification.k`, their imports and
the pinned definitions. There are exactly three candidate-local equations.

| Extension | Class and domain | Role, footprint and justification | Dependents |
|---|---|---|---|
| `#dsValueRuntime` | Definitional summary; nullary, total | Expands to exactly the supplied runtime bytes; no execution is skipped and no cells are rewritten | All five claims |
| `#dsHasByte(Map)` | Definitional summary; every Map, total | Reads only the mathematical slot-1 lookup; fixed lookup normalizes integers modulo 2^256, returns zero for absent/noninteger entries, then division by positive 2^160 and masking select byte 20 | Peek, read success and read revert |
| `#hazNotRevert` | Definitional summary; nullary, total | Names a concrete 100-byte ABI error payload; independently reconstructed from offset, length and padded text | Read revert |

Each symbol has one unconditional, nonrecursive equation. Coverage is complete,
there are no pairwise overlaps, and neither division nor parsing is partial on
these inputs. No candidate-local operational bridge, trusted claim, priority
rule, auxiliary reachability claim, opaque result, or custom simplification
replaces execution. The five target claims start at `#execute` on the actual
runtime. They do not introduce an axiom about the program result.

`VERIFICATION` imports the unchanged `VERIFICATION-SUMMARIES` and bundled
`LEMMAS`; `EDSL` imports the pinned EVM optimizations. Those bundled rules are
part of the fixed semantics trust boundary, not new candidate extensions.
The candidate does not import its RV reference helper theory. The approved
specification and constructor input files match the frozen candidate bytes.

## Exact commands and actual outputs

The independent audit session is `2c58a1ff-a790-457f-8840-7959eb7f879f`, with semantics
`evm` from `nlp-research-rosu/semantics-evm` at `4f4c3843076c`.
The construction session is `70c7b8c6-5023-41b0-b803-fb2317fcfa33`.
The audit used the existing limits: 9,000 seconds per task, 20 proofs,
20 validations and 3 runs. No claim filters, trusted claims, depth bounds,
limit changes or replacement sessions were used.

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

The exact live invocations are recorded below. The session descriptors,
terminal response, task timing, input hashes and raw inline
stdout/stderr are retained in `logs/evidence/audit/`. The evidence index maps every
command to its original `result.json`; extracted logs preserve their content.

```sh
kprover validate --session 2c58a1ff-a790-457f-8840-7959eb7f879f --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION
```

```sh
kprover prove --session 2c58a1ff-a790-457f-8840-7959eb7f879f --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION
```

```sh
kprover validate --session 2c58a1ff-a790-457f-8840-7959eb7f879f --spec inputs/context-probe.k --spec-module CONTEXT-PROBE --verification inputs/verification.k --verification-module VERIFICATION
```

```sh
kprover validate --session 2c58a1ff-a790-457f-8840-7959eb7f879f --spec inputs/witnesses.k --spec-module WITNESSES --verification inputs/verification.k --verification-module VERIFICATION
```

```sh
kprover prove --session 2c58a1ff-a790-457f-8840-7959eb7f879f --spec inputs/context-probe.k --spec-module CONTEXT-PROBE --verification inputs/verification.k --verification-module VERIFICATION
```

```sh
kprover prove --session 2c58a1ff-a790-457f-8840-7959eb7f879f --spec inputs/witnesses.k --spec-module WITNESSES --verification inputs/verification.k --verification-module VERIFICATION
```

```sh
kprover validate --session 2c58a1ff-a790-457f-8840-7959eb7f879f --spec inputs/false-post.k --spec-module FALSE-POST --verification inputs/verification.k --verification-module VERIFICATION
```

```sh
kprover prove --session 2c58a1ff-a790-457f-8840-7959eb7f879f --spec inputs/false-post.k --spec-module FALSE-POST --verification inputs/verification.k --verification-module VERIFICATION
```

```sh
kprover validate --session 2c58a1ff-a790-457f-8840-7959eb7f879f --spec inputs/body-check.k --spec-module BODY-CHECK --verification inputs/verification-body.k --verification-module VERIFICATION
```

```sh
kprover prove --session 2c58a1ff-a790-457f-8840-7959eb7f879f --spec inputs/body-check.k --spec-module BODY-CHECK --verification inputs/verification-body.k --verification-module VERIFICATION
```

The frozen full-bundle replay's actual stdout is:

```text
PROOF PASSED: SPEC.peek
PROOF PASSED: SPEC.peek-nonpayable-revert
PROOF PASSED: SPEC.read-success
PROOF PASSED: SPEC.read-revert
PROOF PASSED: SPEC.read-nonpayable-revert
```

The reference-context proof's actual stdout is:

```text
PROOF PASSED: CONTEXT-PROBE.peek
PROOF PASSED: CONTEXT-PROBE.read-success
```

Positive tasks report `outcome=proved`, `residual=null`, and K exit 0.
The EVM wrapper emits `PROOF PASSED` per claim rather than a literal `#Top`
KAST. The typed Prover `proved` outcome is its documented closure result;
no raw `#Top` text is asserted or manufactured. The retained stderr warning
about ignoring `--equation-max-local-steps` for a non-booster server did not
change these terminal results.

## Per-gate results

**Gate A: PASS.** The runtime hash pins the executed program. All five frozen
claims close independently without added execution rules. Six ground-input
witnesses cover peek with has 0 and 1, successful read, missing-value read, and
both nonpayable rejections. They use account 100, caller 101, static false,
empty suffix, initial gas metadata 10000, and storage either empty or containing
slot 1 = 2^160 and slot 2 = 42; positive call value is 1 where required.
The unspecified world frame can be instantiated with the current account code
equal to the runtime and ordinary empty/zero ancillary cells, so these are
realizable call states.

The fresh false-postcondition mutation demands ABI word 43 from successful
read with slot 2 = 42. It was validated and rejected as `notProved`, with a
stuck residual rather than a parser error, timeout or depth limit.
The separate body mutation changes exactly runtime byte offset 1415 (0x587)
from 0x02 to 0x03, changing the peek helper's SLOAD operand from slot 2 to slot 3.
With slot 2 = 42 and slot 3 = 43, the retained original postcondition fails.
The mutated runtime is used both by `<program>` and jump-destination
computation. These mutations exist only in audit inputs; the candidate is frozen.
Residual details and raw logs are recorded in the audit verdict artifact.

**Gate B: PASS for the specified RV peek/read properties.** The calldata bound,
ABI value domain, storage mapping, schedule and successful-read gas cost agree.
For reference storage `slot1 = Owner + Ok*2^160`, `0 <= Owner < 2^160` and
`Ok` in {0,1}, candidate `H = Ok` and Boolean normalization returns `Ok`.
Reference `Value` equals the same slot-2 lookup. The candidate's arbitrary map
covers this domain and also noncanonical has bytes and missing slots.
The reference's additional account, origin, timestamp, balance, chain-ID and
original-storage restrictions specialize otherwise symbolic/framed cells.

The candidate fixes initial output/status and uses no trailing K continuation.
These syntactic restrictions do not change the requested behaviors: fixed
RETURN/REVERT overwrites output, fixed `#end` overwrites status, and the
independent symbolic task `47fa255e-65a4-4381-8e47-69106697616e` proves both reference outcomes with
arbitrary initial output, arbitrary initial status and arbitrary preserved K
continuation. This is separate audit evidence, not an edit to the candidate.

Current storage, balances, code, original storage, nonce, other accounts,
call stack, block/network state and unaffected substate are preserved by the
frame. The reference leaves some of these final cells unconstrained; the
candidate's stronger preservation is compatible. No missing reference behavior
was identified after the context probe. Extra rejection cases supplement the
two reference success claims. Original RV proof logs were not supplied; no reference
runtime measurement or historical proof success is inferred.

**Gate C: PASS within the named trust boundary.** Exact input hashes, commands,
terminal task results, positive label lists and negative residuals are retained.
The reference comparison uses its on-disk claims and dependencies, the fixed
rules and an independent symbolic context proof, rather than treating proof
success alone as equivalence.

## Trust boundary

| Named dependency | Effect and dependents | Evidence and boundary |
|---|---|---|
| Pinned EVM semantics, including EDSL, EVM optimizations, ABI, Bytes, Int, lookup, infinite gas and bundled LEMMAS | Value, control, state and cost for every claim | Registry/session pins independently agree; relevant rules and source hashes are retained; the audit does not re-prove the fixed framework |
| K 7.1.337, KEVM proof driver, backend reasoning and Prover typed result | Closure and negative-proof reporting for every claim | Independent replay, per-claim success lines, terminal tool exit codes, and meaningful negative controls |
| Supplied runtime as the target program | Identity of all executed behavior | Exact byte comparison against original and RV runtime; compiling the Solidity source is outside this theorem |
| RV word-packing interpretation on its guarded domain | Mapping of the two reference postconditions | Reference projection/range equations and `#rangeBool`; ordinary arithmetic under valid Owner/Ok ranges |

No program-defined operation is declared an external primitive. There are no
candidate-local assumed claims. A fully independent EVM implementation was not
used as an oracle; the formal result is conditional on the pinned K model.

## Empirically supported facts

Byte-for-byte runtime identity and input immutability were checked by
`python3 audit-work/inspect-inputs.py`, exit 0. Its one-payload independent ABI
layout reconstruction reports zero mismatches for the 100-byte error payload.
It uses the standard Error(string) selector, unsigned integer encoding and
ASCII padding, not the K helper equations. This finite check does not prove
universal EVM or compiler correctness. The six witness proofs and two rejected
mutations are finite sensitivity evidence in addition to the symbolic proofs.

## Excluded behavior

Finite-gas sufficiency/exhaustion, other forks, transaction setup/finalization,
contract deployment, the Solidity compilation process, other selectors or
short calldata, and DSValue's mutating/authentication methods are not proved.
These exclusions do not omit behavior required by the supplied two RV claims.
No gas amount is proved for peek or any rejection path.
