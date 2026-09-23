# Specification audit: `totalSupply`

**VERDICT: PASS.** The final claim accurately describes the supplied runtime's
implemented behavior.

The single claim in [spec.k](../spec.k) covers every canonical
`totalSupply()` call in the stated symbolic account, call-value, storage, and
log domain. The runtime has no `totalSupply()` selector branch, so the claim
requires an empty-output revert and unchanged storage and logs. The Solidity
source contains a state variable but no getter; the discrepancy is explicit,
and no slot-zero getter is claimed. The claim uses the exact runtime in
[contract.bin](../contract.bin), with no candidate summary equations.

The full input, state, schedule, gas, and exclusion boundary is in
[SCOPE.md](../SCOPE.md). Validation passed under `evm@4f4c3843076c`.
