# Proof audit 1

## Audit isolation and artifacts examined

This audit used a distinct clean-room session and did not reuse construction
task IDs or evidence directories.

- Construction session: `f0df5f9e-5a29-4f02-b383-b202d5972853`.
- Audit session: `3dd63715-e856-463d-a3e8-d92536a1f424`.
- Both sessions independently report semantics ID `evm`, repository
  `https://github.com/nlp-research-rosu/semantics-evm`, commit
  `4f4c3843076c`.
- Audit workspace:
  `/app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424`.
- Only `spec.k`, `verification.k`, and `runtime.k` were copied into the audit
  workspace before the positive replay. `cmp` returned 0 for each copied file.
- The audit-only mutation specs were subsequently created as
  `inputs/spec-false-output.k` and `inputs/spec-body-mutation.k`.
- Examined dispatched artifacts: `/app/output/spec.k`,
  `/app/output/verification.k`, `/app/output/runtime.k`,
  `/app/output/SCOPE.md`, `/app/output/prove.sh`, `/app/contract.bin`,
  `/app/contract.sol`, and `/app/output/audits/spec-audit-1.md`.
- The constructor narrative `/app/output/PROOF-EXTENSIONS.md` was not read.

Candidate hashes before and after the dynamic checks were unchanged:

```text
6c27f92e0ddc574547370bc9f7dd67c1ea1e6eb16908074ade184a3df4e2edd0  /app/output/spec.k
6409b3b5c240b70f27581994bf166de970b7c484d7b963cec53d3ce1113cd74b  /app/output/verification.k
d47ba8f18957912da3a3c7a1c9d2ccb35f4587123f14e0eaa8c8812c4b6040e5  /app/output/runtime.k
5ca2777123708a55ea90b70c6079256a31d6b7a08a11e9a49b4fc39bd60df5d8  /app/output/SCOPE.md
3d9cdc00e142cd061d4df60eb0e0c64616650fdd39b0c9baf329f8a3798562e2  /app/output/prove.sh
65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82  /app/contract.bin
f4bcfc92c70fc8196e8802abb9dbff0ebbc05cb6f18a1e6621ad63362d90cf0e  /app/contract.sol
45274ec7ecbfaff5d76190c232529309c9c83a254bcb298db5f0b129fd99322a  /app/output/audits/spec-audit-1.md
```

## Clean-room replay

Environment checks all exited 0. `command -v kprover` returned
`/usr/local/bin/kprover`; `kprover health` returned K version `7.1.337` and
status `ok`; `kprover semantics` listed `evm` at commit `4f4c3843076c`.
`kprover semantics fetch evm` exited 0 and returned the exact pinned sources at
`/home/node/.config/kprover/semantics/nlp-research-rosu/semantics-evm/4f4c3843076c`.

The candidate source-set validation command was:

```sh
kprover validate --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

It exited 0. Backend task `4f450c8f-1502-4d41-a533-9336f92c6350`
completed with `valid: true`. Complete stdout/stderr is retained at
`/app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/validation-001/result.json`.
The warnings only report unused existential final variables and the unused
`STORAGE` variable in the revert claim.

Each positive claim was then submitted separately, without `--depth` or
`--trusted`.

```sh
kprover prove --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC.allowance-success
```

Shell exit: 0. Backend task `8ba870f5-3c96-4b15-a809-6d961b6eef01`
completed with `outcome: proved`, `residual: null`, and K exit code 0. The
downloaded logs are:

```text
stdout: PROOF PASSED: SPEC.allowance-success
stderr: WARNING 2026-09-17 02:22:41,077 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

Complete evidence:
`/app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/proof-001/result.json`.
Under the client contract, typed `proved` with null residual denotes closure to
`#Top`; the EVM wrapper renders that raw success as `PROOF PASSED`.

```sh
kprover prove --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC.allowance-nonpayable-reverts
```

Shell exit: 0. Backend task `b3b8636c-aeac-4bf3-a775-0804f8c56c36`
completed with `outcome: proved`, `residual: null`, and K exit code 0. The
downloaded logs are:

```text
stdout: PROOF PASSED: SPEC.allowance-nonpayable-reverts
stderr: WARNING 2026-09-17 02:24:50,037 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

Complete evidence:
`/app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/proof-002/result.json`.

The supplied `/app/output/prove.sh` was inspected and `bash -n` exited 0. It
contains the corresponding unbounded, untrusted construction-session command
for all claims. It was not executed during this audit because the clean-room
rules prohibit reusing the construction session.

## Rebuilt proof-extension inventory

### Local extension: `#dstokenRuntime`

- Exact declaration and equation: nullary `Bytes` function marked
  `[function, total]`, with its sole unconditional rule rewriting to
  `#parseByteStack("0x...")` containing 13,910 hex digits.
