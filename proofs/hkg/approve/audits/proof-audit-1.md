# Independent proof audit: `approve`

**VERDICT: PASS — final status VALIDATED.**

The audit independently replayed the three symbolic claims for the supplied
runtime under `evm@4f4c3843076c`. Its findings were:

- **Gate A — PASS:** all three claims close; the fresh false-output mutation
  was rejected with the expected unmet condition.
- **Gate B — PASS:** the claims preserve the approved symbolic domain and
  accurately describe allowance storage, the `Approval` event, nonpayable
  reversion, and static-write failure.
- **Gate C — PASS:** the local bytecode helper was checked against the supplied
  runtime; the proof-extension inventory and trust boundary were reviewed.

The result depends on the pinned EVM semantics and the soundness of the K,
Prover, backend, and solver infrastructure. The theorem is about the supplied
runtime; Solidity compiler correctness is outside the proof. Gas accounting is
disabled. See [SCOPE.md](../SCOPE.md) for the complete boundary and
[spec-audit-1.md](spec-audit-1.md) for the specification review.

Raw session transcripts are not bundled. Run [prove.sh](../prove.sh) to create
fresh results.
