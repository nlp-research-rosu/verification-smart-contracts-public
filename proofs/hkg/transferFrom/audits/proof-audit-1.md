# Independent proof audit: `transferFrom`

**VERDICT: PASS — final status VALIDATED.**

The audit independently replayed the four symbolic claims for the supplied
runtime under `evm@4f4c3843076c`. Its findings were:

- **Gate A — PASS:** all four claims close under fixed semantics; the fresh
  false-output mutation was rejected with the expected unmet condition.
- **Gate B — PASS:** the claims cover the scoped zero-value, non-static call
  domain and match the success and three failure cases, including aliased
  addresses and storage keys.
- **Gate C — PASS:** the local runtime helper was checked against the supplied
  binary; no trusted candidate claim or unproved summary was found.

The result depends on the pinned EVM semantics and the soundness of the K,
Prover, backend, and solver infrastructure. The theorem is about the supplied
runtime; Solidity compiler correctness is outside the proof. Gas accounting is
disabled. See [SCOPE.md](../SCOPE.md) for the complete boundary and
[spec-audit-1.md](spec-audit-1.md) for the specification review.

Raw session transcripts are not bundled. Run [prove.sh](../prove.sh) to create
fresh results.
