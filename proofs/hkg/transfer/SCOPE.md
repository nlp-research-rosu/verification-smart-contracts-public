# HKG `transfer` verification scope

## Program boundary

The theorem executes the exact 2,091-byte runtime in `/app/contract.bin`, embedded directly as `#parseByteStack("…")`, from program counter 0 with an empty EVM stack and memory. It covers the dispatcher, canonical ABI decoding for `transfer(address,uint256)`, the complete selected function body, return-data encoding, storage operations, and event emission until `#halt`.

The source-side function is `StandardToken.transfer` in `/app/contract.sol`. The supplied runtime is authoritative for implemented behavior; its dispatcher contains selector `0xa9059cbb` and routes it to the transfer body. Transaction-envelope processing after the current EVM frame halts is outside this boundary.

## Input domain

The three claims collectively cover every canonical ABI call to `transfer(address,uint256)` represented by the fixed semantics for:

- symbolic 160-bit contract address `ACCT`, caller `CALLER`, and recipient `TO`;
- every symbolic 256-bit `VALUE`;
- every symbolic contract storage `Map` and initial log `List`;
- zero call value (the function's true/false result cases) and every positive 256-bit call value (the implicit nonpayable rejection).

Execution uses `NORMAL` mode, the `BYZANTIUM` schedule, non-static context, and disabled gas accounting (`<useGas> false </useGas>`). Disabled gas isolates functional behavior and excludes out-of-gas termination. Malformed/noncanonical calldata, other selectors, static-call rejection, and transaction-envelope validation are excluded.

## Observable final state

The theorem observes and constrains:

- EVM status and returned bytes;
- the complete contract storage map, preserving every slot except the sequential writes performed by successful transfer;
- the log list, including the exact ABI `Transfer` event on success and no appended event otherwise.

The final program counter, word stack, local memory, and memory-usage counter are existentially framed because they are internal scratch state and are not part of the function's external behavior. Other configuration and world-state cells are framed unchanged by omission.

## Intended property

For call value zero:

- If `VALUE > 0` and the caller's balance at Solidity mapping slot 1 is at least `VALUE`, execution returns ABI boolean `true`, subtracts `VALUE` from the caller, then adds `VALUE` to the recipient using EVM 256-bit word arithmetic, and appends `Transfer(CALLER, TO, VALUE)`.
- If `VALUE == 0` or the caller's balance is less than `VALUE`, execution returns ABI boolean `false`, leaves storage unchanged, and appends no log.

For positive call value, the runtime's nonpayable guard returns `EVMC_REVERT` with empty output before touching storage or logs.

## Chosen contract readings

- “Successful and unsuccessful calls” includes both the source-level boolean success/failure branches and the compiled nonpayable rejection. These are stated separately because false-return and revert have distinct statuses and outputs.
- Mapping storage is read at `#hashedLocation("Solidity", 1, ADDRESS .IntList)`: inherited `totalSupply` occupies slot 0 and `balances` occupies slot 1, matching both the source layout and runtime SLOAD/SSTORE address construction.
- Successful storage is expressed as two sequential EVM writes. This preserves the implementation's exact self-transfer behavior when `CALLER == TO` (or the two locations otherwise coincide), instead of assuming distinct keys.
- Recipient addition uses `+Word`, so overflow wraps modulo `2^256`, matching Solidity 0.4.x/EVM behavior. Caller subtraction cannot underflow under the success guard.
- `BYZANTIUM` is selected because the supplied runtime contains opcode `REVERT` (`0xfd`) in its nonpayable guards. Gas is disabled rather than assigning an arbitrary gas limit; consequently no gas-consumption or out-of-gas claim is made.
