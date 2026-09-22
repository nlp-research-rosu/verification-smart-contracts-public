# Independent static review

## Local theory inventory

`independent-inventory.json` records the complete candidate source hashes,
all twelve claim labels, and byte-for-byte program identity. The only local
equation is `#binRuntime(DSTOKEN) => #parseByteStack(<runtime hex>)`.
It defines a constant program value; it does not replace EVM execution.
Its match domain is exactly the `DSTOKEN` constructor, its result is a
fixed 6,955-byte value, and it terminates immediately. There are no other
local equations with which it overlaps. Its value affects all claims, and
the independent identity check fixes that value to the supplied program.

`VERIFICATION-SUMMARIES` only imports this bytecode module. `VERIFICATION`
imports that module, bundled `EDSL`, and bundled `LEMMAS`. The spec adds
twelve reachability claims and no rules, functions, priorities, or totality
attributes. No claim is marked trusted. The raw claims may serve as
guarded circularities in proving the enclosing-call claims; all twelve
must themselves close in the unfiltered replay. There is no local
operational bridge, program-derived oracle, or result-bearing abstraction
that calls for an additional connection theorem.

`EDSL` imports `EDSL-PURE` and fixed `EVM-OPTIMIZATIONS`. It does not import
`EDSL-SUMMARY`, `EDSL-SUM`, or their execution summaries. The bundled
optimization rules and arithmetic/bytes/map lemmas belong to the selected
semantics trust boundary; they are not independently re-proved here.
The fixed storage-lookup range lemmas presuppose well-formed EVM word
storage. No arbitrary negative or oversized storage value is asserted to
be a valid EVM state. No cryptographic collision-resistance assumption is
introduced: equal and unequal balance-slot cases are split explicitly.

## Executed program and observables

The runtime SHA-256 is
`65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`.
All 21 runtime constants in the seven reference files have exactly these
bytes. The source identifies the public override: `stoppable`, then
`note`, then `DSTokenBase.transfer`, checked subtraction/addition, event,
and return. This is not a theorem about `transferFrom`.

The six raw claims execute from PC 0 with the runtime and its computed
jump destinations, canonical transfer calldata, a fresh local stack and
memory, and non-static execution. They constrain the final status,
return bytes, complete token storage map, and log list. Callee stack,
memory, PC, gas, and memory-use results are explicitly existential. The
six additional claims use the fixed call-stack/world-state operations,
`#mkCall`, and `#return`; no local rule emulates rollback. Fixed
`return.exception` and `return.revert` restore the saved world state,
whereas `return.success` discards the snapshot and preserves writes.

The raw domain permits every 160-bit token address. `TOKEN > 8` applies
only to the additional enclosing-call claims. This also excludes address
zero there, although it is not a precompile. It does not narrow the raw
reference comparison. Origin and call depth do not influence the selected
transfer bytecode, and the raw claims do not restrict them.

The candidate starts with an empty status and output, while the references
leave their initial values arbitrary. Neither is read by this selected
path: fixed `#end` overwrites status, successful RETURN overwrites output,
and the failure references do not constrain final output. The comparison
therefore also normalizes these stale initial diagnostic cells. This
normalization is justified by the executed opcodes and fixed rules, not
by pretending the source preconditions are textually identical.

The stopped-byte expression is `(storage[4] / 2^160) mod 256`, written
using byte extraction. With a uint256 slot, the encoding is exact. The
reference's zero slot is unstopped and its `1 << 160` slot is stopped.
For equal balance slots, the second SSTORE overwrites the debit and
restores the initial effective value. On the reference's explicit-entry
prestate this preserves the literal map as well. On an absent zero slot,
the exact two-write form can insert an explicit zero entry; it still
preserves the effective balance.

## Reference normalization

The reference claims describe raw runtime execution before rollback.
Their exceptional status is `EVMC_INVALID_INSTRUCTION`, not a successful
call or a post-rollback storage theorem. The candidate's raw failure
claims therefore supply the comparison; the enclosing-call claims are
additional results.

