STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `HKG:approve`

## What is proven

Under the immutable bundled `evm` semantics at commit `4f4c3843076c`, the exact
2,091 runtime bytes in `/app/contract.bin` implement canonical
`approve(address,uint256)` calls as follows for symbolic addresses, amounts,
initial contract storage, and initial logs:

- A zero-value, non-static call succeeds, overwrites exactly
  `allowed[caller][spender]` at Solidity nested-mapping slot 2, appends the
  exact `Approval(caller,spender,value)` log, and returns the ABI word `1`.
- Every canonical call with a nonzero uint256 call value reverts before changing
  storage or logs, whether or not its static flag is set.
- A zero-value static call reaches the attempted `SSTORE` and halts with
  `EVMC_STATIC_MODE_VIOLATION` before changing storage or logs.

This is symbolic functional partial correctness with gas accounting disabled,
not a gas-sufficiency theorem.

## Formal claim (from `spec.k`)

The proved module is `/app/output/spec.k`, module `SPEC`:

- `SPEC.approve-success`: all `CONTRACT`, `CALLER_ID`, and `SPENDER` in the
  160-bit address range, all `VALUE` in the uint256 range, and arbitrary
  `STORAGE` and `LOGS`; exact success status, ABI-true output, nested storage
  update, and appended event.
- `SPEC.approve-nonpayable-revert`: the same address/value/storage/log domain
  plus every nonzero uint256 `CALL_VALUE` and either Boolean static context;
  exact revert status, empty output, unchanged storage, and unchanged logs.
- `SPEC.approve-static-failure`: the same symbolic address/value/storage/log
  domain, zero call value, and static context; exact static-mode-violation
  status, empty output, unchanged storage, and unchanged logs.

All claims execute `<k> #execute => #halt </k>` at PC zero over
`#binRuntime(hkg)` with computed valid jump destinations, canonical ABI calldata,
an empty initial stack and memory, and schedule `BYZANTIUM`.

## Proof-extension inventory

### Candidate-local theory

There is one candidate-local proof extension:

```k
syntax Contract ::= "hkg" [token]
rule #binRuntime(hkg) => #parseByteStack("0x...")
```

- Class: definitional summary.
- Role/domain: names the exact runtime bytes for the singleton `hkg` token; it
  does not replace execution.
- Context/state: pure context-independent expansion; no continuation, control,
  binding, or state cell is matched or modified.
- Coverage/overlap/descent: every candidate use is `hkg`; there is one local
  equation, no overlap, no recursion, and no totality assertion.
- Value justification: independently decoding the embedded hex and comparing
  all bytes to `/app/contract.bin` returned
  `equal=true`, `embeddedBytes=2091`, `suppliedBytes=2091`. Both have SHA-256
  `71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`.
- Dependents: all three claims, because the value selects the program and jump
  destinations.

`VERIFICATION-SUMMARIES` contains only `imports HKG-BYTECODE`; it introduces no
other symbol, rule, claim, opaque value, or bridge. `VERIFICATION` also imports
the immutable bundled `LEMMAS` module. No `--trusted` claim was used. The target
module contains the three claims above and no assumed auxiliary claim.

There is no proof-local operational bridge, fresh oracle, result-bearing opaque
term, priority rewrite, totalization, or claim used circularly. Consequently no
candidate execution is skipped and no connection theorem is required for a
candidate bridge.

## Exact commands and actual outputs

### Pin and clean-room validation

The construction session was inspected only to compare its semantics identity.
The independent audit session is
`109f025c-792d-46d5-8e2e-a3fcc0312d77`, pinned to repository
`https://github.com/nlp-research-rosu/semantics-evm`, commit
`4f4c3843076c`, matching construction session
`4061601c-c8bc-4ea7-bc43-5e24891ed434`.

```sh
kprover session start --project /app --semantics evm
kprover validate --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k
```

Completed validation result:

```text
task: 26f8dea9-8dbd-441d-b649-8905b76bf740
status: completed
result.valid: true
tool outcome: success
exit code: 0
definition: 7_1_337-haskell-evm-4f4c3843076c-838526e00c4c5d0f17f8a69ccb011bba700a6e6518cabd906c03dd009f6de911
```

The exact downloaded validation stdout/stderr is retained at
`/app/.kprover/sessions/109f025c-792d-46d5-8e2e-a3fcc0312d77/validation-002/result.json`.
It contains compiler warnings for intentionally unobserved final variables but
no error. An earlier identical accepted validation lost its local polling
handle and retained only queued task
`0f8c44c9-645a-4810-bf5c-37bd4a7a9389`; no conclusion uses it.

### Positive proofs

```sh
kprover prove --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k --claim SPEC.approve-success
kprover prove --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k --claim SPEC.approve-nonpayable-revert
kprover prove --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k --claim SPEC.approve-static-failure
```

Actual terminal results:

