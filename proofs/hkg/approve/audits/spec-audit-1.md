# Specification audit: `approve`

**VERDICT: PASS.** The final specification faithfully states the scoped
behavior of the supplied runtime.

The three symbolic claims in [spec.k](../spec.k) cover canonical
`approve(address,uint256)` calls over in-range addresses, amounts, and symbolic
storage and logs. They describe the allowance update, `Approval` event and
true return; nonpayable reversion; and static-write failure. The local bytecode
helper matches [contract.bin](../contract.bin) byte-for-byte. No extra summary
meaning is introduced.

The full input, state, schedule, gas, and exclusion boundary is in
[SCOPE.md](../SCOPE.md). Validation passed under `evm@4f4c3843076c`.
