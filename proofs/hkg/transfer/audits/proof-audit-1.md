# Independent proof audit: `transfer`

**VERDICT: PASS — final status VALIDATED.**

The audit independently replayed the three symbolic claims for the supplied
runtime under `evm@4f4c3843076c`. Its findings were:

- **Gate A — PASS:** the success, false-return, and nonpayable-revert claims
  close under fixed semantics; the false-output mutation was rejected as
  expected.
- **Gate B — PASS:** the claims cover the full stated symbolic canonical-call
  domain, including sequential writes, aliased keys, and event behavior.
- **Gate C — PASS:** no trusted candidate claims or unproved summaries were
  found; the supplied runtime, pinned semantics, and proof boundary were
  reviewed.

The result depends on the pinned EVM semantics and the soundness of the K,
Prover, backend, and solver infrastructure. The theorem is about the supplied
runtime; Solidity compiler correctness is outside the proof. Gas accounting is
disabled. See [SCOPE.md](../SCOPE.md) for the complete boundary and
[spec-audit-1.md](spec-audit-1.md) for the specification review.

Raw session transcripts are not bundled. Run [prove.sh](../prove.sh) to create
fresh results.