| Claim | Task ID | Exit | Outcome | Residual | Stdout |
|---|---|---:|---|---|---|
| `SPEC.approve-success` | `51869741-a325-4c5e-81cc-166334508dae` | 0 | `proved` | `null` | `PROOF PASSED: SPEC.approve-success` |
| `SPEC.approve-nonpayable-revert` | `90786117-baad-48af-b6f2-9259ce8f2a90` | 0 | `proved` | `null` | `PROOF PASSED: SPEC.approve-nonpayable-revert` |
| `SPEC.approve-static-failure` | `a794a9ce-b3bb-457e-b3e6-b903a054b03e` | 0 | `proved` | `null` | `PROOF PASSED: SPEC.approve-static-failure` |

The client's typed `proved` outcome with null residual denotes closure with a
`#Top` KAST. No proof used a depth bound, excluded claim, or trusted claim. The
downloaded proof logs are retained in clean-room `proof-001/result.json`,
`proof-002/result.json`, and `proof-003/result.json`. Each stderr contains only
this warning, with its task timestamp:

```text
kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

### Fresh non-vacuity mutation

The independent mutation changed only the success output from `#buf(32, 1)` to
the false alternative `#buf(32, 0)` in distinct module `MUTATION-SPEC`; it kept
the actual program term and all other conditions unchanged. A concrete
satisfiable witness is `CONTRACT=1`, `CALLER_ID=2`, `SPENDER=3`, `VALUE=7`, empty
storage, and empty logs.

```sh
kprover validate --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/mutation-output-zero-spec.k --spec-module MUTATION-SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k
kprover prove --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/mutation-output-zero-spec.k --spec-module MUTATION-SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k --claim MUTATION-SPEC.approve-success-false-output
```

Mutation validation exited 0 with `valid: true`, task
`60dae044-1c33-4776-a6fa-6ea95bb27455`. Mutation proof task
`9a794063-4755-49e6-9640-312c98097057` exited 1 with outcome `notProved` and
actual retained stdout:

```text
PROOF FAILED: MUTATION-SPEC.approve-success-false-output
1 Failure nodes. (0 pending and 1 failing)
Failure reason:
  Matching failed.
  The following cells failed matching individually (antecedent #Implies consequent):
  OUTPUT_CELL: b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01" #Implies b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
Path condition:
  #Top
```

The mutation artifact hash is
`1a008b5c7940d3bf83f8dad4ac662deb6eb73deb65bf0cd21f23cd0ea65a11ff`;
complete validation/proof stdout and stderr are in `validation-003/result.json`
and `proof-004/result.json`.

## Per-gate results

- Gate A — PASS. The actual bytes execute under fixed opcode semantics; the
  only local equation is the exact byte constant; there is no operational
  shortcut or opaque result; and the false-output mutation is rejected on a
  satisfiable path with actual word 1 versus demanded word 0.
- Gate B — PASS. Proving retained the approved full symbolic address, uint256,
  storage, and log domain and all three canonical call-value/static cases. It
  added no guard, bound, assumption, or summary equation. The theorem directly
  states implemented output/status/storage/log behavior.
- Gate C — PASS. Every assumption and dependent is listed below; clean-room
  validation, all positive task IDs, full retained logs, mutation, and complete
  byte-identity evidence are reproducible and separately characterized.

## Trust boundary

| Named assumption | What it can affect | Dependents | Evidence |
|---|---|---|---|
| Immutable bundled `evm` semantics, including bundled `EDSL`, `EVM-OPTIMIZATIONS`, and `LEMMAS`, soundly models BYZANTIUM execution | Value, control, state, termination, and simplification | All claims and mutation | Server-selected repository/commit `4f4c3843076c`; fetched immutable sources; no bundled source uploaded or edited |
| K 7.1.337 backend, Kore RPC, and SMT implementation are sound | Every formal conclusion | All proof tasks | Independent validation plus four retained typed proof tasks and logs |
| The supplied runtime is the implementation artifact requested | Source-to-bytecode provenance | Source-level interpretation of all claims | Complete equality of all 2,091 bytes and matching SHA-256; source compilation provenance is not formally proved |

There is no candidate-local trusted primitive, trusted claim, unproved bridge,
or opaque value.

## Empirically supported facts

- Complete deterministic byte comparison: the K helper decodes to exactly all
  2,091 bytes of `/app/contract.bin`, with zero mismatches. The independent
  oracle is the supplied binary read directly from disk.
- Finite byte-pattern inspection found selector `095ea7b3`, approve entry at
  byte 600 (`0x258`), the exact Approval topic at byte 778, and the return-true
  sequence at byte 833. This supports source/ABI correspondence; it is not used
  as a universal proof.
- The Approval topic converts to decimal
  `63486140976153616755203102783360879283472101686154884697241723088393386309925`,
  exactly the value in the formal log postcondition.

## Excluded behavior

- Non-canonical, truncated, or different-selector calldata: not an invocation
  of the selected `approve(address,uint256)` entry claim.
- Other public functions and selectors in `contract.sol`.
- Constructor/deployment behavior and contract-account code provenance.
- Gas sufficiency and out-of-gas behavior because `<useGas> false`; balances,
  refunds, access tracking, block/transaction fields, and other environmental
  cells not read by or exposed as results of this path.
- Final PC, operand stack, local memory, and memory-use values, which are
  existentially unobserved internal execution details.
- Any execution model other than the pinned bundled BYZANTIUM K semantics.
