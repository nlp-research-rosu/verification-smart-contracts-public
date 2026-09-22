# Verification scope

## Program boundary

The entry computation is direct EVM runtime execution from `#execute` at program counter 0, using the exact 161 bytes in [contract.bin](contract.bin) (SHA-256 `d4f641117a2c9887cd8788c822a2b80852c6664e52f60f2b27e5e6300dbf2172`). The claims cover the canonical ABI call to Solidity `storagevar00.execute()` through normal `RETURN`, and its nonpayable rejection through `REVERT` when the call value is nonzero. Constructor behavior, deployment, other selectors, short or trailing calldata, and transaction-level accounting are outside this function boundary.

## Input domain

`execute()` has no Solidity parameters. Its calldata is the canonical four-byte ABI encoding `#abiCallData("execute", .TypedArgs)`. The contract account `ACCT` is symbolic and constrained to the address range. `STORAGE` is an arbitrary complete EVM storage map; slot 0 may be present with any uint256 or absent, in which case `#lookup(STORAGE, 0)` is zero. The success claim fixes call value to zero. The unsuccessful claim takes an arbitrary nonzero uint256 call value. Caller, origin, static flag, block fields, balances, other accounts, and storage outside slot 0 are unconstrained because the bytecode path neither branches on nor changes them.

## Observable final state

The observed cells are `<statusCode>`, `<output>`, and the contract account's `<storage>`. Successful execution has `EVMC_SUCCESS`, returns the single ABI uint256 word `#buf(32, #lookup(STORAGE, 0))`, and preserves all storage. A nonzero-value call has `EVMC_REVERT`, returns empty output, and preserves all storage. The final program counter, stack, local memory, gas, and memory high-water mark are existentially framed because they are internal implementation state, not Solidity call observables. All other omitted cells are unobserved and framed by the configuration abstraction.

## Intended property

For every well-formed symbolic EVM storage map, a canonical zero-value call to `execute()` terminates successfully and ABI-returns the slot-0 lookup (zero when absent) without changing storage. For every symbolic nonzero uint256 call value, the same canonical call terminates with a revert, empty output, and unchanged storage.

## Chosen contract readings

- “The execute function” is read as canonical ABI invocation of `execute()` against the supplied runtime bytecode, not arbitrary fallback dispatch. This keeps malformed, short, selector-mismatched, and trailing calldata outside the function-call domain.
- “Successful and unsuccessful calls” is read as the bytecode's implemented nonpayable split: value 0 succeeds and every in-range nonzero value reverts.
- The theorem uses the `CANCUN` schedule selected by the bundled EVM runner and disables gas accounting. Thus it establishes functional behavior assuming sufficient gas, not an out-of-gas threshold or gas-consumption result.
- Direct runtime execution is used instead of a whole transaction. Balances, nonce, refunds, warm/cold access bookkeeping, and transaction finalization are therefore not observables.
- The complete storage map is symbolic. Slot 0 may be explicitly present or absent; the semantics' total `#lookup` models EVM's zero default and covers both representations.
