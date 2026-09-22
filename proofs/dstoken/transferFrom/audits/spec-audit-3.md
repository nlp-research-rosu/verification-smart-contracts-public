# KIT specification audit 3

## Artifacts examined

- `/app/contract.sol`
- `/app/contract.bin` (6,955 bytes; SHA-256 `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`)
- final candidate `/app/output/spec.k`
- final candidate `/app/output/verification.k`, including `VERIFICATION-SUMMARIES`
- final candidate `/app/output/SCOPE.md`
- immutable `evm` semantics at commit `4f4c3843076c`
- construction session `0965306b-374d-4868-a291-37d3096894d4`

## Mechanical and finite checks

1. `kprover validate --session 0965306b-374d-4868-a291-37d3096894d4 --spec inputs/spec.k --spec-module TRANSFER-FROM-SPEC --verification inputs/verification.k --verification-module VERIFICATION`
   - Exit 0; validation 5; task `1d9387c2-056a-4ac8-8578-bb577bd3b155`; `valid: true`.
   - Evidence: `/app/.kprover/sessions/0965306b-374d-4868-a291-37d3096894d4/validation-005/result.json`.
2. `python3 /app/output/audits/check-spec-summaries.py`
   - Exit 0.
   - Confirmed the embedded runtime is byte-for-byte equal to `/app/contract.bin`, the indexed selector topic equals `0x23b872dd << 224`, the successful note encodes zero `msg.value`, the packed stopped-byte equation on 10,000 deterministic uint256 samples, and exclusive branch classification on 10,000 deterministic storage/input samples.

## Formal contract and domain

The seven claims jointly cover canonical ABI invocations of the supplied runtime for symbolic `SRC`, `DST`, `GUY`, `TOKEN`, `WAD`, and symbolic storage. Positive call value is the non-payable revert branch. Zero call value is partitioned first by the stopped byte, then source balance, caller allowance, and (for distinct addresses) destination overflow; remaining distinct-address and self-transfer states are successful. Source equals destination is treated separately because the sequential subtraction and addition restore that balance and cannot overflow after the successful subtraction.

All address values representable by the fixed EVM model are covered for the function inputs and caller. The execution address covers zero and every non-precompile address; 1 through 9 are correctly excluded under Shanghai because `#mkCall` dispatches those addresses as precompiles instead of executing supplied runtime. Amount and relevant storage words cover the full uint256 range. Arbitrary unrelated storage and prior logs are framed.

The successful hashed storage locations carry explicit pairwise/non-slot-4 disequalities. This accurately exposes the standard Solidity/keccak storage-collision trust boundary; it is neither hidden nor mislabelled as a semantics representation gap. Malformed calldata, other selectors, out-of-gas behavior, and alternate forks are explicitly outside the chosen canonical function-call/gas-free scope rather than silently omitted.

## Postcondition adequacy

Successful claims require `EVMC_SUCCESS`, outer call flag 1, ABI boolean `true`, exact allowance and balance updates, preservation of all other storage entries, and the anonymous `LogNote` followed by standard `Transfer`. The self-transfer postcondition preserves the source balance after its two writes. Failure claims require the bytecode's exact `EVMC_INVALID_INSTRUCTION` or non-payable `EVMC_REVERT`, outer call flag 0, and external-call rollback of storage and substate. This matches the source modifiers/base function and the disassembled runtime control flow.

`SCOPE.md` records the call boundary, symbolic input/storage domain, observable state, intended property, gas/fork/value context, canonical calldata reading, failure semantics, event observability, and the cryptographic storage-layout assumption.

## Summary faithfulness

- `#binRuntime(DSTOKEN)` is exact by byte comparison.
- `#balanceSlot` and `#allowanceSlot` use Solidity's slot-1 and slot-2 hashing order, matching the runtime's SHA3 sequences and source layout.
- `#stoppedByte` extracts byte offset 20 from slot 4, matching the `SLOAD`, `256^20` division, and `0xff` mask at wrapper entry; zero/nonzero boundaries agree.
- `#transferFromLogs` uses selector `0x23b872dd` left-aligned as indexed `bytes4`, then caller/source/destination topics; its data is ABI `(uint256(0), bytes(calldata))`, followed by the standard indexed-source/indexed-destination `Transfer` event with token amount `WAD`.

Every helper equation is terminating, non-overlapping, and defined for every claim use under the recorded range guards. No helper replaces program execution or asserts the desired storage result.

VERDICT: PASS
REASON: The revised symbolic claims and definitional summaries faithfully cover every implemented canonical transferFrom branch within the explicit gas, fork, and storage-collision boundaries.
