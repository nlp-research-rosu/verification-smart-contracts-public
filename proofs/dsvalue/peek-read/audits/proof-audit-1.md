# Independent proof audit — DSValue `peek()` and `read()`

## Findings

**Gate A — PASS.** The five claims execute the supplied runtime from PC 0. Its bytes match the packaged binary and the reference runtime. The three helper equations name the exact runtime, project the has byte from slot 1, and encode the specified error payload; each is a total, nonrecursive definition. There are no operational bridges, opaque result terms, or trusted claims. Six ground witnesses cover the target paths. A false postcondition and a runtime-byte mutation both validated as claims but were rejected by proof with a failing observable result.

**Gate B — PASS for the stated reference behaviors.** The candidate covers the calldata suffix domain, ISTANBUL gas model, successful-read gas decrement, storage mapping, and return/revert outcomes. Its symbolic storage domain includes the reference's packed owner/Boolean states. A separate symbolic context probe established the relevant success outcomes with arbitrary initial output, status, and continuation. No original reference proof logs were supplied, so no historical reference proof result is inferred.

**Gate C — PASS within the named trust boundary.** The conclusion depends on the pinned EVM semantics, bundled definitions, K/KEVM execution and proof backend, and the supplied runtime as the target program. Solidity compilation, finite-gas sufficiency, and transaction setup/finalization are outside the theorem. Exact program identity and the finite witness and mutation checks support the audit but do not replace the symbolic proofs.

## Verdict

**PASS.** The package validation and five target claims succeed. The independent context probe and witnesses succeed, while both negative mutations are rejected as not proved. No unsound extension, vacuous target claim, or missing behavior within the stated model was identified.
