# Independent proof audit: `allowance`

**VERDICT: PASS — final status VALIDATED.**

The audit independently replayed the two symbolic claims for the supplied
runtime under `evm@4f4c3843076c`. Its findings were:

- **Gate A — PASS:** the successful lookup and nonpayable-revert claims close
  under fixed semantics; the discriminating false-postcondition check fails
  as expected.
- **Gate B — PASS:** the claims match the declared address, calldata, and
  symbolic-storage domain.
- **Gate C — PASS:** the proof-extension inventory and trust boundary were
  reviewed; no candidate trusted claim or unproved summary was identified.

The result depends on the pinned EVM semantics and the soundness of the K,
Prover, backend, and solver infrastructure. The theorem is about the supplied
runtime; Solidity compiler correctness is outside the proof. Gas accounting is
disabled. See [SCOPE.md](../SCOPE.md) for the complete boundary and
[spec-audit-1.md](spec-audit-1.md) for the specification review.

Raw session transcripts are not bundled. Run [prove.sh](../prove.sh) to create
fresh results.
