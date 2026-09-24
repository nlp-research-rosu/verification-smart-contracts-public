# PROOF.md — OptimismPortal2:proveWithdrawalTransaction

## Result

The 11 symbolic claims were machine-checked with result `proved`, exit code 0, and no residual against the supplied implementation runtime, SHA-256 `fd3563d1e8783828d87f745f7e70e485651cfce39b28845bfb1566551cb6d93d`, under EVM semantics `4f4c3843076c`. The original six-operation claim established length 0; separate machine-checked claims established every length 1–10. The combined per-function `spec.k` collects their unchanged claim bodies but has no separate positive aggregate result.

The claims require reversion with the exact pause error, unchanged target storage, balance, nonce and code, and unchanged initial logs.

## Independent audit

The original six-operation module received an independent KIT proof audit. The audit checked the supplied runtime definitions, replayed all six claims, and rejected a false-status control. It found sound execution but limited scope. The ten array claims received a later evidence-only audit of the saved positive results and exact K inputs; it did not complete a fresh clean-room replay. See [audits/proof-audit-1.md](audits/proof-audit-1.md).

## Trust and limits

The result depends on the pinned EVM semantics, K/KEVM prover and solver, and supplied runtime. The claim assumes a true pause response; separate dependency claims prove that response under their own conditions, without a combined composition proof. The pinned ABI helper caps other dynamic bytes at 2³⁰, while RV's reference uses 2⁶³. Source-to-bytecode compilation, deployed-proxy execution, malformed calldata, and finite-gas behavior are outside scope. See [SCOPE.md](SCOPE.md).
