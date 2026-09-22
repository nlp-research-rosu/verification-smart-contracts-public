# Specification audit: `allowance`

**VERDICT: PASS.** The final specification faithfully states the scoped
behavior of the supplied runtime.

The two symbolic claims in [spec.k](../spec.k) cover canonical
`allowance(address,address)` calls for arbitrary in-range addresses and
symbolic storage. At zero call value they return the selected slot-2 mapping
word and preserve storage; at nonzero call value they revert with empty output
and preserve storage. The embedded runtime matches [contract.bin](../contract.bin)
byte-for-byte. No candidate summary or auxiliary proof rule changes the claim.

The full input, state, schedule, gas, and exclusion boundary is in
[SCOPE.md](../SCOPE.md). Validation passed under `evm@4f4c3843076c`.
