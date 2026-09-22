STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `HKG:allowance`

## What is proven

Under immutable K semantics `evm` at repository
`https://github.com/nlp-research-rosu/semantics-evm`, revision
`4f4c3843076c`, the exact 2,091-byte runtime in `/app/contract.bin` satisfies:

1. For arbitrary 160-bit executing-account, owner, and spender addresses,
   arbitrary EVM storage, canonical `allowance(address,address)` calldata, and
   call value zero, execution from PC 0 halts with `EVMC_SUCCESS`, returns the
   32-byte encoding of the storage word at Solidity nested-mapping base slot 2,
   and preserves the complete storage map.
2. For the same address/storage/calldata domain and every nonzero 256-bit call
   value, execution from PC 0 halts with `EVMC_REVERT`, returns empty bytes, and
   preserves the complete storage map.

Both facts are symbolic over addresses and storage; they are not a finite input
enumeration.

## Formal claim (from `spec.k`)

The targets are `SPEC.allowance-success` and
`SPEC.allowance-nonpayable-failure` in `/app/output/spec.k`. Both execute
`#execute => #halt` with mode `NORMAL`, schedule `BYZANTIUM`, gas disabled,
program counter 0, empty stack/memory, canonical allowance calldata, and a
program constrained to the exact parsed runtime literal.

The success claim constrains:

```k
<output> .Bytes => #buf(32, #lookup(STORAGE,
  #hashedLocation("Solidity", 2, OWNER SPENDER))) </output>
<statusCode> .StatusCode => EVMC_SUCCESS </statusCode>
```

The nonpayable claim constrains:

```k
<output> .Bytes => .Bytes </output>
<statusCode> .StatusCode => EVMC_REVERT </statusCode>
requires ... andBool #rangeUInt(256, VALUE) andBool VALUE =/=Int 0
```

In both claims, `<storage> STORAGE </storage>` is unchanged. Final stack,
memory, PC, and memory high-water mark are existential because they are not
post-halt observables in this theorem.

## Proof-extension inventory

| Candidate item | Classification | Effect on execution | Dependents and justification |
|---|---|---|---|
| `VERIFICATION-SUMMARIES` | Empty module; no extension | None | Imports pinned `EDSL`; adds no symbol or rule |
| `VERIFICATION` | Import aggregator; no extension | None | Imports the empty module and pinned `LEMMAS` |
| `allowance-success` | Target claim | Executes the fixed runtime semantics | Proved directly; never trusted |
| `allowance-nonpayable-failure` | Target claim | Executes the fixed runtime semantics | Proved directly; never trusted |

There is no candidate function, totality declaration, simplification/concrete/
priority/owise rule, ordinary rewrite, operational bridge, auxiliary claim,
opaque term, or summary. The approved `VERIFICATION-SUMMARIES` module remains
empty. Bundled `EDSL` and `LEMMAS` are part of the immutable selected semantics,
not proof-local helpers. Consequently there is no candidate connection theorem,
context-containment argument, operational-sensitivity test, or result-bearing
oracle to admit.

Relevant pinned definitions remain explicit: `#lookup` is total with present,
absent, and non-integer cases (`evm-types.md:418-424`), Solidity
`#hashedLocation` is defined by guarded recursion
(`hashed-locations.md:57-64`), and `#abiCallData` is defined by ABI signature
and argument encoding (`abi.md:141-147`).

## Exact commands and actual outputs

### Clean audit pin

Command:

```sh
kprover session start --project /app --semantics evm
```

Exit `0`; actual material output:

```json
{
  "attemptsUsed": 0,
  "projectRoot": "/app",
  "semantics": {
    "commit": "4f4c3843076c",
    "id": "evm",
    "repo": "https://github.com/nlp-research-rosu/semantics-evm"
  },
  "sessionId": "a63d16c5-19ca-445e-bc0c-5bf8e3db43fa",
  "validationsUsed": 0,
  "workspaceDir": "/app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa"
}
```

The construction session reports the same project, semantics ID, repository,
and commit. The audit session's initial `inputs/` held only byte-identical
copies of `spec.k` and `verification.k`.

