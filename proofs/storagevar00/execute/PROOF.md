STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# Proof result — `storagevar00:execute`

Both claims in `spec.k` were validated and proved for the supplied 161-byte runtime, SHA-256 `d4f641117a2c9887cd8788c822a2b80852c6664e52f60f2b27e5e6300dbf2172`, under the pinned EVM semantics revision `4f4c3843076c` and CANCUN schedule with gas accounting disabled.

## Proved behaviors

- Every canonical zero-value `execute()` call from an in-range symbolic contract address and arbitrary complete symbolic storage map terminates successfully, returns the ABI word for slot 0 (zero when absent), and preserves storage.
- Every canonical call with a nonzero uint256 value and the same symbolic address and storage map reverts with empty output and preserves storage.

These are universal symbolic results over the domains in [SCOPE.md](SCOPE.md), not finite tests.

## Independent audit

The specification review and independent proof audit both pass. The candidate has one definitional helper for the exact runtime bytes; it supplies the executed program and jump-destination calculation without replacing EVM execution. No operational bridge or trusted claim is added.

Gate A passed: validation and both target proofs succeeded. A false-output mutation and a changed-runtime mutation were each validated and rejected by proof on the output cell. Gate B passed: the claims cover arbitrary full storage, including an absent slot 0, and the complete zero/nonzero call-value split. Gate C passed within the stated trust boundary.

The result depends on the pinned EVM model and proof backend and on the supplied bytecode being the intended runtime. Solidity compiler correctness, finite-gas thresholds, deployment, malformed calldata, other selectors, and whole-transaction behavior are outside scope.

See [SCOPE.md](SCOPE.md) for the entry state and exclusions, and [audits/](audits/) for the specification reviews and independent audit conclusions.
