STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# Proof result — `DSValue:peek() / read()`

All five claims in `spec.k` were validated and proved for the supplied 2,874-byte runtime, SHA-256 `21c8127cb5702347f975ff7668975d24547bd1fe2cd0532443e2b5375dc98797`, under the pinned EVM semantics revision `4f4c3843076c` and ISTANBUL schedule.

## Proved behaviors

- `peek()` with zero call value returns the slot-2 value and whether the has byte in slot 1 is nonzero, ABI-encoded as two words.
- `read()` with zero call value returns the slot-2 value when the has byte is nonzero. Its gas-cost metadata decreases by exactly 2,043 under the infinite-gas model.
- `read()` with zero call value and a zero has byte reverts with `Error("haz-not")`.
- Either selector with nonzero call value reverts with empty output.
- Every claim preserves the complete current-account storage map.

The storage map, caller, current account, static flag, and call value are symbolic within the ranges stated in [SCOPE.md](SCOPE.md). The selector may be followed by up to 1,250,000,000 arbitrary calldata bytes. The five claims are universal symbolic results, not finite tests.

## Independent audit

The specification review and independent proof audit both pass. The audit confirmed that the claims execute the supplied runtime and that the three candidate helpers are definitional summaries: the exact runtime bytes, the packed has-byte projection, and the concrete revert payload. No candidate rule replaces EVM execution, and no trusted claim is added.

Gate A passed: six ground witnesses cover the target paths, and validated false-postcondition and changed-runtime mutations were rejected as not proved. Gate B passed: the stated domains and outcomes cover the reference peek/read behaviors; a separate symbolic context probe proved the relevant success outcomes with arbitrary initial output, status, and continuation. Gate C passed within the stated trust boundary.

The proof depends on the pinned EVM model and proof backend. It proves bytecode execution from the stated call configuration, not Solidity compiler correctness, finite-gas sufficiency, or whole-transaction behavior. Other forks, selectors, short calldata, and mutating or authentication methods are outside scope.

See [SCOPE.md](SCOPE.md) for the entry state and exclusions, and [audits/](audits/) for the specification review and independent audit conclusions.