### Clean validation

```sh
kprover validate --project /app --session a63d16c5-19ca-445e-bc0c-5bf8e3db43fa --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION
```

Exit `0`; task `c564b1ff-5c6f-47c3-9c1d-b6e3738b54ba`; status `completed`;
`result.valid: true`; tool `kprove`, exit `0`. Downloaded stdout:

```text
kore-exec /data/definitions/7_1_337-haskell-evm-4f4c3843076c-8de2aa8e95f822c67b82152ab4108caea672b57b3d82ef2b3fe48239db915512/definition/definition.kore --module VERIFICATION --prove /tmp/.kprove-2026-09-15-08-27-02-433-f2439828-1228-4b33-8dac-ff6a439093c9/spec.kore --spec-module SPEC --output /tmp/.kprove-2026-09-15-08-27-02-433-f2439828-1228-4b33-8dac-ff6a439093c9/result.kore
```

The complete compiler-warning stderr is retained unchanged at
`/app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa/validation-001/result.json`.

### Positive unfiltered proof

```sh
kprover prove --project /app --session a63d16c5-19ca-445e-bc0c-5bf8e3db43fa --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION
```

No depth bound, claim filter, exclusion, or trusted claim was used. Exit `0`;
task `a8b099af-6942-46bf-9874-5899788d14ed`; status `completed`; outcome
`proved`; residual `null`; tool outcome `success`, exit `0`. Under the client
contract, `proved` is closure with a `#Top` KAST. Downloaded stdout, verbatim:

```text
PROOF PASSED: SPEC.allowance-nonpayable-failure
PROOF PASSED: SPEC.allowance-success
```

Downloaded stderr, verbatim:

```text
WARNING 2026-09-15 08:29:36,922 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

Evidence:
`/app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa/proof-001/result.json`
(SHA-256 `614530a57de364048b334ae75d28affef0397e48559c8da48f5b59401e3882b7`).

### Fresh false-postcondition mutation

The audit created `inputs/spec-false.k` (SHA-256
`b5696ba0443b0a9d8976d8ecb8ab863b23df67346e84628e9eeb56771b0648ee`)
in distinct module `SPEC-FALSE-AUDIT` and changed only the success label and
output value from `#lookup(...)` to `#lookup(...) +Int 1`. A satisfiable witness
is `ACCT = OWNER = SPENDER = 0`, `STORAGE = .Map`, call value `0`, and the exact
runtime: the real word is `0`, while the mutation demands `1`.

Validation:

```sh
kprover validate --project /app --session a63d16c5-19ca-445e-bc0c-5bf8e3db43fa --semantics evm --spec inputs/spec-false.k --spec-module SPEC-FALSE-AUDIT --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC-FALSE-AUDIT.allowance-success-false
```

Exit `0`; task `11fd159d-7c47-48a4-bedc-ec48692fd067`; status `completed`;
`result.valid: true`; tool exit `0`.

Proof:

```sh
kprover prove --project /app --session a63d16c5-19ca-445e-bc0c-5bf8e3db43fa --semantics evm --spec inputs/spec-false.k --spec-module SPEC-FALSE-AUDIT --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC-FALSE-AUDIT.allowance-success-false
```

Exit `1`; task `8020df9e-02d4-4514-9aaf-269d2fe8965e`; status `completed`;
outcome `notProved`; tool exit `1`. Downloaded stdout reports one failing node:

```text
PROOF FAILED: SPEC-FALSE-AUDIT.allowance-success-false
1 Failure nodes. (0 pending and 1 failing)

Failing nodes:

  Node id: 3
  Failure reason:
    Matching failed.
    The following cells failed matching individually (antecedent #Implies consequent):
    OUTPUT_CELL: #buf ( 32 , #lookup ( STORAGE:Map , keccak ( #buf ( 32 , SPENDER:Int ) +Bytes #buf ( 32 , keccak ( #buf ( 32 , OWNER:Int ) +Bytes b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02" ) ) ) ) #Implies #lookup ( STORAGE:Map , keccak ( #buf ( 32 , SPENDER:Int ) +Bytes #buf ( 32 , keccak ( #buf ( 32 , OWNER:Int ) +Bytes b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02" ) ) ) ) +Int 1 )
  Path condition:
    #Top
```

