STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — DSToken:transferFrom

## Result

The seven symbolic claims in [spec.k](spec.k) were validated and independently replayed against the exact 6,955-byte runtime in [contract.bin](contract.bin), SHA-256 65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82. The pinned EVM semantics revision is 4f4c3843076c under Shanghai, with gas accounting disabled.

The claims cover canonical transferFrom calls with positive value, stopped state, insufficient source balance, insufficient caller allowance, destination overflow, distinct-address success, and self-transfer success. Successful execution returns true, updates the relevant balances and allowance, appends the exact LogNote and Transfer events, and returns outer call flag 1. Failures reach the specified INVALID or REVERT behavior, roll back storage and logs, and return outer call flag 0. [SCOPE.md](SCOPE.md) records the full domain and call boundary.

## Proof extensions and independent audit

The candidate definitions name the supplied runtime, ABI calldata, storage locations, stopped-byte predicate, and event terms. They are definitional summaries; they do not replace execution or assert a result. The independent audit reports Gate A, Gate B, and Gate C as PASS. It replayed all seven claims and rejected a false-return mutation.

- Gate A — PASS: the fixed semantics executes the actual runtime through dispatch, state updates, events, returns, exceptional control, and rollback.
- Gate B — PASS: the complete canonical branch partition is covered for symbolic values and storage. Hash-based storage-location disequalities are explicit assumptions, not a proved collision-resistance result.
- Gate C — PASS: the trust boundary and model exclusions are recorded, and finite checks are not presented as universal proof.

## Trust and limits

The theorem is conditional on the pinned EVM semantics, K/KEVM prover and backend, and solver. Under Shanghai, token execution addresses 1 through 9 are precompiles and are outside the runtime-execution domain. The result targets contract.bin and does not prove compiler correctness. Malformed calldata, finite-gas behavior, alternate forks, deployment, and complete transaction processing are excluded. See [SCOPE.md](SCOPE.md).
