STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `DSToken:allowance`

## What is proven

Under the pinned `evm` semantics at commit `4f4c3843076c`, the exact 6,955-byte
runtime in `/app/contract.bin` satisfies two partial-correctness properties for
canonical ABI calls to `allowance(address,address)`:

1. With call value zero, execution from PC 0 halts with `EVMC_SUCCESS`, leaves
   contract storage unchanged, and returns one ABI word equal to the storage
   value at Solidity nested-mapping slot `_approvals[src][guy]`.
2. With any call value in `[1, 2^256 - 1]`, execution halts with `EVMC_REVERT`,
   leaves contract storage unchanged, and returns empty output.

Both claims were replayed independently in clean-room audit session
`3dd63715-e856-463d-a3e8-d92536a1f424`. They used no depth bound and no trusted
claim.

## Formal claim (from `spec.k`)

`SPEC.allowance-success` begins with `#execute`, the exact runtime in
`<program>`, PC 0, empty stack and memory, BYZANTIUM schedule, disabled gas,
canonical allowance calldata, symbolic 160-bit `SRC`, `GUY`, `CONTRACT`, and
`MSGSENDER`, zero call value, and symbolic storage `STORAGE`. Its destination
has `#halt`, status `EVMC_SUCCESS`, unchanged storage, and output:

```k
#buf(32, #lookup(STORAGE, #hashedLocation("Solidity", 2, SRC GUY)))
```

`SPEC.allowance-nonpayable-reverts` has the same runtime and symbolic address
domain, with `0 <Int VALUE andBool VALUE <Int pow256`. Its destination has
`#halt`, status `EVMC_REVERT`, empty output, and unchanged storage. Program
counter, internal stack, local memory, and memory high-water mark are
existential final values; other omitted cells are framed.

## Proof-extension inventory

The only proof-local definition is `#dstokenRuntime` in `runtime.k`.

- Class: definitional summary.
- Equation: a single unconditional, nonrecursive, nonoverlapping rule from the
  nullary byte function to `#parseByteStack("0x...")`.
- Role: exact program constant. It does not replace EVM instruction execution,
  binding, control, return, exception, continuation, or state behavior.
- Domain: the single nullary term; its sole equation gives complete coverage.
- State footprint: none. Its value selects the bytecode that fixed semantics
  subsequently executes.
- Dependents: both target claims.
- Validation: independent decoding yields 6,955 bytes byte-for-byte equal to
  `/app/contract.bin`, SHA-256
  `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`.
  Replacing the actual `<program>` term with STOP makes the claim fail.

`VERIFICATION-SUMMARIES` contains no function, equation, rule, claim, totality
attribute, priority, opaque term, or trusted primitive. `VERIFICATION` only
imports that empty local summary module and the bundled `LEMMAS` module. There
are no local operational bridges, derived lemmas, trusted claims, or auxiliary
claims. The imported EDSL, EVM optimization, and lemma modules belong to the
immutable pinned semantics package and are named in the trust boundary below.

## Exact commands and actual outputs

### Semantics and clean-room source validation

Construction pin inspection:

```sh
kprover session show f0df5f9e-5a29-4f02-b383-b202d5972853
```

Exit 0; it reported `evm`, commit `4f4c3843076c`, repository
`https://github.com/nlp-research-rosu/semantics-evm`, and project `/app`.

Audit session creation:

```sh
kprover session start --project /app --semantics evm
```

Exit 0; actual session ID
`3dd63715-e856-463d-a3e8-d92536a1f424`, workspace
`/app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424`, semantics commit
`4f4c3843076c`.

The three positive-proof inputs copied into `workspaceDir/inputs/` compare
byte-for-byte equal to the candidate files. Validation command:

```sh
kprover validate --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

Actual terminal result:

```text
shell exit: 0
task id: 4f450c8f-1502-4d41-a533-9336f92c6350
task status: completed
task.result.valid: true
K exitCode: 0
evidence: /app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/validation-001/result.json
```

The retained validation stdout is the actual `kore-exec ... --module
VERIFICATION --prove ... --spec-module SPEC` invocation. Retained stderr has
compiler warnings for unused existential final variables and the unused
`STORAGE` variable in the revert claim; it has no compilation error.

### Positive proof: successful call

```sh
kprover prove --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC.allowance-success
```

Actual terminal result and downloaded logs:

```text
shell exit: 0
task id: 8ba870f5-3c96-4b15-a809-6d961b6eef01
task status: completed
task.result.outcome: proved
task.result.residual: null
K exitCode: 0
stdout: PROOF PASSED: SPEC.allowance-success
stderr: WARNING 2026-09-17 02:22:41,077 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
evidence: /app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/proof-001/result.json
```

The client contract defines typed `proved` with null residual as closure to
`#Top`; this EVM proof wrapper renders the successful raw result as
`PROOF PASSED`.

### Positive proof: nonpayable rejection

```sh
kprover prove --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC.allowance-nonpayable-reverts
```

Actual terminal result and downloaded logs:

```text
shell exit: 0
task id: b3b8636c-aeac-4bf3-a775-0804f8c56c36
task status: completed
task.result.outcome: proved
task.result.residual: null
K exitCode: 0
stdout: PROOF PASSED: SPEC.allowance-nonpayable-reverts
stderr: WARNING 2026-09-17 02:24:50,037 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
evidence: /app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/proof-002/result.json
```

### False-postcondition mutation

Audit-only `inputs/spec-false-output.k` changes the successful output to
`#buf(32, 1)` while retaining the real program and precondition.