The reference uses `useGas=true` with `#gas(_VGAS)`. In the fixed
`INFINITE-GAS` module this denotes positive infinity, not an arbitrary
finite gas allowance. Finite costs cannot exhaust it, and the Istanbul
SSTORE stipend test is false against infinity. The candidate disables gas
accounting. Neither theorem specifies a finite gas threshold or final
gas amount. Gas/refund/access bookkeeping is projected out when comparing
the reference's functional status, return value, and storage requirements.

`transfer-disassembly.txt` contains the complete selected dispatcher,
transfer entry/wrapper, checked arithmetic helpers, and base-transfer
body. Canonical selector `0xa9059cbb` selects entry `0x568`, wrapper
`0xfbc`, and base body `0x192b`; the helpers are `0x1912` and `0x18f9`.
Returns use the call-site constants, not input-controlled jump targets.
These paths contain no GAS, MSIZE, CALL, CREATE, or fork-added opcode. Byzantium,
Constantinople, and Istanbul therefore use the same value/storage/control
operations on this path; their relevant differences are gas and refund
accounting. REVERT is available in all three, and only matters to the
candidate's additional nonpayable cases. This is a checked static
normalization of the observable requirements, not a machine-checked
cross-revision simulation theorem or an upstream proof replay.

## Seven reference mappings

| Reference | Candidate raw claims | Domain argument |
|---|---|---|
| success-1 | success-distinct | Explicit unequal slots, enough balance, no overflow, stopped word zero. |
| success-2 | success-same-slot | Equal addresses imply equal slots; the explicit entry is restored. |
| failure-1-a | failure-stopped or failure-insufficient-balance | The reference leaves the stopped word arbitrary; split on its stopped byte. |
| failure-1-b | failure-stopped, failure-insufficient-balance, or failure-overflow | Split stopped byte, then source sufficiency; its credit-overflow guard covers the remaining case. |
| failure-1-c | failure-stopped | The reference's stopped word is exactly `2^160`. |
| failure-2-a | failure-stopped or failure-insufficient-balance | Self-transfer still checks source sufficiency before either write. |
| failure-2-b | failure-stopped | The stopped check precedes notes, balance checks, and writes. |

Failure references with distinct slots leave the source balance result
existential and preserve destination/stopped entries. The candidate's
more precise unchanged/debited source results imply those postconditions.
All reference success outputs are the same ABI word one; the candidate
also constrains both emitted events. The reference conditions excluding
slot-4 collisions and requiring explicit balance entries are already
stronger than the corresponding candidate conditions.

## Baseline and trust limits

Spec audits 3 and 4 approve the effective-storage interpretation and the
exact two-write representation. The current source has that form and all
twelve claims. These baseline reports contain no full historical source
snapshot; their prose is not substituted for the present source review.

The proof targets the supplied runtime, not a fresh compilation of the
Solidity source. The trusted infrastructure comprises the pinned EVM
semantics and bundled lemmas/optimizations, K compilation and backend,
SMT solver, and concrete cryptographic/bytes hooks. Their implementations
are outside this audit's local-theory theorem. The pin, copied files,
invocations, typed results, and raw logs provide reproducibility evidence.
There is no claimed external implementation differential test, upstream
reference proof execution, or independently measured reference timing.

| Named trusted component | Effect and dependents | Boundary and evidence |
|---|---|---|
| Fixed `EVM` and `EVM-OPTIMIZATIONS` rules | Execution control, stack, memory, storage, logs, status, and rollback; all twelve claims and controls. | The immutable selected execution model is assumed, not re-proved; pin/source hashes and fresh replay are retained. |
| Bundled `EDSL` and `LEMMAS` | ABI input meaning, word arithmetic, byte/map equalities, and solver simplification; all twelve claims and controls. | Fixed shared theory, with well-formed EVM word storage; no candidate rule strengthens it. Source imports and hashes were inspected. |
| `keccak`, byte-array, and integer hooks | Selector, mapping locations, encodings, and concrete arithmetic; all ABI inputs and balance paths. | Fixed primitive implementations remain trusted. Exact runtime identity is checked; no external implementation equivalence or hash injectivity is asserted. |
| K compiler/backend, SMT solver, and Prover client/server | Translation, inference, and faithful execution of submitted artifacts; every proof result. | Infrastructure correctness is assumed. Source hashes, exact invocations, typed outcomes, raw logs, and discriminating controls provide auditability. |
