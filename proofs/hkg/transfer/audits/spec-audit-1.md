# Specification audit: `transfer`

**VERDICT: PASS.** The final specification faithfully states the scoped
behavior of the supplied runtime.

The three claims in [spec.k](../spec.k) partition canonical `transfer` calls
into successful positive transfers, false returns for zero or insufficient
balance, and nonpayable reverts. They preserve the bytecode's sequential
storage updates, EVM word arithmetic, and `Transfer` log behavior, including
aliased storage keys. The claims use the exact runtime in
[contract.bin](../contract.bin) and add no candidate summary meaning.

The full input, state, schedule, gas, and exclusion boundary is in
[SCOPE.md](../SCOPE.md). Validation passed under `evm@4f4c3843076c`.
