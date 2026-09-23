# Independent proof audit

VERDICT: PASS
REASON: Both symbolic totalSupply claims close under the pinned runtime and semantics; the candidate theory is sound within scope, the negative controls fail meaningfully, and Gates A, B, and C pass.

## Audited result

An independent replay completed both claims under evm revision 4f4c3843076c and Shanghai. False-result and changed-body controls were rejected. The bytecode constant matches the supplied runtime.

## Gate findings

- Gate A — PASS. The proof executes the exact runtime with no unsound candidate extension or operational shortcut.
- Gate B — PASS. Both symbolic canonical-call branches preserve the full storage and nonzero-call-value domains.
- Gate C — PASS. The assumptions, exclusions, and trusted toolchain are stated in [SCOPE.md](../SCOPE.md).

## Limit

The theorem is conditional on the pinned EVM semantics, K/KEVM prover/backend, and solver. It does not prove compiler correctness or finite-gas behavior.
