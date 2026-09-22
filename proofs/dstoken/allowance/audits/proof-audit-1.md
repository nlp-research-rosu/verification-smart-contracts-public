# Independent proof audit

VERDICT: PASS
REASON: Gates A, B, and C pass for the two allowance reachability claims under the stated pinned-semantics and toolchain trust boundary.

## Audited result

An independent clean-room replay completed both symbolic claims against the supplied runtime under evm revision 4f4c3843076c and Byzantium. The audit also rejected false-result and changed-program controls. The exact audited inputs and limits are [spec.k](../spec.k), [verification.k](../verification.k), and [SCOPE.md](../SCOPE.md).

## Gate findings

- Gate A — PASS. The proof executes the supplied runtime; the only candidate-specific rule is its exact bytecode constant. No operational bridge or trusted result claim is present.
- Gate B — PASS. The claims retain the full canonical address, storage, and call-value domains and match the allowance source behavior.
- Gate C — PASS. The semantics, prover/backend, solver, and fixed cryptographic primitives form the trust boundary. Scope exclusions are explicit.

## Limit

This proves partial correctness under the pinned EVM model. It does not establish Solidity compiler correctness or finite-gas behavior.
