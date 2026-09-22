STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — DSToken:totalSupply

## Result

The two symbolic claims in [spec.k](spec.k) were validated and independently replayed against the exact 6,955-byte runtime in [contract.bin](contract.bin), SHA-256 65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82. The pinned EVM semantics revision is 4f4c3843076c under Shanghai, with gas accounting disabled.

For canonical calldata, totalSupply returns the slot-0 storage lookup and preserves the complete storage map. Any nonzero uint256 call value reaches REVERT with empty output and unchanged storage. The execution account and storage are symbolic as stated in [SCOPE.md](SCOPE.md).

## Independent audit

The independent audit reports Gate A, Gate B, and Gate C as PASS. The supplied runtime is bound by a bytecode constant definition, and execution follows the actual dispatcher and body. Both claims were replayed; false-result and changed-body controls were rejected.

- Gate A — PASS: the exact runtime executes without a candidate operational bridge or trusted result rule.
- Gate B — PASS: both symbolic canonical-call branches cover the full slot-0 storage value and nonzero-value domains.
- Gate C — PASS: the model trust boundary, assumptions, and exclusions are documented.

## Trust and limits

The theorem is conditional on the pinned EVM semantics, K/KEVM prover and backend, and solver. It targets contract.bin; Solidity compiler correctness is not proved. Malformed calldata, finite-gas behavior, deployment, and transaction-level processing are excluded. See [SCOPE.md](SCOPE.md).
