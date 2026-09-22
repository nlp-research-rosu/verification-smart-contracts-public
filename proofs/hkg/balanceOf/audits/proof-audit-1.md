# Proof audit 1

## Artifacts examined

The unchanged candidate `spec.k`, `verification.k`, and `SCOPE.md`; the exact
runtime and Solidity source; the RV `balanceOf-spec.k` and shared imports;
and the pinned EVM semantics. The approved specification baseline is
`original/audits/spec-audit-2.md`. Both candidate K-file hashes match that
baseline. No constructor report was used as proof evidence.

| Artifact | SHA-256 |
|---|---|
| `candidate/spec.k` | `f07fcfde1b6fe74b98a235ce6258c8495b0c8046ff647bc93f30d9041b989188` |
| `candidate/verification.k` | `b920c53e6e08f8690b50e4b14bbe61258ddb98ef5c7a948d67d6f759a83bbfd9` |
| `candidate/SCOPE.md` | `218ac30b8634144032fb8a2e06b91b9e6e1884f6f8fb32c18aa8442c02e2477c` |
| `program/contract.sol` | `cee59f7cb8d3245e61fab5bb037753500cf71e19be40184acb1a8306dc05106b` |
| `program/contract.bin` | `7d99dff9e853eb7ed2a4fb086b3ea5ac7cfcf749a230729534f7d3dbc40530a1` |
| `reference/specs/balanceOf-spec.k` | `0d1cdaa06048251c35e9c0126e9cde00a7d1200b4fe1a5d2a4be600fbf75eed1` |
| `reference/verification.k` | `319391683ee2c184482e7172e778a2bf1e7f788141b17bb8b49f919fb6eadba6` |

The decoded runtime is 2,091 bytes, SHA-256
`71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`.
All four candidate literals and all three reference literals match it.

## Clean-room execution

Session `ffc42fa9-049a-4ada-9213-9f10f524f41f` independently pinned semantics
`evm`, commit `4f4c3843076c`, repository
`https://github.com/nlp-research-rosu/semantics-evm`. Definition identity is
`7_1_337-haskell-evm-4f4c3843076c-none`.

The original sources were copied byte-for-byte into the new session inputs.
There were no trusted claims, exclusions, depth limits, candidate theory edits,
or replacement sessions. Limits remained 20 proofs, 20 validations, and 9,000
seconds per task. The audit used six proofs and six validations.

| Operation | Task ID | Exit | Typed result |
|---|---|---|---|
| unchanged-validation | `5482aac6-49cd-4f63-a24d-919ffaa1233c` | 0 | True |
| unchanged-proof | `08feb7a6-31c4-494d-b322-d5fa6e6ca46d` | 0 | proved |
| witness-validation | `9d05800a-420f-49f0-a6fd-7d7342122054` | 0 | True |
| witness-proof | `8292acf3-6cee-46b2-8475-df2dfbc5e775` | 0 | proved |
| false-result-validation | `c0e6d313-64b0-48ad-8564-07dabc15f833` | 0 | True |
| false-result-proof | `8ead2864-ac2c-4062-bdc5-13f283c90e89` | 1 | notProved |
| false-status-validation | `5b2dd797-7a35-499e-81f4-6c8910f424e5` | 0 | True |
| false-status-proof | `261d046e-f133-4e3e-bb98-f0eb2cf8d72a` | 1 | notProved |
| body-mutant-validation | `dc4b62a1-0e4e-42e4-b29b-f73fded660e6` | 0 | True |
| body-mutant-proof | `ce03a03d-4ad2-4b7c-a0ae-4b8af27dfb86` | 1 | notProved |
| reference-context-validation | `83337714-b07d-44c6-b42d-f7dd23895752` | 0 | True |
| reference-context-proof | `76b31a7b-02c0-4a00-87e3-47d8d405c887` | 0 | proved |