- Class: definitional summary.
- Semantic role: names the supplied runtime byte sequence; it does not replace
  an EVM instruction, function body, continuation, or state transition.
- Domain and guard: the single nullary term; no guard. The one equation covers
  the whole domain, has no same-symbol overlap, and terminates in the bundled
  `#parseByteStack` parser.
- Matched context and containment: no operational configuration is matched.
  Both occurrences are exact values in `<program>` and
  `#computeValidJumpDests(...)`.
- State footprint: none. Its value selects the program subsequently executed
  by the fixed EVM semantics.
- Value influence: all execution, control, output, status, and storage facts in
  both claims depend on the selected byte sequence.
- Value justification: independently decoding the rule's hex literal produced
  exactly 6,955 bytes; `cmp` against `/app/contract.bin` exited 0 and the
  decoded SHA-256 is
  `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`,
  equal to the target file's SHA-256.
- Dependents: `SPEC.allowance-success` and
  `SPEC.allowance-nonpayable-reverts`.
- Validation: the clean-room positive replays closed; the actual-program
  mutation below was rejected.

### Exhaustiveness

`VERIFICATION-SUMMARIES` imports `EDSL` and `DSTOKEN-RUNTIME` but declares no
symbol, equation, rule, claim, priority, or totality attribute of its own. Its
content and hash are the exact baseline approved by the spec audit. The
`VERIFICATION` module adds only imports of `VERIFICATION-SUMMARIES` and the
immutable bundled `LEMMAS` module. The spec contains exactly the two target
claims and no trusted or auxiliary claim. No local operational bridge, derived
lemma, trusted primitive, fresh value, opaque value, ordinary operational
rewrite, or omitted proof-local import exists. Consequently the operational-
bridge context procedure and result-bearing abstraction procedure have no
candidate-local subject.

The bundled `EDSL`, `EVM-OPTIMIZATIONS`, and `LEMMAS` rules are part of the
immutable selected `evm` package, not proof-local source; they are recorded in
the trust boundary rather than misclassified as candidate extensions.

## Gate A — real-program soundness: PASS

### A1 and program pinning

Both entry claims put the exact `#dstokenRuntime` value in `<program>`, compute
jump destinations from that same value, begin at PC 0 with `#execute`, and
therefore execute the dispatcher and bytecode body. The output/status terms are
fixed expressions, not free results or implications.

The exact-byte checks were:

```sh
perl -ne 'if(/#parseByteStack\("0x([0-9a-fA-F]+)"\)/){print pack("H*",$1)}' /app/output/runtime.k | wc -c
# output: 6955; exit 0

perl -ne 'if(/#parseByteStack\("0x([0-9a-fA-F]+)"\)/){print pack("H*",$1)}' /app/output/runtime.k | cmp - /app/contract.bin
# no stdout; exit 0
```

For body sensitivity, audit-only module `SPEC-BODY-MUTATION` changed the term
actually present in `<program>` and its jump-destination argument to
`#parseByteStack("0x00")`, leaving the requested allowance output unchanged.

```sh
kprover validate --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec-body-mutation.k --spec-module SPEC-BODY-MUTATION --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

Exit 0; task `1c950a05-4bd5-4b1a-84d2-ef5ab533335b`; `valid: true`;
evidence `/app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/validation-003/result.json`.

```sh
kprover prove --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec-body-mutation.k --spec-module SPEC-BODY-MUTATION --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

Exit 1; task `30ed67c1-537f-49ee-9921-1e38688997e4`;
`outcome: notProved`. The actual failure node has path condition `#Top` and:

```text
OUTPUT_CELL: b"" #Implies #buf ( 32 , #lookup ( STORAGE:Map , keccak ( #buf ( 32 , GUY:Int ) +Bytes #buf ( 32 , keccak ( #buf ( 32 , SRC:Int ) +Bytes b"\x00...\x02" ) ) ) ) )
```

Complete logs: `/app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/proof-004/result.json`. Thus substituting STOP for the real
program materially invalidates the theorem.

### A2–A4

No local operational bridge skips execution, so no state, binding, evaluation,
control, exception, return, or continuation effect is abstracted. There is no
fresh or opaque result symbol and no circular reuse of a summary in execution
and postcondition. The one local equation is exact, unconditional, nonrecursive,
covering, and nonoverlapping. Fixed-semantics `#lookup` and
`#hashedLocation` determine the result directly.

### A5 non-vacuity

A satisfiable witness is `SRC = 1`, `GUY = 2`, `CONTRACT = 3`,
`MSGSENDER = 4`, and `STORAGE = .Map`, with well-formed defaults for framed
cells. All four addresses satisfy `#rangeAddress`; fixed lookup yields zero.
The audit-only `SPEC-FALSE-OUTPUT` retained the real program and precondition
but changed the success output to `#buf(32, 1)`.

