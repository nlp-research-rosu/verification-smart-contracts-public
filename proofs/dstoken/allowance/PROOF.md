STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — DSToken:allowance

## Result

The two symbolic claims in [spec.k](spec.k) were validated and independently replayed against the exact 6,955-byte runtime in [contract.bin](contract.bin), SHA-256 65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82. The pinned EVM semantics revision is 4f4c3843076c under the Byzantium schedule, with gas accounting disabled.

For every canonical call with zero value, allowance returns the storage lookup for the source and spender at the Solidity mapping location rooted at slot 2 and preserves storage. For every nonzero uint256 call value, the runtime reverts with empty output and unchanged storage. Both address arguments, the relevant storage, and the call value domain are symbolic as described in [SCOPE.md](SCOPE.md).

## Independent audit

The independent audit reports Gate A, Gate B, and Gate C as PASS. The proof executes the supplied runtime; its only candidate-specific definition names those exact program bytes. The audit replayed both claims and rejected false-result and changed-program controls.

- Gate A — PASS: the runtime identity and definition were checked, and no candidate rule replaces execution or asserts a result.
- Gate B — PASS: the claims cover the full canonical address and storage domains, zero-value success, and all nonzero call values.
- Gate C — PASS: the pinned semantics, toolchain trust boundary, and scope exclusions are recorded.

## Trust and limits

The theorem is conditional on the pinned EVM semantics, K/KEVM prover and backend, and solver. It targets contract.bin; Solidity source-to-bytecode compiler correctness is not proved. Malformed calldata, finite-gas behavior, deployment, and full transaction processing are outside scope. See [SCOPE.md](SCOPE.md) for the exact boundary.
