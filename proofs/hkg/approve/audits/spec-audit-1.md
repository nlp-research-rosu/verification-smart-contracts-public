# Specification audit 1

## Artifacts examined

- `/app/contract.sol`
- `/app/contract.bin`
- `/app/output/spec.k`
- `/app/output/verification.k` (`VERIFICATION-SUMMARIES`)
- `/app/output/helpers/hkg-bytecode.k`
- `/app/output/SCOPE.md`
- bundled `evm` semantics commit `4f4c3843076c`

## Formal contract restatement

The three claims partition canonical `approve(address,uint256)` calls over all
160-bit contract/caller/spender addresses, all uint256 amounts, and arbitrary
contract storage and prior logs. A zero-value non-static call succeeds,
overwrites Solidity nested mapping slot
`#hashedLocation("Solidity", 2, CALLER_ID SPENDER .IntList)`, appends the
three-topic `Approval` log with `VALUE` as its data word, and returns ABI true.
A nonzero-value call reverts before any state change, and a zero-value static
call fails with `EVMC_STATIC_MODE_VIOLATION` before SSTORE executes.

## Adequacy review

- Input-domain alignment: PASS. No address, amount, prior-storage, or prior-log
  value is restricted beyond Solidity/EVM types. The three claims cover every
  canonical call-value/static-context combination under the stated no-gas
  model.
- Language-model adequacy: PASS. The bundled model represents all relevant
  address, uint256, storage-map, output, log, revert, and static-failure
  behavior. No model-boundary exemption is asserted.
- Summary-to-property adequacy: PASS. `VERIFICATION-SUMMARIES` introduces no
  abstract mathematical summary. The candidate bytecode helper is a direct,
  total constant definition checked byte-for-byte against the supplied runtime.
- Implementation-to-intent alignment: PASS with a documented reading. The
  source comment permits “otherwise failure,” but the implementation contains
  no Boolean-false branch. The claims correctly describe the actual dispatcher
  revert and static-mode exceptional failure instead of inventing a false
  return.
- Observable-state alignment: PASS. Status, return bytes, whole storage map,
  and whole log list are constrained. The successful claim preserves all
  storage except slot 2's nested mapping element; both failures preserve the
  entire storage and log. Internal stack, memory, PC, gas bookkeeping, and
  unrelated environment cells are explicitly classified as unobserved.

The storage slot is faithful to Solidity layout: inherited `totalSupply` is
slot 0, `balances` is slot 1, and `allowed` is slot 2. The nested location order
matches Solidity's `keccak(spender ++ keccak(caller ++ slot))`. The bytecode
contains selector `095ea7b3`, enters the approve body at PC `0x0258`, performs
the slot-2 nested mapping SSTORE, emits LOG3 with topic order
`Approval-signature, caller, spender`, and returns word 1.

## Helper and constant checks

Command (exit 0): Node byte-for-byte comparison of the hex embedded in
`helpers/hkg-bytecode.k` against `/app/contract.bin`.

Result: `equal=true`, `embeddedBytes=2091`, `suppliedBytes=2091`.

Command (exit 0): convert the embedded Approval topic to decimal and search it
in the supplied bytecode.

Result: decimal
`63486140976153616755203102783360879283472101686154884697241723088393386309925`;
`bytecodeContainsTopic=true`.

## Mechanical checks

- `kprover health` (exit 0): server healthy, K `7.1.337`.
- `kprover semantics` (exit 0): `evm` pinned to `4f4c3843076c`.
- Validation 001: rejected before compilation because the nested helper used a
  root-relative bundled import; repaired by removing the redundant import.
- Validation 003: definition compilation failed without an inner diagnostic;
  the candidate token/import graph was simplified.
- Validation 004: definition compiled; dry-run parser identified `CALLER` as
  the opcode token rather than a variable; renamed to `CALLER_ID`.
- Validation 005: definition reused; dry-run parser identified `CALLVALUE` as
  the opcode token; renamed to `CALL_VALUE`.
- One subsequent submission was rejected before acceptance with HTTP 500
  `STORAGE_EXHAUSTED`; no session counter was consumed, and health remained OK.
- Final command (exit 0):
  `kprover validate --session 4061601c-c8bc-4ea7-bc43-5e24891ed434 --project /app --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k`.
  Validation 006 completed with `result.valid=true`; task
  `98579c40-1fa1-4419-8874-d4baa8ceba46`.

No adequacy or helper-faithfulness finding remains.

VERDICT: PASS
REASON: The claims faithfully and symbolically cover the implemented approve success, nonpayable-revert, and static-failure behavior, and the final remote validation passes.
