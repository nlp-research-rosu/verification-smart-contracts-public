STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — DSToken:approve

## Result

The three symbolic claims in [spec.k](spec.k) were validated and independently replayed against the exact 6,955-byte runtime in [contract.bin](contract.bin), SHA-256 65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82. The pinned EVM semantics revision is 4f4c3843076c under Cancun, with gas accounting disabled.

For canonical direct calls, zero-value approval while the token is running writes the caller's allowance for the spender, emits LogNote followed by Approval, and returns true. A stopped token reaches INVALID before writing or logging. Any nonzero call value reaches the nonpayable REVERT before the stopped check. The claims cover symbolic addresses, amounts, storage, and existing logs as stated in [SCOPE.md](SCOPE.md).

## Proof extensions and audit

The candidate definitions name the exact runtime, canonical calldata, the allowance storage location, the packed stopped byte, and the two success logs. They are terminating definitions; none replaces an EVM step or supplies a claimed result.

The independent audit reports Gate A, Gate B, and Gate C as PASS. It replayed all three claims and rejected a false-output mutation. The final specification audit also checked the stopped-byte predicate against its packed-storage interpretation.

- Gate A — PASS: execution uses the supplied runtime with no operational bridge or trusted candidate claim.
- Gate B — PASS: symbolic addresses, amounts, and storage remain in scope; stopped and nonpayable branches are both covered.
- Gate C — PASS: the pinned model, assumptions, and exclusions are recorded.

## Trust and limits

The theorem is conditional on the pinned EVM semantics, K/KEVM prover and backend, and solver. Mapping keys are interpreted by the fixed semantics; hash-collision resistance is not proved. The result targets contract.bin and does not prove Solidity compiler correctness. Malformed calldata, static calls, finite-gas behavior, deployment, and surrounding transaction processing are excluded. See [SCOPE.md](SCOPE.md).
