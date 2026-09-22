# KIT specification audit 2

## Artifacts examined

- `/app/contract.sol`, SHA-256 `cee59f7cb8d3245e61fab5bb037753500cf71e19be40184acb1a8306dc05106b`
- `/app/contract.bin`, SHA-256 `71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`
- `/app/output/spec.k`, SHA-256 `976e9348b3b2531b1306fd292634482db41a292785e923115182095f287b1f94`
- `/app/output/verification.k`, SHA-256 `00739fb2c3ab9af88f55ef7ec52ba3988b9f92d8f6259d0c6dc8ab4b4f606fce`
- `/app/output/SCOPE.md`, SHA-256 `aac072a972245d8e6844a328945e22ffbc619e1c2854aca4f146d86039baeb2d`
- `/app/output/evidence/bytecode-dispatch.md`
- Construction session `34aef060-d0b8-47bc-8577-d4fdb4c1f87e`, pinned semantics `evm` revision `4f4c3843076c`

## Formal theorem in plain language

The precondition ranges the executing account over all 160-bit addresses and
the call value over all 256-bit unsigned values. Account storage and the
pre-existing log are otherwise arbitrary symbolic values. Calldata is exactly
the canonical ABI encoding of `totalSupply()`.

The postcondition says fixed EVM execution of the exact supplied runtime halts
with `EVMC_REVERT`, empty output, the same storage map, and the same log. The
final program counter is existential and no other state is observed.

## Gate B adequacy

### B1 — input-domain alignment: PASS

The requested ABI operation has no arguments. The single symbolic claim covers
both zero and nonzero call value over the complete EVM word range and arbitrary
storage. The address range is exactly the EVM address domain. Canonical calldata
is an explicit scope choice; malformed calldata and noncanonical trailing data
are not calls in the stated ABI domain.

The precondition is satisfiable, for example account `1`, call value `0`, empty
storage, and empty log.

### B2 — language-model adequacy: PASS

The BYZANTIUM schedule gives byte `0xfd` the `REVERT` meaning used by this
legacy runtime, and the path contains no later-fork opcode. Disabled gas is
explicitly recorded and excludes only out-of-gas behavior, not any selector or
return-value behavior. Direct runtime execution is explicitly distinguished
from a full transaction wrapper.

### B3 — summary-to-property adequacy: PASS

`VERIFICATION-SUMMARIES` defines no candidate mathematical functions. The
claim observes the fixed EVM status, output, storage, and log directly, so
there is no summary equation whose meaning could diverge from the property.

### B4 — implementation-to-intent alignment: PASS with discrepancy recorded

The source contains only `uint totalSupply;` at line 14; it is not declared
`public`, and no `function totalSupply` occurs. The runtime dispatcher contains
only five `PUSH4` selector constants and omits `0x18160ddd`. Its unmatched
selector path reaches `REVERT(0,0)`. Accordingly, a successful `totalSupply()`
case is not implemented. `SCOPE.md` records that the successful subset is
empty, while the formal claim covers the entire unsuccessful subset. This is
faithful to the request's emphasis on implemented behavior and does not
postulate a nonexistent slot-0 getter.

## Summary faithfulness

No candidate summary functions exist. No worked-example or boundary
differential test is applicable.

## Mechanical and source checks

1. `rg -n 'totalSupply|function[[:space:]]+totalSupply' /app/contract.sol`
   exited 0 and printed only `14:    uint totalSupply;`.
2. `od -An -v -tx1 -N128 /app/contract.bin | tr -d ' \n' | rg -o
   '63095ea7b3|6323b872dd|6370a08231|63a9059cbb|63dd62ed3e|6318160ddd'`
   exited 0 and printed the five non-totalSupply selector pushes.
3. `od -An -v -tx1 /app/contract.bin | tr -d ' \n' | rg -q '18160ddd'`
   exited 1, witnessing selector absence.
4. The byte-for-byte `cmp` command recorded in
   `evidence/bytecode-dispatch.md` exited 0.
5. `kprover validate --project /app --session
   34aef060-d0b8-47bc-8577-d4fdb4c1f87e --semantics evm --spec inputs/spec.k
   --spec-module SPEC --verification inputs/verification.k
   --verification-module VERIFICATION` exited 0. Task
   `b73b2ef2-98cb-47d8-89c2-e5be1ac6146a` completed with
   `result.valid: true`; retained evidence is
   `.kprover/sessions/34aef060-d0b8-47bc-8577-d4fdb4c1f87e/validation-006/result.json`.

Earlier validation attempts 1–5 are retained. Attempts 1, 2, and 4 isolated a
server definition-build failure caused by the discarded helper-module shape;
attempt 3 compiled the minimal verification definition and identified the
reserved-token variable spelling `CALLVALUE`; attempt 5 validated the prior
setup-command entry. Proof attempt 1 then witnessed that `#loadProgram` was not
executable in this proof entry context, so the audited candidate now initializes
`<program>` and `<jumpDests>` directly according to the pinned EVM convention.
None of the discarded defects is in this candidate.

VERDICT: PASS
REASON: The validated symbolic claim faithfully states the supplied runtime's implemented totalSupply-selector behavior over its full canonical-call domain.