```sh
kprover validate --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec-false-output.k --spec-module SPEC-FALSE-OUTPUT --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

Exit 0; task `a4537e99-be50-4f50-9075-4e84fe4eeb78`; `valid: true`;
evidence `/app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/validation-002/result.json`.

```sh
kprover prove --project /app --session 3dd63715-e856-463d-a3e8-d92536a1f424 --semantics evm --spec inputs/spec-false-output.k --spec-module SPEC-FALSE-OUTPUT --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

Exit 1; task `db14a657-8d33-44c0-ae5f-a48ba975e35b`;
`outcome: notProved`. The actual failure node has path condition `#Top` and
reports:

```text
OUTPUT_CELL: #buf ( 32 , #lookup ( STORAGE:Map , keccak ( #buf ( 32 , GUY:Int ) +Bytes #buf ( 32 , keccak ( #buf ( 32 , SRC:Int ) +Bytes b"\x00...\x02" ) ) ) ) ) #Implies b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01"
```

Complete stdout/stderr: `/app/.kprover/sessions/3dd63715-e856-463d-a3e8-d92536a1f424/proof-003/result.json`. This is a semantic mismatch,
not a parser error, timeout, or unreachable claim.

## Residual Gate B — intent adequacy: PASS

- B1: the proof retained the approved full symbolic domains: both ABI address
  arguments, caller, and contract cover all 160-bit addresses; storage is an
  arbitrary map; success covers call value zero; rejection covers every call
  value from 1 through `pow256 - 1`. No claim was dropped or bounded during
  proving.
- B2: execution uses the exact pinned EVM revision and BYZANTIUM schedule.
  Disabled gas, canonical ABI calldata, and partial-correctness scope are
  explicit. Malformed calldata, gas exhaustion, transaction validation, and
  termination are excluded rather than silently narrowed.
- B3: no candidate result summary stands between execution and the property.
  The final value is the bundled fixed-semantics `#lookup` at the bundled
  Solidity `#hashedLocation`.
- B4: the source declares `_supply`, `_balances`, then nested mapping
  `_approvals`, so its base slot is 2, and its `allowance(src,guy)` returns
  `_approvals[src][guy]`. Independent runtime slices show selector
  `0xdd62ed3e` dispatching to `0x62c`, the nonpayable `CALLVALUE` guard, and the
  body at `0x11bc` performing the two nested-map hashes before `SLOAD`.

The proven inputs and claims are byte-for-byte the approved spec baseline;
proving added no requirement, assumption, depth bound, or changed equation.

## Gate C — trust and evidence auditability: PASS

### Trust ledger

1. **Pinned EVM model and bundled proof modules.** The theorem is conditional
   on the correctness of `evm` commit `4f4c3843076c`, including EDSL parsing,
   ABI encoding, storage lookup/location, EVM optimizations, and bundled
   lemmas. This affects value, control, state, exceptional behavior, and
   termination for both claims. Evidence is the immutable registry pin, fetched
   source tree, source-set validation, positive replays, and mutations; the
   audit does not claim to re-prove the semantics package.
2. **K/Prover toolchain.** The result trusts `kprover`, Prover, K `7.1.337`, the
   Haskell backend, and its solver. This affects both claims. Each result is
   retained with task identity, typed outcome, K exit code, and downloaded
   stdout/stderr.
3. **Source-to-runtime correspondence.** The formal theorem is directly about
   supplied `/app/contract.bin`. Interpreting it as a theorem about the Solidity
   source additionally relies on the supplied runtime being the intended
   compilation. Exhaustive byte equality connects `runtime.k` to
   `contract.bin`; source declaration and runtime slices support the allowance
   interpretation, but no verified compiler theorem is claimed.
4. **Partial-correctness and gas boundary.** Termination and out-of-gas behavior
   are outside the theorem by explicit choice (`useGas = false`). These are
   exclusions, not facts inferred from the proof.

### Reproducible finite evidence and result language

The exact byte comparison, selector/body slices, false-output mutation, and
program-body mutation all have artifacts, commands, outcomes, and evidence
paths above. No candidate summary or trusted abstraction is justified by
differential testing, so the differential-test procedure has no subject.
Finite source/runtime inspection is reported only as adequacy evidence; the
formal facts are the two K reachability claims under the named trust boundary.

## Final decision

Gate A: PASS. Gate B: PASS. Gate C: PASS. The final proof status is
`VALIDATED`.

VERDICT: PASS
REASON: Gates A, B, and C pass, so the final status is VALIDATED for the two allowance reachability claims under the stated pinned-semantics and toolchain trust boundary.
