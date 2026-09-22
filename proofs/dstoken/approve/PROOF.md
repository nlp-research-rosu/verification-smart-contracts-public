STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `DSToken:approve`

## What is proven

For the exact 6,955-byte runtime in `/app/contract.bin`, under bundled `evm` semantics revision `4f4c3843076c` and the Cancun schedule, canonical direct calls to `approve(address,uint256)` satisfy all of the following over symbolic addresses, amounts, storage, and existing logs:

- With zero call value and packed `stopped` byte clear, execution succeeds, returns ABI true, overwrites `_approvals[caller][spender]` with the requested amount, preserves every other storage entry, and appends the implemented anonymous LogNote followed by ERC-20 Approval.
- With zero call value and packed `stopped` byte nonzero, execution halts at the Solidity 0.4 assertion's `INVALID`, returns no bytes, and neither writes storage nor appends a log.
- With any nonzero 256-bit call value, the generated nonpayable guard reverts before the stopped check, storage write, or logging; storage and logs are preserved.

This is functional partial correctness with gas disabled. The exact runtime payload in `bytecode.k` is byte-for-byte equal to `contract.bin`.

## Formal claim (from `spec.k`)

`SPEC.approve-success`, `SPEC.approve-stopped`, and `SPEC.approve-nonpayable` begin at `<k> #execute` with the exact runtime at PC 0, empty EVM stack/memory, canonical ABI calldata, normal non-static mode, call depth zero, symbolic identities and state, and terminal destination `<k> #halt`. The success precondition ranges all account/caller/spender addresses and 256-bit amounts and requires the packed stopped byte to be zero. The stopped claim uses its Boolean complement. The nonpayable claim covers every nonzero 256-bit call value. Complete storage and log cells are constrained in every postcondition.

## Proof-extension inventory

The proof adds only seven definitional names:

| Extension | Class | Role and validation |
|---|---|---|
| `DSTOKEN_RUNTIME` | Definitional summary | Expands to the exact supplied 6,955 bytes; no execution is skipped. |
| `approveCallData` | Definitional summary | Canonical fixed-semantics ABI encoding of `approve(address,uint256)` under the claim's range guards. |
| `approveSlot` | Definitional summary | Fixed Solidity layout `keccak(spender . keccak(owner . 2))`; used only to state the actual SSTORE destination. |
| `stoppedClear` | Definitional summary | Total extraction/test of bits 160–167 of storage slot 4; success/stopped guards are complements. |
| `approveNoteData` | Definitional summary | Names the LogNote data payload. |
| `approveNoteLog` | Definitional summary | Names the first success log entry. |
| `approvalLog` | Definitional summary | Names the second success log entry. |

Each has one terminating, non-overlapping equation. None rewrites an executing EVM term, introduces control, changes a cell, supplies a fresh program-derived value, or asserts the requested result. There are no proof-local auxiliary/trusted claims, priority rules, operational bridges, or result lemmas. The immutable bundled `LEMMAS` module is part of the selected semantics, not a candidate extension. The `VERIFICATION-SUMMARIES` hash is the one approved by `spec-audit-2.md`.

## Exact commands and actual outputs

Fresh audit session: `6c5683d6-10ee-4844-b98a-d8fbcc8c2caf`, independently pinned to `evm` commit `4f4c3843076c`, matching construction session `504ef65f-e09d-448d-ad55-5e374d7ecf1c`.

Positive validation:

```sh
kprover validate --project /app \
  --session 6c5683d6-10ee-4844-b98a-d8fbcc8c2caf --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/bytecode.k
```

Task `7dd58f0c-c5d4-49f6-95d7-0323fa443d34`: `valid: true`, exit `0`.

Positive proof, unbounded and with no trusted claims:

```sh
kprover prove --project /app \
  --session 6c5683d6-10ee-4844-b98a-d8fbcc8c2caf --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/bytecode.k
```

Task `48fd473b-2887-48bc-8b45-40fbce4a3410`: `outcome: proved`, residual `null`, exit `0`. Raw stdout:

```text
PROOF PASSED: SPEC.approve-stopped
PROOF PASSED: SPEC.approve-nonpayable
PROOF PASSED: SPEC.approve-success
```

Raw stderr contains only:

```text
WARNING ... Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

The EVM frontend's `PROOF PASSED` terminal rendering accompanies the structured top-closure result (`proved`, null residual, exit 0).

Fresh false-postcondition validation and proof:

```sh
kprover validate --project /app \
  --session 6c5683d6-10ee-4844-b98a-d8fbcc8c2caf --semantics evm \
  --spec inputs/false-postcondition.k --spec-module AUDIT-FALSE-SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/bytecode.k

kprover prove --project /app \
  --session 6c5683d6-10ee-4844-b98a-d8fbcc8c2caf --semantics evm \
  --spec inputs/false-postcondition.k --spec-module AUDIT-FALSE-SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/bytecode.k
```

Validation task `0e77d7c8-9654-4855-b3c8-9f9a3b207032` returned `valid: true`, exit `0`. Proof task `aaaf04c1-1ce2-49f3-8073-129c0e37bdaf` returned `outcome: notProved`, exit `1`. Its failing node has path condition `#Top` and reports:

```text
OUTPUT_CELL: b"...\x01" #Implies b"...\x00"
```

The mutation changes only success output from ABI true to ABI false. A concrete satisfiable witness is account `0`, caller `1`, spender `2`, amount `7`, and a storage map with slot-4 word zero. All raw command results are retained under `output/audits/proof-audit-1-evidence/`.

## Per-gate results

- **Gate A — PASS.** The actual supplied runtime executes without an operational bridge. All custom equations are truthful, covered, terminating, and non-overlapping. The positive replay closes every claim, and the fresh false-result mutation is rejected with the exact unmet output.
- **Gate B — PASS.** The claims retain the approved full typed domain: all symbolic addresses/amounts, arbitrary storage, both stopped branches at zero value, and all nonzero call values. Proving added no guard, bound, claim filter, trusted claim, or shifted equation. Runtime behavior matches the source-level approve intent.
- **Gate C — PASS.** The semantics revision, task IDs, commands, exit codes, typed results, stdout/stderr, mutation source, and finite boundary artifact are retained. No candidate-specific trust assumption is hidden.

## Trust boundary

The formal result is relative to the immutable bundled `evm` semantics at commit `4f4c3843076c`, the K/KEVM prover and its solver/backend, and the supplied runtime identity. The semantics' `keccak` is an external fixed primitive; the theorem is interpretation-parametric for symbolic mapping keys and assumes no hash collision property. The theorem is about `contract.bin`; `contract.sol` fixes intent, but no source recompilation or compiler-correctness claim is made.

## Empirically supported facts

The candidate runtime payload and `contract.bin` were mechanically compared: each is 6,955 bytes and they are identical. A retained five-case arithmetic boundary script corroborates packed stopped-byte extraction for zero, lower owner bits, byte values 1 and 255, and mixed lower bits with stopped byte 7. These finite checks are corroboration only; symbolic proof and static equation review carry the universal result.

## Excluded behavior

The result excludes malformed, short, selector-mismatched, or trailing calldata; static calls; finite-gas and out-of-gas behavior; other schedules; deployment/constructor behavior; surrounding transaction balance/fee and rollback machinery; and source-to-bytecode compiler correctness. Final PC, EVM stack, memory, memory high-water mark, and infinite-gas bookkeeping are existential compiler/runtime details rather than claimed observables.
