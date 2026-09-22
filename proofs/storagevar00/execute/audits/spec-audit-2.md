# Specification audit 2

## Artifacts examined

- `/app/contract.sol`
- `/app/contract.bin`
- `/app/output/spec.k`
- `/app/output/verification.k` (`VERIFICATION-SUMMARIES`)
- `/app/output/SCOPE.md`
- Prior finding report `/app/output/audits/spec-audit-1.md`
- Construction session `00599ca4-f253-4bff-8222-619c376a46e8`, semantics `evm` at `4f4c3843076c`

## Commands and mechanical evidence

- Byte-helper differential check (`od` of `contract.bin` versus extraction of the `#parseByteStack` argument): exit 0; `byte-helper-match: yes`, 161 bytes, SHA-256 `d4f641117a2c9887cd8788c822a2b80852c6664e52f60f2b27e5e6300dbf2172`.
- `kprover validate --session 00599ca4-f253-4bff-8222-619c376a46e8 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION`: exit 0; `validation-003`, backend `valid: true`.
- Earlier concrete smoke execution with slot 0 equal to 42 emitted a terminal success configuration and 32-byte output ending in `2a`; the `kevm` wrapper nevertheless returned exit 1 after emitting that state (`run-001`). This anomaly is retained as supporting-but-not-proof evidence and is not used to replace validation or proof.

## Plain-language restatement and domain check

The success claim runs the exact supplied runtime from PC 0 under CANCUN with gas disabled, canonical no-argument `execute()` calldata, zero call value, a symbolic in-range contract address, and an arbitrary complete storage map. It requires `EVMC_SUCCESS`, ABI encoding of the total slot-0 lookup, and byte-for-byte unchanged storage. The unsuccessful claim covers every nonzero uint256 call value with the same symbolic address and arbitrary storage and requires `EVMC_REVERT`, empty output, and unchanged storage.

`execute()` has no Solidity arguments, so there is no omitted parameter class. The success and nonpayable branches partition the complete EVM-word call-value domain into zero and nonzero values. Arbitrary `STORAGE` covers explicit slot-0 values, an absent slot-0 key (whose total lookup is zero), and arbitrary other slots. The source contract's `view` body performs only an SLOAD and return; the specified storage preservation and output agree with it. Canonical ABI function invocation is explicitly chosen and recorded; fallback dispatch, malformed/noncanonical calldata, gas thresholds, deployment, and transaction accounting are not silently excluded from a broader stated theorem.

## Summary faithfulness

The sole candidate summary is the nullary exact-runtime helper. Its unconditional equation is total, terminating, non-overlapping, and byte-for-byte identical to the supplied runtime. There are no summary arguments or boundary cases to hand-evaluate. The claims use the bundled total `#lookup` and `#buf` operations rather than defining candidate equations for EVM storage or ABI encoding.

## Resolution of prior findings

- A1 resolved: both claims now quantify the whole `STORAGE` map and the return uses `#lookup(STORAGE, 0)`, so `.Map` is included and returns zero.
- A2 resolved: the helper comment and `SCOPE.md` now record 161 bytes.

VERDICT: PASS
REASON: The validated claims faithfully cover canonical execute calls over arbitrary EVM storage and both zero-value success and nonzero-value revert behavior.
