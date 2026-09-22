# Verification scope: `DSToken.balanceOf(address)`

## Program boundary

The entry computation is direct EVM execution (`#execute`) from program counter 0 of the exact 6,955-byte runtime in `/app/contract.bin` (SHA-256 `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`). The claims cover dispatcher selection of `balanceOf(address)`, the generated nonpayable-value guard, ABI argument decoding, Solidity mapping-slot calculation, `SLOAD`, ABI return encoding, and the terminal `RETURN` or `REVERT`; there are no source-level loops in this function.

The source implementation is `return _balances[src]`. Inspection of the supplied runtime pins `_balances` to Solidity mapping base slot 1: the selected function body pushes slot 1 before hashing the 32-byte address key and slot word.

## Input domain

Both claims quantify symbolically over every canonical ABI `address` argument `WHO`, every valid contract address `ACCT`, every valid caller address `CALLER`, and an arbitrary KEVM storage map `STORAGE`. The success claim has call value 0. The failure claim covers every nonzero 256-bit call value. Thus the claims cover both branches of the runtime's generated `CALLVALUE; ISZERO; JUMPI` guard for canonical `balanceOf(address)` calldata.

Excluded inputs are malformed/noncanonical calldata, unknown selectors, negative or wider-than-256-bit call values, invalid account identifiers, transaction-envelope validation, constructor execution, and calls to other exported functions. Exact canonical calldata is used; trailing bytes are outside this theorem. Those exclusions do not narrow the Solidity ABI input type of `balanceOf(address)`, which consists of one canonical 160-bit address argument, but they do exclude dispatcher behavior that is not a canonical call to this function.

## Observable final state

For a zero-value call, the observed final status is `EVMC_SUCCESS` and output is the single 32-byte ABI word equal to `#lookup(STORAGE, #hashedLocation("Solidity", 1, WHO .IntList))`. `#lookup` includes both present entries and the EVM default zero for an absent storage key. For a nonzero-value call, the observed final status is `EVMC_REVERT` and output remains empty.

The active account's storage is present without a rewrite on both sides of each claim, so it must be unchanged. Other world state is framed and unobserved because this read-only body and its value guard do not define a user-visible state transition. Final PC, internal operand stack, memory, and memory-used counter are existentially unconstrained because they are execution internals, while the program, jump-destination table, call context, gas cell, and selected account storage are preserved.

## Intended property

If execution terminates from the stated runtime-entry configuration, a canonical zero-value call returns exactly the balance stored for the symbolic address and does not change storage. The same canonical call with any nonzero valid call value reverts with empty output and does not change storage.

## Chosen contract readings and execution model

- "Successful and unsuccessful calls" is read as the two implemented paths of this function's generated nonpayable call-value check: value zero succeeds and every nonzero valid value reverts. This is directly visible in the supplied bytecode wrapper.
- The proof concerns the compiled runtime, with the Solidity source used to identify the intended function and the `_balances` mapping. The runtime bytes, not recompilation, are authoritative.
- The EVM schedule is `BYZANTIUM`, the earliest bundled schedule that recognizes the emitted `REVERT` opcode; the relevant opcodes have the same value behavior on later schedules when gas is disabled.
- Gas accounting is disabled (`<useGas> false`) and gas starts at 0. Therefore the theorem proves functional behavior in an unmetered execution and excludes out-of-gas behavior.
- The call is a direct non-static EVM runtime call at depth 0, with symbolic valid caller and contract addresses, call value as split above, empty initial stack and memory, and computed valid jump destinations. The function performs no write, so choosing non-static rather than static context does not alter its successful behavior.
- The result is a partial-correctness statement: termination is not asserted independently, although the remote proof symbolically executes each covered path to `#halt`.
