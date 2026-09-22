STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# HKG `balanceOf` proof

Under pinned `evm` semantics revision `4f4c3843076c`, the two symbolic claims
in [spec.k](spec.k) prove the behavior of the exact runtime in
[contract.bin](contract.bin): a zero-value call in the stated 36-byte decoder
domain returns the selected stored balance without changing storage, and a
nonzero-value call reverts with empty output without changing storage.

The independent proof audit reports Gates A, B, and C as PASS and the final
status as VALIDATED. The current specification review is
[spec-audit-2.md](audits/spec-audit-2.md). The comparison reviewed with the
proof audit found that the candidate's returned balance and unchanged selected
storage correspond to the reference balance property on its stated domain;
the candidate additionally proves nonpayable reversion.

## Trust boundary and scope

The result is about the supplied runtime under the pinned EVM model. It assumes
the soundness of that semantics and the K/Prover proving infrastructure; it
does not prove Solidity compiler correctness. Gas accounting is disabled.
[SCOPE.md](SCOPE.md) records the exact execution domain and exclusions.

The package retains proof and audit conclusions; run [prove.sh](prove.sh) to
generate fresh session results.
