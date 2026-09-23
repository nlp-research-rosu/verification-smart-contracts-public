# Specification audit 4

## Scope checked

Reviewed [contract.sol](../contract.sol), [contract.bin](../contract.bin), [spec.k](../spec.k), [verification.k](../verification.k), and [SCOPE.md](../SCOPE.md) under evm revision 4f4c3843076c and Byzantium.

## Adequacy findings

All twelve approved claims remain present. For same-slot success, the exact two writes first subtract the amount and then restore the original effective balance; every other map value is preserved. This accurately states the supplied runtime's behavior even when a missing zero-valued entry becomes explicit. Distinct-slot, failure, event, and enclosing-call rollback claims remain unchanged.

The runtime definition is a byte constant, not an execution shortcut. The symbolic branch domains, source behavior, storage representation, and stated reference normalization and exclusions agree. Mechanical validation passed.

VERDICT: PASS
REASON: The final two-write postcondition preserves effective storage and the approved reference domain.
