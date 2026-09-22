STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `DSToken:transferFrom`

## What is proven

Against remote semantics `evm` pinned to `https://github.com/nlp-research-rosu/semantics-evm@4f4c3843076c`, the exact 6,955-byte runtime `/app/contract.bin` (SHA-256 `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`) satisfies all seven symbolic `DSToken.transferFrom` reachability claims in `/app/output/spec.k`.

For canonical ABI calls in normal, non-static, gas-disabled Shanghai execution, the proof covers:

- successful distinct-address transfer: ABI `true`, outer success flag 1, allowance decrement, source decrement, destination increment, exact `LogNote` then `Transfer`, and relevant touched/accessed effects;
- successful self-transfer: ABI `true`, allowance decrement, restored source balance, and the same exact log/control effects;
- stopped, insufficient-balance, insufficient-allowance, and distinct-destination-overflow failures: `EVMC_INVALID_INSTRUCTION`, outer flag 0, empty output, and rolled-back storage/logs; and
- every positive 256-bit call value: non-payable `EVMC_REVERT`, outer flag 0, empty output, and rolled-back storage/logs.

Addresses, amount, relevant storage values, the otherwise arbitrary storage map, caller word stack, touched/accessed sets, and surrounding configuration are symbolic. The conclusion is conditional on the displayed mapping-location noncollision preconditions and the trust/model boundaries below.

## Formal claim (from `spec.k`)

The frozen spec SHA-256 is `ff40aba260d6b3a92bb956161a7efbf254cee769d2f84d883ef3bb0bf4f7be82`; frozen verification SHA-256 is `140d72159e0d2954e7dc0648347f2b339764ae534f42f8dde25d666c77aa0b7b`. Each claim begins with:

```k
#pushCallStack
~> #pushWorldState
~> #mkCall GUY TOKEN TOKEN #binRuntime(DSTOKEN) CALL_VALUE CALLDATA false
~> #return 0 0
```

where `CALLDATA` is canonical `transferFrom(address,address,uint256)` encoding and `CALL_VALUE` is zero except in the non-payable claim. The seven proved labels are:

```text
TRANSFER-FROM-SPEC.transferfrom-success-distinct
TRANSFER-FROM-SPEC.transferfrom-success-self
TRANSFER-FROM-SPEC.transferfrom-failure-stopped
TRANSFER-FROM-SPEC.transferfrom-failure-balance
TRANSFER-FROM-SPEC.transferfrom-failure-allowance
TRANSFER-FROM-SPEC.transferfrom-failure-overflow
TRANSFER-FROM-SPEC.transferfrom-failure-nonpayable
```

The source-level association was independently checked: selector `0x23b872dd` dispatches at bytecode offset `0x224`; the non-payable check is at `0x225–0x22e`, wrapper/modifier path at `0x960`, and inherited balance/allowance/update/event body at `0x1596`. The formal theorem itself is pinned to the runtime bytes, not to recompilation of the Solidity source.

## Proof-extension inventory

No target claim is trusted. There is no depth bound, positive-claim filter, exclusion, auxiliary claim, operational bridge, priority rule, concrete rule, totality attribute, simplification attribute, fresh value, or candidate opaque function.

| Extension | Class | Complete role, domain, footprint, justification, and dependents |
|---|---|---|
| `DSTOKEN`; `#binRuntime(DSTOKEN)` | Definitional summary | Exact constructor-specific byte literal; no cell/control match or state effect. It selects the code executed by every claim. Decoding gives 6,955 bytes, byte-equal to `contract.bin`, with its exact SHA-256. Fixed EVM semantics executes it. |
| `#balanceSlot(ACCOUNT)` | Definitional summary | Names pinned Solidity `#hashedLocation` for slot 1. No execution replacement or state effect; its value selects balance reads/writes and postconditions. Claim uses are address-guarded. |
| `#allowanceSlot(SRC, GUY)` | Definitional summary | Names the pinned nested Solidity location rooted at slot 2. No execution replacement or state effect; its value selects allowance reads/writes and postconditions. Claim uses are address-guarded. |
| `#stoppedByteIsZero(STORAGE)` | Definitional summary | For any map, names whether byte offset 20 of slot 4 is zero. It partitions zero-value claims but does not rewrite program execution. |
| `#transferFromLogs(TOKEN, GUY, SRC, DST, WAD)` | Definitional summary | Names the exact expected success list: anonymous `LogNote` then standard `Transfer`. It occurs only in the postcondition and cannot preempt logging execution. |

