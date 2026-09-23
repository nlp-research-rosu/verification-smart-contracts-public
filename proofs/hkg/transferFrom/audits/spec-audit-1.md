# Specification audit: `transferFrom`

**VERDICT: PASS.** The final specification faithfully states the scoped
behavior of the supplied runtime.

The four claims in [spec.k](../spec.k) partition canonical zero-value,
non-static `transferFrom` calls into success and the zero-value, insufficient balance, and insufficient-allowance failure cases. They model the sequential
balance and allowance updates, `Transfer` log, and aliased keys without adding
address-distinctness assumptions. The local runtime helper matches
[contract.bin](../contract.bin) byte-for-byte.

The full input, state, schedule, gas, and exclusion boundary is in
[SCOPE.md](../SCOPE.md). Validation passed under `evm@4f4c3843076c`.