Exact invocation records and session descriptors are retained in
`../logs/evidence/audit/commands.jsonl`,
`../logs/evidence/audit/start.json`, and
`../logs/evidence/audit/final-show.json`. Each operation directory in
`../logs/evidence/audit/session-ffc42fa9-049a-4ada-9213-9f10f524f41f/` contains the
unmodified `result.json` plus separate stdout and stderr. All live operations
used the global `kprover` CLI.

The EVM backend reports closure as `proved`, null structured residual, tool
exit 0, and `PROOF PASSED` for every selected claim. It does not expose raw
successful KAST. This audit preserves that representation instead of inventing
raw `#Top` output. Negative proof residuals appear in stdout even though the
backend's structured residual field is null. The benign stderr warning says
`--equation-max-local-steps` is ignored for non-booster `kore-rpc`; no timeout
or pending proof nodes remain.

## Reconstructed extension inventory

There are no candidate definitions, equations, simplifications, operational
bridges, auxiliary claims, trusted claims, or result-bearing opaque functions.
`VERIFICATION-SUMMARIES` only imports EDSL; `VERIFICATION` imports that module
and EDSL. EDSL supplies the fixed byte, storage, ABI, gas, and optimization
rules. The `requires` graph parses other bundled modules, but the candidate
imports no custom lemmas or summary module that replaces this program.

The two claims execute `#execute` with exact bytecode in `<program>` and
computed jump destinations. Their returned output and status are constrained.
Final program counter, stack, memory, and memory-use variables are existential
internal state; storage is the same variable on both sides. Other omitted
cells are framed. There is no fresh result oracle or circular summary.
The comment in `verification.k` mentioning an `ensures` clause is stale;
actual output constraints are in the `<output>` cell and were audited there.

## Per-gate results

- **Gate A: PASS.** Both unchanged claims replay. The exact dispatcher,
  nonpayable guard, mapping hash, SLOAD, and return/revert body execute under
  the pin. The independently authored satisfiable witnesses and rejected
  mutations below show meaningful output, status, and body sensitivity.
  No candidate extension has equation, overlap, totality, or connection-theorem
  obligations.
- **Gate B: PASS.** The candidate K files equal the approved baseline. The
  source returns `balances[owner]` at mapping slot 1. The symbolic calldata and
  selected-storage-word domain includes every canonical RV balanceOf input.
  The expanded return expression reduces to RV's `#buf(32, BAL)`.
  [The separate reference comparison](reference-comparison.md) documents each
  context difference using pinned rules. The universal reference-context
  probe closes with arbitrary depth in 0..1023, arbitrary call stack, initial
  output/status, and Istanbul positive-infinite gas. This is audit evidence
  supporting context transport, not a candidate edit.
- **Gate C: PASS.** Exact source hashes, pin, commands, task IDs, typed outcomes,
  stdout, stderr, input artifacts, mutations, and finite witness scope are
  retained. Fixed semantics and backend trust are explicit below. No finite
  test is described as a universal theorem.

## Mutation witnesses

`witness.k` proves three concrete states: owner 0/default balance 0/value 0;
maximum 160-bit owner/maximum uint256 balance/value 0; and owner 0/default
storage/value 1. Contract and caller addresses are 1 and 2. These executions
use the unchanged runtime. Ground satisfiability is also confirmed by the
negative residuals' `#Top` path condition.

`false-result.k` requires the zero-balance success to return the word 1.
`false-status.k` requires a nonzero-value call to return EVMC_SUCCESS.
`body-mutant.k` changes bytecode offset 0x191 from RETURN (0xf3) to REVERT
(0xfd), in both the actual program term and its jump-destination argument,
while retaining the correct original success postcondition. These are three
separate modules and fresh proof tasks. The failures identify the expected
observable mismatch rather than syntax, timeout, or unreachable-claim errors.

### unchanged

```text
PROOF PASSED: SPEC.balanceOf-success
PROOF PASSED: SPEC.balanceOf-nonzero-value-reverts
```

### witness

