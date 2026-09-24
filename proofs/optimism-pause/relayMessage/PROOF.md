# PROOF.md — L1CrossDomainMessenger:relayMessage

## Result

The symbolic claim was machine-checked with result `proved`, exit code 0, and no residual against the supplied implementation runtime, SHA-256 `27d48068a43f90cd262440f294fd5eaf96028f372c69c1fc37e4866ccdb6e1f2`, under EVM semantics `4f4c3843076c`. This one-claim file extracts the unchanged claim body from the six-operation module that was proved; the extracted file was not separately replayed.

The claim requires reversion with the exact pause error, unchanged target storage, balance, nonce and code, and unchanged initial logs.

## Independent audit

The original six-operation module received an independent KIT proof audit. The audit checked the supplied runtime definitions, replayed all six claims, and rejected a false-status control. It found sound execution but limited scope. This function is one of those six original claims. See [audits/proof-audit-1.md](audits/proof-audit-1.md).

## Trust and limits

The result depends on the pinned EVM semantics, K/KEVM prover and solver, and supplied runtime. The claim assumes a true pause response; separate dependency claims prove that response under their own conditions, without a combined composition proof. The pinned ABI helper caps other dynamic bytes at 2³⁰, while RV's reference uses 2⁶³. Source-to-bytecode compilation, deployed-proxy execution, malformed calldata, and finite-gas behavior are outside scope. See [SCOPE.md](SCOPE.md).
