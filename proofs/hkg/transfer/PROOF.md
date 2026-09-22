STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# HKG `transfer` proof

Under pinned `evm` semantics revision `4f4c3843076c`, the three symbolic
claims in [spec.k](spec.k) prove the behavior of the exact runtime in
[contract.bin](contract.bin) for canonical calls: a valid positive transfer
returns true, updates balances in execution order, and emits `Transfer`; a
zero or unaffordable transfer returns false without changing storage or logs;
and a call with positive value reverts without changing storage or logs.
The claims include aliased storage keys and EVM word arithmetic.

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
