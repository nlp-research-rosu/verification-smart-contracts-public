# PROOF.md — SystemConfig:paused

## Result

The symbolic claim in [spec.k](spec.k) has a retained machine-checked result `proved`, exit code 0, and no residual against the supplied implementation runtime, SHA-256 `135e31ff4a9292c3dbb5162c44c0adaf8c2345cbf09f1ec78a7974a25fe5f9e8`, under pinned EVM semantics `4f4c3843076c`. It establishes successful call returning ABI `true` under its written preconditions.

## Independent audit

No separate KIT proof audit was completed for this dependency claim.

## Trust and limits

The result depends on the pinned EVM semantics, K/KEVM prover and solver, and supplied runtime. It is a separate theorem under the conditions in [SCOPE.md](SCOPE.md); it is not a combined proof with the six paused-operation claims. Deployed-proxy execution and source-to-bytecode compiler correctness are outside scope.