All five equations are unconditional, one-step terminating, and pairwise non-overlapping by symbol. There is no operational bridge, so matched continuations, control-stack containment, bridge connection theorems, and operational-sensitivity mutations are not applicable. Fixed semantics executes dispatch, modifiers, SHA3, loads, arithmetic, stores, logs, return, exceptional control, and rollback.

The fixed `keccak(Bytes)` primitive affects mapping locations. It is an externally supplied primitive in the immutable semantics: actual EVM `SHA3` and `#hashedLocation` share that primitive, the proof makes no numeric-hash conclusion, and success/overflow conclusions are conditional on explicit noncollision guards. This is not a candidate program-derived oracle.

The frozen verification module imports bundled `EDSL` and `LEMMAS` from the pinned repository. They were not copied or edited. `lemmas/lemmas.k` SHA-256 is `4167738dde6fb2caf6493f03dc54f2b5d75f4a7dd4250b51287e219a3ea09460`; bundled theory and backend soundness are in the TCB. The frozen `VERIFICATION-SUMMARIES` module was unchanged by the audit and mutation.

## Exact commands and actual outputs

Fresh audit session:

```text
sessionId: ce7e3afa-0372-49b8-9f3e-884cc8224818
workspaceDir: /app/.kprover/sessions/ce7e3afa-0372-49b8-9f3e-884cc8224818
semantics: evm
repo: https://github.com/nlp-research-rosu/semantics-evm
commit: 4f4c3843076c
final counters: validations 2, proofs 2, runs 0
```

Only byte-identical `spec.k` and `verification.k` copies were present for the positive validation/proof. No bundled semantics or constructor evidence was copied.

Runtime integrity command and result:

```sh
perl -0777 -ne 'if(/#parseByteStack\("0x([0-9a-f]+)"\)/s){print pack("H*",$1)}else{exit 2}' /app/output/verification.k | sha256sum
cmp -s /app/contract.bin <(perl -0777 -ne 'if(/#parseByteStack\("0x([0-9a-f]+)"\)/s){print pack("H*",$1)}else{exit 2}' /app/output/verification.k)
```

```text
65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82  -
cmp exit: 0
```

Positive validation:

```sh
kprover validate --project /app \
  --session ce7e3afa-0372-49b8-9f3e-884cc8224818 \
  --semantics evm \
  --spec inputs/spec.k --spec-module TRANSFER-FROM-SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Actual: task `00b83573-4125-4742-b251-3f6b1ec68e7d`, `completed`, `valid: true`, exit `0`, evidence `/app/.kprover/sessions/ce7e3afa-0372-49b8-9f3e-884cc8224818/validation-001/result.json`.

Complete unfiltered proof:

```sh
kprover prove --project /app \
  --session ce7e3afa-0372-49b8-9f3e-884cc8224818 \
  --semantics evm \
  --spec inputs/spec.k --spec-module TRANSFER-FROM-SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```

No trust, depth, claim, or exclusion option was present. Actual: task `fa777b3f-e1e6-45c2-9f3e-1986d655731a`, `completed`, typed `proved`, residual `null`, exit `0`, definition `7_1_337-haskell-evm-4f4c3843076c-d1e156d0ddf3061f87974d71f23c0154ed8397de24c4bfa2f0f775670bd9697b`.

Actual stdout:

```text
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-failure-nonpayable
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-failure-balance
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-failure-allowance
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-success-self
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-failure-stopped
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-success-distinct
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-failure-overflow
```

Evidence: `/app/.kprover/sessions/ce7e3afa-0372-49b8-9f3e-884cc8224818/proof-001/result.json`, SHA-256 `78df68c947c951b5601b2d12baacdfb2ca69b13b3eee65a7854340c11cefbd69`.

Auditor-authored mutation: distinct module `TRANSFER-FROM-FALSE-POST-SPEC`, distinct label `transferfrom-success-distinct-false`, and only semantic delta `#buf(32, 1) => #buf(32, 0)`. Mutation file SHA-256: `8a1edb3b9b20632086087f31fc1b9abce7051d04ec13e4591807e701ccafee30`.

