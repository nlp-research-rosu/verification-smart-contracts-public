# Independent proof audit: `totalSupply`

**VERDICT: PASS — final status VALIDATED.**

The audit independently replayed the single symbolic claim for the supplied
runtime under `evm@4f4c3843076c`. Its findings were:

- **Gate A — PASS:** the universal revert claim closes; false-status and
  executed-body mutations were discriminated.
- **Gate B — PASS:** the claim matches the implemented runtime behavior over
  canonical `totalSupply()` calls. The missing getter selector is recorded as
  an implementation discrepancy; no getter behavior is claimed.
- **Gate C — PASS:** exact runtime identity, proof-extension inventory, trust
  assumptions, and the limits of finite bytecode checks were reviewed.

The result depends on the pinned EVM semantics and the soundness of the K,
Prover, backend, and solver infrastructure. The theorem is about the supplied
runtime; Solidity compiler correctness is outside the proof. Gas accounting is
disabled. See [SCOPE.md](../SCOPE.md) for the complete boundary and
[spec-audit-3.md](spec-audit-3.md) for the current specification review.

Raw session transcripts are not bundled. Run [prove.sh](../prove.sh) to create
fresh results.
