STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# HKG `totalSupply` proof

Under pinned `evm` semantics revision `4f4c3843076c`, the single symbolic
claim in [spec.k](spec.k) proves that every canonical `totalSupply()` call to
the exact runtime in [contract.bin](contract.bin) reverts with empty output
and leaves storage and logs unchanged. The runtime has no `totalSupply()`
dispatch branch, so its successful-call subset is empty. This is a verified
implementation discrepancy, not a proof of a slot-zero getter.

The independent proof audit reports Gates A, B, and C as PASS and the final
status as VALIDATED. The current specification review is
[spec-audit-3.md](audits/spec-audit-3.md).

## Trust boundary and scope

The result is about the supplied runtime under the pinned EVM model. It assumes
the soundness of that semantics and the K/Prover proving infrastructure; it
does not prove Solidity compiler correctness. Gas accounting is disabled.
[SCOPE.md](SCOPE.md) records the exact execution domain and exclusions.

The package retains proof and audit conclusions; run [prove.sh](prove.sh) to
generate fresh session results.
