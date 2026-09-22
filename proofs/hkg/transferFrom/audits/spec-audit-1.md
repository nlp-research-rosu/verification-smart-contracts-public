# Specification audit 1

## Artifacts examined

- `/app/contract.sol`
- `/app/contract.bin`
- `/app/output/spec.k`
- `/app/output/verification.k` (`VERIFICATION-SUMMARIES`)
- `/app/output/hkg-bin-runtime.k`
- `/app/output/SCOPE.md`
- Prover construction session `b35c50df-236f-408a-864d-02f003f9759e`, pinned to
  semantics `evm` at commit `4f4c3843076c`

## Contract and theorem restatement

The success claim requires a positive uint256 value no greater than the
initial `balances[from]` and no greater than the initial
`allowed[from][msg.sender]`.  It requires normal EVM success, ABI boolean true,
the bytecode's three sequential storage updates, and one
`Transfer(from,to,value)` log.  The three failure claims are disjoint and cover
zero value, positive value exceeding the balance, and positive value with
sufficient balance but insufficient allowance; each requires normal success,
ABI boolean false, unchanged complete storage, and no log.

This matches the Solidity body at `/app/contract.sol`: the conjunction's three
conditions, update order, emitted event, and boolean returns are all represented.
The exact runtime in `/app/contract.bin`, rather than a recompiled surrogate,
is the `<program>` executed by every claim.

## Gate B adequacy review

### B1 input-domain alignment

PASS. `FROM`, `TO`, `CALLER_ID`, and the contract account cover all 160-bit
addresses; `VALUE` covers all uint256 values.  `STORAGE` is symbolic and the
claims do not bound balances, allowances, addresses, or storage size.  The
four guards partition the complete typed canonical-call domain:

1. `VALUE > 0`, balance sufficient, allowance sufficient;
2. `VALUE == 0`;
3. `VALUE > 0`, balance insufficient;
4. `VALUE > 0`, balance sufficient, allowance insufficient.

The boundary witness `VALUE = 0` selects claim 2.  A witness such as
`VALUE = 1`, balance `0` selects claim 3; `VALUE = 1`, balance `1`, allowance
`0` selects claim 4; and all three values `1` select claim 1.

### B2 model adequacy

PASS for the stated function-level environment.  The semantics pin is the
requested `evm` revision and the supplied `/app/semantics` tree is byte-for-byte
identical to the fetched pinned source tree.  The claims explicitly select
`CANCUN`, non-static execution, zero call value, and disabled gas accounting.
Gas exhaustion, malformed calldata, nonzero-value dispatcher failure, and
transaction finalization are recorded exclusions rather than silently claimed
behavior.  The bytecode uses no fork-dependent opcode affecting the observed
state/output/log theorem.

### B3 summary faithfulness

PASS. `VERIFICATION-SUMMARIES` adds no mathematical or result-bearing summary.
The candidate runtime helper is only an exact Bytes constant.  Its reconstructed
SHA-256 equals the supplied binary SHA-256:
`71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`.
The success post-state directly states the sequential map updates, including
the case `FROM == TO` and possible storage-key equality; it does not replace
execution.

### B4 implementation-to-intent alignment

PASS. The implementation returns false rather than reverting when any of its
three guards fails, and the formal claims say exactly that.  The success event
uses indexed `from` and `to` arguments and a non-indexed uint256 `value`, as in
the source declaration.

## Mechanical checks

Command (exit 0):

```sh
kprover validate --project /app \
  --session b35c50df-236f-408a-864d-02f003f9759e \
  --semantics evm \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/hkg-bin-runtime.k
```

Result: task `24ae58ff-fb5a-4f30-9bda-f1cff8af9ca2`, `status: completed`,
`result.valid: true`, final tool `kprove` exit 0.  Evidence:
`/app/.kprover/sessions/b35c50df-236f-408a-864d-02f003f9759e/validation-010/result.json`.

Command (exit 0):

```sh
sha256sum /app/contract.bin
perl -ne 'while (/\\x([0-9a-f]{2})/g) { print pack("H2", $1) }' \
  /app/output/hkg-bin-runtime.k | sha256sum
```

Both outputs were
`71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`.

## Findings

No adequacy, summary-faithfulness, parsing, module, or identifier finding
remains.  Earlier construction diagnostics are not audit findings: the final
candidate uses chunked Bytes literals solely to avoid an LLVM compiler limit on
a monolithic constant, and `CALLER_ID` is unambiguously parsed as a variable.

VERDICT: PASS
REASON: The validated symbolic claims faithfully and completely cover the stated typed transferFrom call domain and directly constrain all requested observable behavior.
