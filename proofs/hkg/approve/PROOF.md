STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# HKG `approve` proof

Under pinned `evm` semantics revision `4f4c3843076c`, the three symbolic
claims in [spec.k](spec.k) prove the behavior of the exact runtime in
[contract.bin](contract.bin): an ordinary zero-value call sets
`allowed[caller][spender]`, emits `Approval`, and returns true; a nonpayable
call reverts without changing storage or logs; and a zero-value static call
fails with `EVMC_STATIC_MODE_VIOLATION` without changing storage or logs.

The independent proof audit reports Gates A, B, and C as PASS and the final
status as VALIDATED. The current specification review is
[spec-audit-1.md](audits/spec-audit-1.md).

## Trust boundary and scope

The result is about the supplied runtime under the pinned EVM model. It assumes
the soundness of that semantics and the K/Prover proving infrastructure; it
does not prove Solidity compiler correctness. Gas accounting is disabled.
[SCOPE.md](SCOPE.md) records the exact execution domain and exclusions.

The package retains proof and audit conclusions; run [prove.sh](prove.sh) to
generate fresh session results.
