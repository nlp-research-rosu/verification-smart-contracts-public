STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — DSToken:transfer

## Result

The twelve symbolic claims in [spec.k](spec.k) were validated and independently replayed against the exact 6,955-byte runtime in [contract.bin](contract.bin), SHA-256 65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82. The pinned EVM semantics revision is 4f4c3843076c under Byzantium, with gas accounting disabled.

Six claims describe direct runtime execution: nonzero value reverts; stopped, insufficient-balance, and distinct-destination-overflow paths raise INVALID; distinct-slot success updates balances; and same-slot success restores the effective balance. Running success appends LogNote followed by Transfer. The raw insufficient-balance and overflow paths retain LogNote, while the stopped and nonpayable paths add no log. The other six claims cover the enclosing message-call boundary for token addresses above 8: success commits state and returns success flag 1, while failure rolls storage and logs back and returns flag 0. [SCOPE.md](SCOPE.md) records the exact branch and state boundaries.

## Independent audit

The independent audit reports Gate A, Gate B, and Gate C as PASS. All twelve claims were replayed. A concrete self-transfer witness succeeded, and false-postcondition and changed-body controls were rejected.

- Gate A — PASS: fixed semantics executes the supplied runtime; the only local rule binds the exact bytecode and does not replace execution.
- Gate B — PASS: the symbolic branch domains are preserved, and the audit checked their relationship to the approved reference behavior under the stated functional-model normalization.
- Gate C — PASS: model assumptions, evidence interpretation, and exclusions are documented.

## Trust and limits

The theorem is conditional on the pinned EVM semantics, K/KEVM prover and backend, solver, and supplied bytecode identity. Source-to-bytecode compiler correctness is not proved. The result excludes finite-gas thresholds, malformed calldata, static calls, deployment, other entry points, and complete transaction processing. Storage-location equality is covered explicitly; see [SCOPE.md](SCOPE.md) for the effective-storage representation boundary.
