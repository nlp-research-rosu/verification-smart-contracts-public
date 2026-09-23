# Verification scope

## Program boundary

The claims execute the complete 6,955-byte runtime bytecode in `contract.bin` from program counter 0 through the dispatcher and the implemented `allowance(address,address)` body. The bytecode is named exactly by `#dstokenRuntime` in `runtime.k`; its SHA-256 is `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`. No source-level replacement or function summary bypasses EVM execution.

## Input domain

Both ABI arguments, the contract address, and caller range over all 160-bit addresses. Persistent contract storage is a symbolic K `Map`; the fixed EVM semantics interprets a missing or non-integer queried slot as zero. The success claim uses call value zero. The unsuccessful-call claim covers every nonzero 256-bit call value with the same canonical allowance calldata. Calldata is canonical ABI encoding; malformed selectors and malformed argument encodings, out-of-gas behavior, and transaction-level validation are outside this function-entry theorem.

## Observable final state

For success, the observable result is status `EVMC_SUCCESS`, exactly one ABI word of output, and unchanged persistent storage. The word is the fixed-semantics lookup at Solidity nested-mapping location `keccak256(guy . keccak256(src . uint256(2)))`, expressed by `#hashedLocation("Solidity", 2, SRC GUY)`. For failure, the observable result is `EVMC_REVERT`, empty output, and unchanged persistent storage. Program counter, internal stack, local memory, and memory high-water mark are existentially framed because they are not external call observables; all other unmentioned configuration cells are framed and therefore preserved.

## Intended property

A zero-value canonical call to `allowance(src,guy)` returns `_approvals[src][guy]` without modifying storage. A canonical call carrying nonzero Ether is rejected by the generated nonpayable guard, returns no data, and does not modify storage.

## Chosen contract readings

- “Successful and unsuccessful calls” is read as the implemented canonical ABI call in its admitted zero-value case and its generated nonpayable rejection case. This directly exercises both terminal branches belonging to the allowance dispatcher entry.
- The Solidity storage base slot for `_approvals` is 2. This follows the declared DSTokenBase layout (`_supply` at 0, `_balances` at 1, `_approvals` at 2) and is confirmed by the runtime body at PC `0x11bc`, which hashes slot 2 with `src`, then hashes that result with `guy`, before `SLOAD`.
- The execution schedule is BYZANTIUM because the supplied legacy runtime uses the Byzantium `REVERT` opcode in its nonpayable guard and no later-fork opcode is needed. Gas is disabled so the theorem isolates functional behavior from a caller-selected gas bound.
- Call context is a direct, non-static call with symbolic well-formed contract and caller addresses, zero-value success or nonzero-value failure, empty initial stack and memory, and program counter 0.
- The theorem is partial correctness under the pinned `evm` semantics revision `4f4c3843076c`: termination itself is not claimed.

