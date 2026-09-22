STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `storagevar00:execute`

## What is proven

For the exact 161-byte runtime in `/app/contract.bin`, under the bundled `evm` semantics at commit `4f4c3843076c` and the CANCUN schedule with gas accounting disabled:

1. Every canonical, zero-value ABI call to `storagevar00.execute()` from an in-range symbolic contract address and arbitrary complete symbolic storage terminates with `EVMC_SUCCESS`, returns the 32-byte ABI word for storage slot 0 (zero when absent), and preserves the complete storage map.
2. Every canonical ABI call with an arbitrary nonzero uint256 call value and the same symbolic address/storage terminates with `EVMC_REVERT`, returns empty output, and preserves the complete storage map.

These are universal symbolic claims over the stated domains, not finite tests.

## Formal claim (from `spec.k`)

The proved claims are `SPEC.execute-success` and `SPEC.execute-nonpayable-revert` in `/app/output/spec.k`. Both begin at direct runtime execution:

```k
<k> #execute => #halt </k>
<program> #storageVar00Runtime </program>
<jumpDests> #computeValidJumpDests(#storageVar00Runtime) </jumpDests>
<callData> #abiCallData("execute", .TypedArgs) </callData>
```

The success postcondition fixes `EVMC_SUCCESS` and `#buf(32, #lookup(STORAGE, 0))`; the revert postcondition fixes `EVMC_REVERT` and `.Bytes`. In both claims, the account `<storage>` remains exactly `STORAGE`. Only final PC, stack, local memory, gas, and memory high-water mark are existentially hidden as internal state.

## Proof-extension inventory

The candidate adds one extension and no trusted claims:

| Extension | Class | Domain and effect | Justification | Dependents |
|---|---|---|---|---|
| `#storageVar00Runtime` with its sole equation | Definitional summary | Closed nullary value; supplies bytes to `<program>` and jump-destination computation; reads/writes no EVM state and replaces no execution | Its 322-character hex literal equals all 161 bytes of `/app/contract.bin`; the unconditional equation is exhaustive, non-overlapping, nonrecursive, and terminating | Both claims |

`VERIFICATION` otherwise imports the immutable bundled `EDSL` and `LEMMAS` modules. There are no operational bridges, priority/ordinary execution rewrites, auxiliary claims, opaque program-derived terms, fresh result symbols, or candidate trusted primitives. Consequently there is no bridge match context or result-bearing abstraction requiring a connection theorem: the fixed EVM semantics executes the actual runtime.

Exact byte check:

```sh
bin_hex=$(od -An -tx1 -v /app/contract.bin | tr -d ' \n')
helper_hex=$(sed -n 's/.*#parseByteStack("\([0-9a-f]*\)").*/\1/p' /app/output/verification.k)
test "$bin_hex" = "$helper_hex"
```

Actual result: exit 0; binary length 161 bytes; helper length 322 hex characters.

## Exact commands and actual outputs

All live audit commands used clean-room session `371c6e0b-661a-4ca6-9a33-58fd02158e9b`, separately created with:

```sh
kprover session start --project /app --semantics evm
```

Actual result: exit 0. `kprover session show` and independent `kprover semantics fetch evm` both report:

```text
repo: https://github.com/nlp-research-rosu/semantics-evm
commit: 4f4c3843076c
```

This exactly matches construction session `00599ca4-f253-4bff-8222-619c376a46e8`. Only hash-identical `spec.k` and `verification.k` were copied into the initial clean-room `inputs/`.

### Candidate validation

```sh
kprover validate --project /app \
  --session 371c6e0b-661a-4ca6-9a33-58fd02158e9b \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Actual result: exit 0; task `eb10890e-d19a-4ca4-bae2-807dfed6cbd9`; evidence `validation-001`; `status: completed`; `valid: true`. Stderr contains only compiler unused-variable warnings for bundled and existential variables.

### Success proof

```sh
kprover prove --project /app \
  --session 371c6e0b-661a-4ca6-9a33-58fd02158e9b \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --claim SPEC.execute-success
```

Actual result: exit 0; task `5517bb54-408d-429f-b7f4-befec24bf64a`; evidence `proof-001`; `outcome: proved`; `residual: null`. The client defines `proved` as closure with the raw `#Top` KAST. Retained stdout:

```text
PROOF PASSED: SPEC.execute-success
```

Retained stderr is one non-fatal warning that `--equation-max-local-steps` is ignored for non-booster `kore-rpc`.

### Nonpayable-revert proof

```sh
kprover prove --project /app \
  --session 371c6e0b-661a-4ca6-9a33-58fd02158e9b \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --claim SPEC.execute-nonpayable-revert
```

Actual result: exit 0; task `ac596094-b651-4909-94f1-c4380ac2f5d2`; evidence `proof-002`; `outcome: proved`; `residual: null`. Retained stdout:

