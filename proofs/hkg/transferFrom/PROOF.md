STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# HKG `transferFrom` proof

Under pinned `evm` semantics revision `4f4c3843076c`, the four symbolic
claims in [spec.k](spec.k) prove the behavior of the exact runtime in
[contract.bin](contract.bin) for canonical, zero-value, non-static calls. A
positive transfer succeeds when both the source balance and caller allowance
cover the value, updates balances and allowance in execution order, and emits
`Transfer`. Zero value, insufficient balance, or insufficient allowance
returns false without changing storage or logs. The claims include aliased
addresses and storage keys.

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
