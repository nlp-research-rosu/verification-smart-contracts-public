# Specification audit 1

## Scope checked

Reviewed [contract.sol](../contract.sol), [contract.bin](../contract.bin), [spec.k](../spec.k), [verification.k](../verification.k), and [SCOPE.md](../SCOPE.md) under evm revision 4f4c3843076c and Byzantium.

## Adequacy findings

The claims execute the exact runtime from PC 0. The zero-value claim covers all symbolic 160-bit address inputs and arbitrary storage, returns the fixed-semantics lookup at the Solidity balance mapping rooted at slot 1, and preserves storage. The second claim covers every nonzero uint256 call value and requires REVERT, empty output, and unchanged storage.

The candidate imports no result-summary function. The bytecode constant matches the supplied runtime, and the source, dispatch, storage lookup, return behavior, branch partition, and scope limitations agree. Mechanical validation passed.

VERDICT: PASS
REASON: The claims faithfully cover successful zero-value balanceOf calls and all nonzero-value reverts over the stated symbolic domain.
