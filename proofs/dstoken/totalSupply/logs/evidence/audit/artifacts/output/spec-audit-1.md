# Specification audit 1

## Artifacts examined

- `/app/contract.sol`
- `/app/contract.bin`
- `/app/output/spec.k`
- `/app/output/verification.k`
- `/app/output/dstoken-bin.k`
- `/app/output/SCOPE.md`
- construction session `446149a2-f38c-4c76-9ec9-b7953d48233c`, semantics
  `evm` at `4f4c3843076c`

## Formal reading

The success precondition selects a canonical `totalSupply()` ABI call with
zero call value, a symbolic 160-bit executing account, and an arbitrary
well-formed symbolic storage map.  Its postcondition requires successful
termination, the 32-byte encoding of the EVM slot-0 lookup, and preservation of
that complete storage map.

The failure precondition selects the same call and symbolic state with an
arbitrary nonzero uint256 call value.  Its postcondition requires
`EVMC_REVERT`, empty output, and preservation of the complete storage map.

This matches the source declaration `return _supply` and the runtime:
selector `0x18160ddd` dispatches at offset `0x01fb`; the branch first rejects
nonzero `CALLVALUE` with `REVERT(0,0)`, then calls the body at `0x0957`,
whose effective computation is `SLOAD 0`.  There is no silent finite
restriction on storage values, addresses, or nonzero uint256 call values.

## Candidate definitions and summary faithfulness

`VERIFICATION-SUMMARIES` adds no mathematical summary.  The imported
candidate-specific `DSTOKEN-BIN` rule is a definitional bytecode constant, not
an execution shortcut.  A byte-for-byte comparison between its hex payload and
`contract.bin` succeeded, and both identify SHA-256
`65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`.
The equation has one ground case, so coverage and overlap are complete and
trivial.

The source and scope agree that slot 0 is `DSTokenBase._supply`.  The formal
result uses fixed-semantics `#lookup(STORAGE, 0)`, which returns the stored
integer modulo the EVM word range or zero when the key is absent; this is the
exact SLOAD behavior for every symbolic storage map.

## Scope and adequacy

`SCOPE.md` records the program boundary, domain, observed cells, intended
property, schedule, gas model, call context, and exclusions.  Canonical ABI
calls have no Solidity arguments.  The two claims cover both outcomes of the
function's nonpayable call-value guard.  Malformed or differently selected
calldata is outside a call to this function and is explicitly excluded.

The full executing-account storage cell is present without a rewrite in both
claims, so it is preserved.  Stack, memory, memory high-water mark, and PC are
existential final execution internals and do not weaken the result, status, or
storage observations.

## Commands and results

1. `test "$(sed -n 's/.*#parseByteStack("0x\\([0-9a-f]*\\)").*/\\1/p' output/dstoken-bin.k)" = "$(od -An -v -tx1 contract.bin | tr -d ' \\n')"`
   — exit 0.
2. `sha256sum contract.bin` — exit 0; printed
   `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`.
3. `od -Ax -tx1 -j 96 -N 24 contract.bin` — exit 0; witnessed selector
   `18 16 0d dd` and destination `0x01fb`.
4. `od -Ax -tx1 -j 507 -N 32 contract.bin` — exit 0; witnessed
   `CALLVALUE ISZERO ... REVERT(0,0)` before body dispatch.
5. `od -Ax -tx1 -j 2391 -N 12 contract.bin` — exit 0; witnessed the body
   `PUSH1 0; DUP1; SLOAD; ... RETURN` sequence at `0x0957`.
6. `sed -n '366,382p' contract.sol` — exit 0; witnessed the source storage
   declaration and `totalSupply` body.
7. `kprover validate --project /app --session 446149a2-f38c-4c76-9ec9-b7953d48233c --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k`
   — exit 0, task `9d0e9bdc-9cee-416f-a5c3-e95a542c0fdc`,
   `task.status=completed`, `task.result.valid=true`, final K tool exit 0.
   Evidence: `/app/.kprover/sessions/446149a2-f38c-4c76-9ec9-b7953d48233c/validation-004/result.json`.

No adequacy, summary-faithfulness, parser, identifier, or module finding
remains.

VERDICT: PASS
REASON: The two symbolic claims faithfully state the exact runtime's successful slot-0 return and nonzero-value revert behavior without narrowing the requested function domain.

