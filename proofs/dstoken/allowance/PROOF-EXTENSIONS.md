# Construction proof-extension record

## Candidate-defined items

### `#dstokenRuntime`

- Class: definitional summary of the immutable program bytes.
- Semantic role: names the exact runtime input; it does not replace an EVM execution step.
- Domain: nullary constant.
- Matched context: none; the equation rewrites only the constant.
- Justification scope and containment: the decoded 6,955-byte literal is byte-for-byte equal to `/app/contract.bin`.
- State footprint: none.
- Value influence: selects all executed bytecode.
- Value justification: decoded SHA-256 `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`, identical to the target file.
- Dependents: both reachability claims.
- Validation: direct byte equality and hash check recorded in `audits/spec-audit-1.md`.

## Proof-only additions

None. The `VERIFICATION` module adds no candidate rule, claim, simplification, operational bridge, or trusted primitive. It imports the pinned semantics’ bundled `LEMMAS` module as prescribed by KIT’s EVM pattern.

## Trust declarations

None. The passing proof used no `--trusted` claims.

