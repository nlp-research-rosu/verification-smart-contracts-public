STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `HKG:totalSupply`

## What is proven

Under immutable Prover semantics `evm@4f4c3843076c`, every direct runtime call
to the exact supplied 2,091-byte program with canonical `totalSupply()` calldata
halts with `EVMC_REVERT`, returns empty bytes, and preserves the executing
account's arbitrary symbolic storage and the arbitrary pre-existing log. The
executing account ranges over every 160-bit address and call value ranges over
every 256-bit unsigned value.

The supplied runtime implements no successful `totalSupply()` ABI branch. Its
successful subset is therefore empty and its unsuccessful subset is the entire
formal domain. This is a verified implementation discrepancy, not a proof of a
slot-zero getter.

## Formal claim (from `spec.k`)

The only positive claim is `SPEC.totalSupply-always-reverts` in
`/app/output/spec.k`. It begins with `<k> #execute => #halt </k>`, embeds the
exact supplied runtime in `<program>`, computes its valid jump destinations,
uses BYZANTIUM with gas accounting disabled, and supplies
`#abiCallData("totalSupply", .TypedArgs)`. Its post-state constrains:

```text
<output> .Bytes </output>
<statusCode> .StatusCode => EVMC_REVERT </statusCode>
<storage> STORAGE </storage>
<log> LOGS </log>
```

The internal final word stack, scratch memory, and program counter are explicit
existentials. The formal guards are `#rangeAddress(ACCT_ID)` and
`#rangeUInt(256, CALL_VALUE)`. The exact candidate hashes are:

```text
a7c84e0a292efb41e4a1a5e23f94030cd6ac9b87b925bce4d52d229e4a28dd3e  spec.k
00739fb2c3ab9af88f55ef7ec52ba3988b9f92d8f6259d0c6dc8ab4b4f606fce  verification.k
89470d655c3893cf4eda893d05b837c7679da83421367ec29d3c491b32b31859  SCOPE.md
00021ec41c557dbe8ab994a44dbd9ed10bf80b5121402e3dee6b7ff62b6149f8  prove.sh
```

## Proof-extension inventory

There are no candidate proof extensions. `VERIFICATION-SUMMARIES` is empty
apart from importing the pinned EDSL, and `VERIFICATION` only imports that
module. In particular there are:

- no definitional summaries, total functions, or candidate equations;
- no derived lemmas, auxiliary claims, assumed claims, or trusted claims;
- no operational bridges, priority rules, ordinary rewrites, or
  simplification/concrete rules;
- no candidate trusted primitives or opaque program-derived values.

The program executes under fixed bundled semantics. The ABI, byte parsing,
jump-destination, EVM execution, and status symbols used by the claim belong to
the immutable selected semantics, not to a proof-local theory. The symbolic
address, call value, storage, and log are inputs rather than abstractions. The
existential stack, memory, and program counter cannot influence the observable
postcondition.

## Exact commands and actual outputs

### Clean-room pin

Construction pin check:

```sh
kprover session show --project /app 34aef060-d0b8-47bc-8577-d4fdb4c1f87e
```

Exit 0; it reported `evm`, repository
`https://github.com/nlp-research-rosu/semantics-evm`, commit
`4f4c3843076c`.

Audit-session creation:

```sh
kprover session start --project /app --semantics evm
```

Exit 0; it created clean-room session
`e84902e9-86da-44c9-9992-7f77eecf0043`, independently pinned to the same
repository and commit. Only the frozen `spec.k` and `verification.k` were
copied into its `inputs/` before the positive validation and proof.

### Validation

```sh
kprover validate --project /app \
  --session e84902e9-86da-44c9-9992-7f77eecf0043 \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Exit 0. Task `408a256a-e444-44c1-b730-d2bd059f8bc8` completed with
`result.valid: true` and K exit 0. Its stderr consists of compiler warnings for
the intentionally existential or preserved variables `?FINAL_STACK`,
`?FINAL_MEMORY`, `?FINAL_PC`, `LOGS`, and `STORAGE`. The complete downloaded
stdout and stderr are retained in
`/app/.kprover/sessions/e84902e9-86da-44c9-9992-7f77eecf0043/validation-001/result.json`.

### Positive proof

```sh
kprover prove --project /app \
  --session e84902e9-86da-44c9-9992-7f77eecf0043 \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Exit 0. Typed terminal result:

```text
task.id: b4bfcdf2-e8d8-43d9-bd59-8a1a173b3e47
task.status: completed
task.result.outcome: proved
task.result.residual: null
task.toolRuns[-1].exitCode: 0
definitionId: 7_1_337-haskell-evm-4f4c3843076c-928d5ea5baba6e410c3482bb175c00506daf73d596a5da883cbfdeb8596f4913
```

Downloaded stdout:

```text
PROOF PASSED: SPEC.totalSupply-always-reverts
```

Downloaded stderr:

```text
WARNING 2026-09-15 10:05:48,607 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

The client contract defines `outcome: proved` with null residual as closure with
`#Top`; the selected KEVM frontend prints that closed result as `PROOF PASSED`.
The downloaded result is retained at
`/app/.kprover/sessions/e84902e9-86da-44c9-9992-7f77eecf0043/proof-001/result.json`.

### False-postcondition mutation

Audit-only `inputs/spec-mutation.k` changes only the module/claim labels and
the expected status from `EVMC_REVERT` to the deliberately false
`EVMC_SUCCESS`. The satisfiable witness `ACCT_ID = 1`, `CALL_VALUE = 0`, empty
storage, and empty log lies in the symbolic domain.

