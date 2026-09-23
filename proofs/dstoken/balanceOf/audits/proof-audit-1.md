# Independent proof audit

VERDICT: PASS
REASON: Gates A, B, and C pass; the independently replayed proof is VALIDATED within the stated pinned EVM model and scope.

## Audited result

An independent replay completed both balanceOf claims against the supplied runtime under evm revision 4f4c3843076c and Byzantium. False-output, false-status, and changed-body controls were rejected on satisfiable paths.

## Gate findings

- Gate A — PASS. The exact runtime executes through its dispatcher and return/revert behavior; no candidate bridge replaces program behavior.
- Gate B — PASS. The claims cover the full symbolic canonical address and storage domain and partition zero versus every nonzero uint256 call value.
- Gate C — PASS. The model assumptions, trust boundary, and exclusions are recorded in [SCOPE.md](../SCOPE.md).

## Limit

The result relies on the pinned EVM semantics, K/KEVM prover/backend, and solver. It is a partial-correctness result for contract.bin and does not prove source-to-bytecode compiler correctness.