```text
PROOF PASSED: WITNESS.zero-balance
PROOF PASSED: WITNESS.maximum-balance
PROOF PASSED: WITNESS.nonpayable-revert
```

### false-result

```text
PROOF FAILED: FALSE-RESULT.zero-balance
1 Failure nodes. (0 pending and 1 failing)

Failing nodes:

  Node id: 3
  Failure reason:
    Matching failed.
    The following cells failed matching individually (antecedent #Implies consequent):
    OUTPUT_CELL: b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" #Implies b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01"
  Path condition:
    #Top
```

### false-status

```text
PROOF FAILED: FALSE-STATUS.nonpayable-revert
1 Failure nodes. (0 pending and 1 failing)

Failing nodes:

  Node id: 3
  Failure reason:
    Matching failed.
    The following cells failed matching individually (antecedent #Implies consequent):
    STATUSCODE_CELL: EVMC_REVERT #Implies EVMC_SUCCESS
  Path condition:
    #Top
```

### body-mutant

```text
PROOF FAILED: BODY-MUTANT.zero-balance
1 Failure nodes. (0 pending and 1 failing)

Failing nodes:

  Node id: 3
  Failure reason:
    Matching failed.
    The following cells failed matching individually (antecedent #Implies consequent):
    STATUSCODE_CELL: EVMC_REVERT #Implies EVMC_SUCCESS
  Path condition:
    #Top
```

### reference-context

```text
PROOF PASSED: REFERENCE-CONTEXT.balanceOf-success
```

## Trust boundary and exclusions

The theorem trusts the pinned EVM/K definitions, K/KEVM proof tooling,
solver, and hooked bytes, maps, integer arithmetic, and Keccak operations.
Every claim depends on that fixed execution model. The reference comparison
uses the same Keccak on identical bytes; it needs no collision-free assumption.
No candidate-specific axiom or external program helper is assumed.

The proof target is the runtime, not compiler correctness or deployment
identity. Solidity source and bytecode were checked for intent correspondence;
there is no compiler-correctness theorem. The reference's positive-infinite
Gas and the candidate's disabled gas both exclude finite-gas exhaustion.
Transaction validity, caller continuations after #halt, other calldata lengths,
unknown selectors, and the other HKG methods are outside this result.

The RV reference itself was not rerun. Reference coverage is a separate
semantic comparison, supported by the universal context probe, not an inferred
RV timing or baseline-success claim. Concrete ground tests are finite evidence.

## Exact proof and validation commands

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/spec.k --spec-module SPEC --source inputs/verification.k
```

Exit status: 0.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/spec.k --spec-module SPEC --source inputs/verification.k
```

Exit status: 0.

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/witness.k --spec-module WITNESS --source inputs/verification.k
```

Exit status: 0.

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/false-result.k --spec-module FALSE-RESULT --source inputs/verification.k
```

Exit status: 0.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/witness.k --spec-module WITNESS --source inputs/verification.k
```

Exit status: 0.

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/false-status.k --spec-module FALSE-STATUS --source inputs/verification.k
```

Exit status: 0.

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/body-mutant.k --spec-module BODY-MUTANT --source inputs/verification.k
```

Exit status: 0.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/false-result.k --spec-module FALSE-RESULT --source inputs/verification.k
```

Exit status: 1.

```sh
kprover validate --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/reference-context.k --spec-module REFERENCE-CONTEXT --source inputs/verification.k
```

Exit status: 0.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/false-status.k --spec-module FALSE-STATUS --source inputs/verification.k
```

Exit status: 1.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/body-mutant.k --spec-module BODY-MUTANT --source inputs/verification.k
```

Exit status: 1.

```sh
kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/reference-context.k --spec-module REFERENCE-CONTEXT --source inputs/verification.k
```

Exit status: 0.

VERDICT: PASS
REASON: VALIDATED for the two candidate claims; the separate comparison establishes the RV balanceOf observable property under its reference context.
