# Independent proof audit: `balanceOf`

**VERDICT: PASS — final status VALIDATED.**

The audit independently replayed the two symbolic claims for the supplied
runtime under `evm@4f4c3843076c`. Its findings were:

- **Gate A — PASS:** both claims close; positive witnesses exercised the
  successful path, and false-result, wrong-status, and body mutations were
  discriminated. The separate reference-context probe also closed.
- **Gate B — PASS:** the success and nonpayable-failure claims match the stated
  decoder, storage, and return-value domain. The comparison found that the
  candidate's returned balance and unchanged selected storage correspond to the
  reference balance property on its stated domain; the candidate additionally
  proves the nonpayable-revert case.
- **Gate C — PASS:** no unproved candidate extension was found; the trust
  boundary and comparison assumptions were reviewed.

The result depends on the pinned EVM semantics and the soundness of the K,
Prover, backend, and solver infrastructure. The theorem is about the supplied
runtime; Solidity compiler correctness is outside the proof. Gas accounting is
disabled. See [SCOPE.md](../SCOPE.md) for the complete boundary and
[spec-audit-2.md](spec-audit-2.md) for the specification review.

Raw session transcripts are not bundled. Run [prove.sh](../prove.sh) to create
fresh results.