Downloaded stderr, verbatim:

```text
WARNING 2026-09-15 08:35:25,978 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
WARNING 2026-09-15 08:36:45,747 pyk.proof.proof - Terminating proof early because fail_fast is set: SPEC-FALSE-AUDIT.allowance-success-false
```

Evidence:
`/app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa/proof-002/result.json`
(SHA-256 `5016909fbee87a651b1d34a6fa0f41541dd801797947805e4526d4c7f2734338`).

## Per-gate results

- **Gate A — PASS.** The actual pinned bytecode executes under fixed semantics;
  no candidate bridge or program-derived abstraction replaces it. Observable
  storage, output, and status are constrained. The exact program literal equals
  `contract.bin`. The satisfiable off-by-one mutation is rejected with the
  unmet output implication under path condition `#Top`.
- **Gate B — PASS.** The proven claims are byte-for-byte the approved spec and
  were proved unfiltered. No precondition was strengthened, claim dropped,
  bounded unrolling introduced, or summary meaning shifted. The symbolic input
  domain and explicit model exclusions remain aligned with `contract.sol`, the
  supplied runtime, and `SCOPE.md`.
- **Gate C — PASS.** All live evidence artifacts exist and are hashed; commands,
  task IDs, typed results, stdout, and stderr are recorded. Assumptions and
  finite evidence are separated from formal facts.

The full gate analysis and command ledger are in
`/app/output/audits/proof-audit-1.md`.

## Trust boundary

| Boundary | Consequence | Dependents |
|---|---|---|
| Pinned EVM semantics and K backend accurately implement the declared model | Formal conclusions are relative to this model | Both claims |
| Pinned `keccak`/`Keccak256` denotes EVM Keccak-256 | Human meaning of ABI selector and nested storage location | Both claims for selector; success for location |
| Solidity 0.4 ABI/storage-layout reading places `allowed` at nested mapping base slot 2 | Connects formal location to source-level `allowed[owner][spender]` | Success source-level reading |
| `contract.bin` is the authoritative target runtime | Fixes program identity | Both claims |
| `contract.sol` states the intent of that runtime | Connects binary theorem to source prose; no compiler-correctness theorem is claimed | Human interpretation |

There are no trusted candidate claims, candidate proof rules, opaque
program-derived values, or operational bridges.

## Empirically supported facts

No differential or finite concrete behavioral test is claimed. The following
mechanical checks support identity and adequacy but are not universal proofs:

- Both spec literals are identical and equal all 2,091 bytes of
  `/app/contract.bin`.
- Runtime bytes contain selector `dd62ed3e` for `allowance(address,address)`.
- `/app/contract.sol:203-205` implements `return allowed[owner][spender]`.
- Fetched pinned `abi.md`, `edsl.md`, `evm.md`, and `driver.md` match the supplied
  `/app/semantics` files byte-for-byte.
- `/app/output/prove.sh` is executable, syntax-valid, uses the global client,
  pins construction session `547121a7-36d3-4228-9b32-a494d0d3ed15` and `evm`,
  and contains no depth bound, claim filter, exclusion, or trusted claim. The
  clean audit did not execute it because it intentionally names the construction
  session.

## Excluded behavior

- Calls whose selector or ABI shape is not canonical
  `allowance(address,address)`.
- Internal entry into the middle of the runtime.
- Gas accounting, out-of-gas/resource exhaustion, and dependence on a concrete
  gas budget (`<useGas> false`).
- Schedules other than the selected `BYZANTIUM` model.
- Broader ERC-20 properties or functions beyond allowance success and its
  compiler-generated nonpayable rejection.
- Source-to-bytecode compiler correctness as a separately proved theorem.
- Post-halt internal stack, memory, PC, memory high-water mark, and other
  unobserved environmental cells beyond the stated output, status, and storage
  observations.
