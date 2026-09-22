# Specification audit: `balanceOf`

**VERDICT: PASS.** This review covers the final claim representation.

The two claims in [spec.k](../spec.k) describe the supplied runtime over the
stated 36-byte decoder domain. The success claim returns the slot-1 balance
word and preserves storage; the nonpayable claim requires an empty-output
revert and unchanged storage. Address masking follows the bytecode, and the
claims use the exact runtime in [contract.bin](../contract.bin). There are no
candidate summary equations or auxiliary proof rules.

The full input, state, schedule, gas, and exclusion boundary is in
[SCOPE.md](../SCOPE.md). Validation passed under `evm@4f4c3843076c`.
