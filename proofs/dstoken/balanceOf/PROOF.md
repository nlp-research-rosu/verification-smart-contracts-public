STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — DSToken:balanceOf

## Result

The two symbolic claims in [spec.k](spec.k) were validated and independently replayed against the exact 6,955-byte runtime in [contract.bin](contract.bin), SHA-256 65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82. The pinned EVM semantics revision is 4f4c3843076c under Byzantium, with gas accounting disabled.

A canonical zero-value balanceOf call returns the storage lookup at the Solidity balance mapping rooted at slot 1 and preserves storage. Every nonzero uint256 call value reaches REVERT with empty output and unchanged storage. The address, caller, contract account, and storage remain symbolic under the domain stated in [SCOPE.md](SCOPE.md).

## Independent audit

The independent audit reports Gate A, Gate B, and Gate C as PASS. The claims execute the exact runtime from its dispatcher through the return or revert path. The audit replayed both claims and rejected false-output, body, and revert-status controls.

- Gate A — PASS: the runtime pin is exact and no candidate rule substitutes for execution.
- Gate B — PASS: the canonical address and storage domain is symbolic, and zero versus every nonzero call value is covered.
- Gate C — PASS: assumptions, exclusions, and the prover/toolchain trust boundary are stated.

## Trust and limits

The result is conditional on the pinned EVM semantics, K/KEVM prover and backend, and solver. It targets contract.bin; source-to-bytecode compiler correctness is not proved. Malformed or trailing calldata, other selectors, finite-gas behavior, deployment, and transaction-level processing are excluded. See [SCOPE.md](SCOPE.md).
