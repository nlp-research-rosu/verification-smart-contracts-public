# Specification audit 1

## Scope checked

Reviewed [contract.sol](../contract.sol), [contract.bin](../contract.bin), [spec.k](../spec.k), [verification.k](../verification.k), and [SCOPE.md](../SCOPE.md) under evm revision 4f4c3843076c and Shanghai.

## Adequacy findings

The two claims cover canonical totalSupply calls with symbolic execution account and arbitrary storage. Zero call value returns the slot-0 lookup and preserves the complete storage map; every nonzero uint256 call value reaches REVERT with empty output and unchanged storage.

The supplied bytecode constant matches contract.bin and does not bypass execution. The source declaration, runtime selector and SLOAD behavior, postconditions, model choices, and exclusions agree. Mechanical validation passed.

VERDICT: PASS
REASON: The symbolic claims faithfully state the exact runtime's slot-0 result and complete nonzero-value rejection branch.