Satisfiable witness: `TOKEN=10`, `GUY=11`, `SRC=12`, `DST=13`, `WAD=1`, stopped slot 4 zero, source balance 1, destination balance 0, allowance 1. Concrete Keccak locations are pairwise distinct and not 4.

Mutation proof:

```sh
kprover prove --project /app \
  --session ce7e3afa-0372-49b8-9f3e-884cc8224818 \
  --semantics evm \
  --spec inputs/false-postcondition.k \
  --spec-module TRANSFER-FROM-FALSE-POST-SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --claim TRANSFER-FROM-FALSE-POST-SPEC.transferfrom-success-distinct-false
```

Actual: task `9e8a62ea-cdd0-4774-8de4-f5ccded8f934`, typed `notProved`, exit `1`, one failing node and zero pending. The backend's structured `residual` field is null, while its retained stdout contains the stuck-node residual:

```text
PROOF FAILED: TRANSFER-FROM-FALSE-POST-SPEC.transferfrom-success-distinct-false
1 Failure nodes. (0 pending and 1 failing)
Failure reason: Matching failed.
OUTPUT_CELL: b"...\x01" #Implies b"...\x00"
Path condition:
  #Top
```

This directly witnesses the unmet false postcondition. Evidence: `/app/.kprover/sessions/ce7e3afa-0372-49b8-9f3e-884cc8224818/proof-002/result.json`, SHA-256 `52e734b812fbb41da67df1673a78b276cc33c9ca4193ccbd4a2c104e644654ff`.

## Per-gate results

- **Gate A — PASS.** Exact program identity is pinned; fixed semantics executes the complete body; no bridge or oracle replaces behavior; all equations are definitional and valid over uses; the successful precondition is satisfiable; and the false-return mutation is meaningfully rejected with the exact output mismatch.
- **Gate B — PASS.** The seven symbolic claims cover the complete implemented canonical call partition within the explicit boundaries: both success shapes, all zero-value program failures, and positive-value non-payability. Source, runtime path, storage summaries, logs, and stated property align. Hash noncollision is explicit conditional trust, not a hidden universal conclusion.
- **Gate C — PASS.** All assumptions and exclusions are named. Fresh task IDs, exact commands, input/evidence hashes, typed results, exit codes, per-claim stdout, and mutation residual are preserved. No finite test is presented as universal proof.

## Trust boundary

| Boundary | Consequence |
|---|---|
| Soundness of remote `evm@4f4c3843076c`, bundled `LEMMAS`, K `7.1.337`, Haskell backend, and SMT solver | All formal conclusions depend on this TCB. |
| Fixed `keccak(Bytes)` denotes EVM Keccak | Mapping-location conclusions use it but remain parametric in numeric hash values. |
| Explicit relevant-location noncollision inequalities | Distinct-success, self-success, and overflow claims describe independent Solidity fields only under these guards. No universal injectivity claim is made. |
| Supplied source/runtime association | Selector and bytecode paths were independently inspected; compiler correctness is not formally proved. The bytecode theorem does not depend on recompilation. |
| Displayed call-entry pattern and K framing | Conclusions concern the modeled fresh external call frame, not every enclosing CALL setup failure. |

## Empirically supported facts

- Deterministic decoding, byte count, SHA-256, and `cmp` establish that the claim's literal is exactly the supplied runtime.
- Concrete selector and storage-location hashing support the displayed mutation witness and constants only.
- There are no claimed differential or fuzz-test results. Finite checks are not used in place of the universal K proof.

## Excluded behavior

- malformed, short, trailing, or noncanonical calldata and other selectors;
- out-of-gas/resource behavior (`<useGas> false`);
- static calls (`<static> false`);
- enclosing call-setup failures and Ether-balance observations;
- `TOKEN` at Shanghai precompile addresses 1–9;
- mapping-hash collision cases excluded by explicit success/overflow guards;
- other public functions, constructor/deployment behavior, and unrelated authorization behavior.

Full independent audit details are in `/app/output/audits/proof-audit-1.md`.