```text
PROOF PASSED: SPEC.execute-nonpayable-revert
```

Retained stderr is the same non-fatal non-booster warning.

### False-postcondition discrimination

The audit-authored distinct module `SPEC-AUDIT-MUTATION` changed only the success output from slot 0 to slot 0 plus one and removed the unrelated revert claim. Witness: `ACCT = 0`, `STORAGE = .Map`, call value 0; the program returns word 0 while the mutation requires word 1.

Validation with `--spec inputs/audit-mutation.k --spec-module SPEC-AUDIT-MUTATION` exited 0 (`valid: true`, task `4b1ce8d2-f924-4df0-b283-32a3b8e3b7bb`). Proof command:

```sh
kprover prove --project /app \
  --session 371c6e0b-661a-4ca6-9a33-58fd02158e9b \
  --semantics evm \
  --spec inputs/audit-mutation.k --spec-module SPEC-AUDIT-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Actual result: exit 1; task `1b1bb2ec-12d9-4dc6-9a4e-011e3f7792b7`; evidence `proof-003`; `outcome: notProved`. Retained failing residual:

```text
OUTPUT_CELL: #buf ( 32 , #lookup ( STORAGE:Map , 0 ) #Implies #lookup ( STORAGE:Map , 0 ) +Int 1 )
Path condition:
  #Top
```

### Program-body sensitivity

The audit-authored distinct module `SPEC-AUDIT-BODY-MUTATION` changed the actual `<program>` and its jump-destination term to `#parseByteStack("00")` while retaining the original success output. Validation exited 0 (`valid: true`, task `e3b16cdf-cf76-4451-8837-713edec9970e`). Proof command:

```sh
kprover prove --project /app \
  --session 371c6e0b-661a-4ca6-9a33-58fd02158e9b \
  --semantics evm \
  --spec inputs/audit-body-mutation.k --spec-module SPEC-AUDIT-BODY-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Actual result: exit 1; task `b9e484e1-fd3f-4806-9654-825515197db1`; evidence `proof-004`; `outcome: notProved`. Retained failing residual:

```text
OUTPUT_CELL: b"" #Implies #buf ( 32 , #lookup ( STORAGE:Map , 0 ) )
Path condition:
  #Top
```

Neither positive proof used a depth bound or trusted claim. Full retained stdout/stderr and typed task results are in the evidence directories named above.

## Per-gate results

### Gate A — PASS

- The exact supplied bytecode executes through fixed EVM semantics; no candidate rule replaces program-defined execution.
- No bridge exists, so there is no skipped state, binding, continuation, control, return, revert, or exception effect.
- The closed byte helper is valid over its entire domain.
- Output, status, and full storage preservation are genuinely constrained.
- The false-output mutation fails on the requested result, and the actual-body mutation fails when the executed body is changed.

### Gate B — PASS

The theorem was not narrowed during proving. It covers arbitrary complete storage, including absent slot 0, and the complete call-value partition relevant to this nonpayable function: zero succeeds and every nonzero uint256 value reverts. It uses canonical no-argument ABI invocation, as explicitly stated. No bounded structure, strengthened storage precondition, dropped claim, or altered summary appears.

### Gate C — PASS

Every audit proof and mutation has a retained task ID, exact source, command, typed result, exit code, and stdout/stderr. No finite differential test is used as universal proof. Formal, conditional, empirical, and excluded statements are separated below.

## Trust boundary

The formal result is conditional on:

- correctness of K 7.1.337, `kore-exec`/SMT, the Prover service, and the immutable bundled `evm` semantics at `4f4c3843076c`;
- correctness of bundled `EDSL`, `LEMMAS`, ABI, byte parsing, total storage lookup, and word-buffer definitions;
- `/app/contract.bin` being the intended supplied runtime for `/app/contract.sol`; the theorem executes those bytes and the proof helper matches them exactly, but compiler provenance/source-to-bytecode equivalence is not formally proved;
- the explicitly chosen direct-runtime, CANCUN, sufficient-gas functional-call boundary matching the intended verification scope.

No candidate-specific behavioral axiom, operational bridge, opaque oracle, or trusted claim is assumed.

## Empirically supported facts

The byte-helper comparison is exhaustive mechanical equality, not sampling. The two rejected mutations are dynamic discrimination evidence, not semantic assumptions. A prior slot-0-equals-42 concrete run emitted the expected terminal output but its `krun` process exited 1; it is diagnostic only and is not used to support the universal theorem.

## Excluded behavior

The theorem excludes deployment/constructor behavior, arbitrary or malformed calldata, other selectors and fallback dispatch, trailing calldata, out-of-gas thresholds and gas consumption, whole-transaction balance/nonce/refund/warm-access effects, and transaction finalization. Internal final PC, stack, local memory, gas, and memory watermark are not user-visible postconditions. These exclusions are explicit scope choices, not hidden proof-time restrictions.