```sh
kprover validate --project /app \
  --session e84902e9-86da-44c9-9992-7f77eecf0043 \
  --semantics evm \
  --spec inputs/spec-mutation.k --spec-module SPEC-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Exit 0; validation task `31a27d98-845d-49d6-8e70-c71f9bed9d5e` was valid.

```sh
kprover prove --project /app \
  --session e84902e9-86da-44c9-9992-7f77eecf0043 \
  --semantics evm \
  --spec inputs/spec-mutation.k --spec-module SPEC-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Exit 1. Task `be2728c1-5cf2-4b76-b5f8-0942fbc796ac` completed with
`outcome: notProved` and K exit 1. Downloaded stdout:

```text
PROOF FAILED: SPEC-MUTATION.totalSupply-falsely-succeeds
1 Failure nodes. (0 pending and 1 failing)

Failing nodes:

  Node id: 3
  Failure reason:
    Matching failed.
    The following cells failed matching individually (antecedent #Implies consequent):
    STATUSCODE_CELL: EVMC_REVERT #Implies EVMC_SUCCESS
  Path condition:
    #Top

Join the Runtime Verification Discord server (https://discord.com/invite/CurfmXNtbN) or Telegram group (https://t.me/rv_kontrol) for support.
```

Downloaded stderr:

```text
WARNING 2026-09-15 10:08:53,529 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
WARNING 2026-09-15 10:09:44,031 pyk.proof.proof - Terminating proof early because fail_fast is set: SPEC-MUTATION.totalSupply-falsely-succeeds
```

Evidence is retained at
`/app/.kprover/sessions/e84902e9-86da-44c9-9992-7f77eecf0043/proof-002/result.json`.

### Executed-body sensitivity

Audit-only `inputs/spec-body-mutation.k` changes byte `fd` to `00` in the
executed fallback sequence in both literal program occurrences, replacing
`REVERT` with `STOP`, while retaining the original revert postcondition.

```sh
kprover validate --project /app \
  --session e84902e9-86da-44c9-9992-7f77eecf0043 \
  --semantics evm \
  --spec inputs/spec-body-mutation.k --spec-module SPEC-BODY-MUTATION \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Exit 0; validation task `8b4937f0-e64c-44ce-9284-9412799d3c99` was valid.

The corresponding unbounded `kprover prove` command exited 1. Task
`94208cdc-3ef0-41f0-841b-69fc59f2db71` completed with `notProved`; the actual
failure was:

```text
STATUSCODE_CELL: EVMC_SUCCESS #Implies EVMC_REVERT
Path condition:
  #Top
```

The full downloaded logs are retained at
`/app/.kprover/sessions/e84902e9-86da-44c9-9992-7f77eecf0043/proof-003/result.json`.

## Per-gate results

- Gate A — **PASS**. The literal supplied program executes under fixed
  semantics, no candidate extension contributes to closure, the positive claim
  closes, the false-success postcondition is rejected on a satisfiable path,
  and changing the actually executed bytecode changes the result and rejects
  the original postcondition.
- Gate B — **PASS**. The theorem has no argument-size or bounded-execution
  narrowing, covers symbolic call value, account, storage, and log, and matches
  the supplied runtime's complete canonical `totalSupply()` call behavior. The
  absent successful branch is explicitly reported.
- Gate C — **PASS**. Assumptions, exact commands, task IDs, logs, finite checks,
  and exclusions are ledgered. No candidate abstraction needs a differential
  oracle.

## Trust boundary

The formal result depends on the correctness of the immutable bundled
`evm@4f4c3843076c` definition, K compiler/prover, solver, and Prover service.
It also treats `/app/contract.bin` as the target runtime supplied for
verification. The candidate literal was checked byte-for-byte against that
file; recompilation equivalence from `/app/contract.sol` is not claimed.

Interpretation of the result assumes direct runtime entry, the BYZANTIUM
schedule, and disabled gas are the requested execution model. These settings
are formal cells in the claim and are not hidden assumptions. There are no
unproved proof-local summaries, rules, lemmas, trusted claims, or opaque
program-derived values.

## Empirically supported facts

These finite checks support artifact identity and the implementation reading;
they are not substitutes for the symbolic proof:

- A corrected single-literal decode and `cmp -s` exited 0 against the entire
  2,091-byte `/app/contract.bin`; both hashes are
  `71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`.
- The first 128 runtime bytes contain dispatcher selectors `095ea7b3`,
  `23b872dd`, `70a08231`, `a9059cbb`, and `dd62ed3e`; the full-runtime search
  for `18160ddd` exited 1. Bytes 109–113 are `5b 60 00 80 fd`.
- The only `totalSupply` declaration found in `/app/contract.sol` is
  `uint totalSupply;`; no `function totalSupply` declaration exists.
- The earlier command recorded in `output/evidence/bytecode-dispatch.md`
  actually exits 1 because it concatenates the two identical hex literals.
  That malformed command is not evidence; the corrected exact comparison and
  its actual result are recorded in `audits/proof-audit-1.md`.

## Excluded behavior

The theorem does not cover malformed or noncanonical calldata, arbitrary
trailing ABI bytes, out-of-gas behavior, constructor execution, a full
transaction wrapper, transaction fees, balances, nonces, rollback machinery,
or deployment-fork selection. It does not claim that the source exposes a
successful getter, because the supplied runtime does not. Final internal stack,
scratch memory, and program counter values are existential and intentionally
not external observables.