```sh
kprover validate --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec-false-output.k --spec-module SPEC-FALSE-OUTPUT --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

Exit 0; task `a4537e99-be50-4f50-9075-4e84fe4eeb78`; `valid: true`; K exit 0;
evidence `/app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/validation-002/result.json`.

```sh
kprover prove --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec-false-output.k --spec-module SPEC-FALSE-OUTPUT --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

Actual terminal result:

```text
shell exit: 1
task id: db14a657-8d33-44c0-ae5f-a48ba975e35b
task status: completed
task.result.outcome: notProved
K exitCode: 1
stdout begins: PROOF FAILED: SPEC-FALSE-OUTPUT.allowance-success-false-output
failure: OUTPUT_CELL containing the storage-derived #buf(32, #lookup(...)) does not imply the 32-byte value 1
path condition: #Top
evidence: /app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/proof-003/result.json
```

The concrete satisfiable witness `SRC=1`, `GUY=2`, `CONTRACT=3`,
`MSGSENDER=4`, `STORAGE=.Map` has the correct lookup result zero, not one.

### Program-body sensitivity mutation

Audit-only `inputs/spec-body-mutation.k` changes the term the claim actually
executes to `#parseByteStack("0x00")` and computes jump destinations from that
same changed program.

```sh
kprover validate --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec-body-mutation.k --spec-module SPEC-BODY-MUTATION --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

Exit 0; task `1c950a05-4bd5-4b1a-84d2-ef5ab533335b`; `valid: true`; K exit 0;
evidence `/app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/validation-003/result.json`.

```sh
kprover prove --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec-body-mutation.k --spec-module SPEC-BODY-MUTATION --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

Actual terminal result:

```text
shell exit: 1
task id: 30ed67c1-537f-49ee-9921-1e38688997e4
task status: completed
task.result.outcome: notProved
K exitCode: 1
stdout begins: PROOF FAILED: SPEC-BODY-MUTATION.allowance-success-stop-program
failure: OUTPUT_CELL b"" does not imply the requested storage-derived 32-byte output
path condition: #Top
evidence: /app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/proof-004/result.json
```

## Per-gate results

### Gate A — PASS

- A1: both claims execute the exact target runtime from PC 0. Independent
  decoding and `cmp` establish byte identity. Mutating the actual program term
  to STOP makes the theorem fail.
- A2: no proof-local operational bridge exists, so no EVM state transition,
  output, exception, resource, or storage effect is skipped.
- A3: no local bridge, opaque result, or circular result-bearing abstraction
  exists. Fixed semantics performs dispatch, argument decoding, control, nested
  hashing, `SLOAD`, return, and revert.
- A4: the one local equation is exact, total over its nullary domain,
  nonrecursive, and nonoverlapping. The local summary module is empty.
- A5: the false output word is rejected with `notProved`, K exit 1, and a
  semantic output mismatch under path condition `#Top`.

### Gate B — PASS

- The theorem retains all 160-bit address values, arbitrary storage, zero-value
  success, and all nonzero 256-bit call values for rejection.
- Proving introduced no stronger precondition, bounded unrolling, dropped
  claim, trusted claim, or changed summary.
- The result is stated directly with fixed-semantics storage functions. Source
  declaration order puts `_approvals` at base slot 2; the runtime dispatcher
  and body implement the corresponding nested lookup.
- Canonical ABI, disabled gas, BYZANTIUM schedule, and partial correctness are
  explicit scope choices.

### Gate C — PASS

Every dynamic result has an exact command, task ID, typed terminal result,
exit code, and retained stdout/stderr. Formal facts, conditional trust,
finite inspection evidence, and exclusions are separated below. No differential
test is offered as a universal theorem.

## Trust boundary

The proof is conditional on:

1. Correctness of immutable `evm` semantics commit `4f4c3843076c`, including
   bundled EDSL, ABI, storage, optimization, and lemma modules. This affects
   value, control, state, exceptions, and termination of both claims.
2. Correctness of `kprover`, Prover, K `7.1.337`, the Haskell backend, and its
   solver. Retained task outputs are the evidence actually returned by that
   toolchain.
3. For a source-level reading, the supplied runtime must be the intended
   compilation of `/app/contract.sol`. The formal theorem itself targets
   `/app/contract.bin`; no verified-compiler result is claimed.

Keccak behavior and Solidity storage layout as modeled by the pinned semantics
are inside item 1. There is no candidate-supplied opaque oracle or trusted
primitive.

## Empirically supported facts

- Exhaustive artifact comparison, not sampling, shows that decoding the
  `runtime.k` literal produces 6,955 bytes exactly equal to `contract.bin`.
- Read-only runtime inspection locates selector `0xdd62ed3e`, its nonpayable
  guard, and the allowance body that performs the two nested-map hashes and
  `SLOAD`. This supports the source-to-runtime adequacy reading; it is not a
  replacement for the K proof.
- The two audit mutations are finite sensitivity checks. Their rejected results
  demonstrate non-vacuity and program dependence; they do not independently
  prove the universal positive claims.

No candidate summary or abstraction is supported merely by differential
testing.

## Excluded behavior

- Termination is not proved; the claims are partial-correctness claims.
- Gas accounting and out-of-gas behavior are excluded by `<useGas> false`.
- Malformed selectors, malformed ABI argument encodings, fallback behavior,
  and other functions are outside these two canonical allowance claims.
- Transaction-level validation and environment setup outside the modeled call
  configuration are excluded.
- The theorem does not prove a verified compilation relation from Solidity
  source to bytecode.
- Program counter, internal stack, local memory, and memory high-water mark are
  not external postconditions; they are existential final values.
