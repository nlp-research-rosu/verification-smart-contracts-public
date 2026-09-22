# HKG `approve` verification scope

## Program boundary

The entry computation is `#execute` at program counter zero over the exact
2,091 runtime bytes in `/app/contract.bin` (SHA-256
`71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`).
The call data is the canonical Solidity ABI encoding of
`approve(address,uint256)`. The theorem covers dispatch, argument decoding,
the `allowed[msg.sender][spender]` write, the `Approval` log, Boolean return,
and the dispatcher's unsuccessful nonpayable and static-call paths. It does
not make claims about any other selector in the complete Solidity source.

## Input domain

`CONTRACT`, `CALLER`, and `SPENDER` range over all 160-bit EVM addresses;
`VALUE` ranges over every 256-bit unsigned value; and `STORAGE` and `LOGS` are
fully symbolic initial contract storage and log lists. Successful calls have
zero call value and non-static context. Unsuccessful canonical calls cover
(1) every nonzero 256-bit call value, with either static flag, and (2) every
zero-value static context. Calldata shorter than or different from the
canonical ABI call is outside the boundary because it is not an invocation of
the selected function.

## Observable final state

The theorem observes the EVM status code, return bytes, the entire contract
storage map, and the entire log list. For success, exactly
`keccak(spender ++ keccak(caller ++ slot(allowed)))` at Solidity storage slot
2 is overwritten with `VALUE`; all other storage is framed. The exact
`Approval(address,address,uint256)` topic list and 32-byte data word are
appended, and the ABI return is the 32-byte word `1`. On either unsuccessful
path, storage and logs are unchanged and output is empty. The final program
counter, stack, memory, memory size, remaining gas, refund, access tracking,
and other environmental cells are not user-visible results of this function
and are intentionally unobserved.

## Intended property

For any symbolic owner/caller, spender, amount, and prior storage, a canonical
ordinary call implements the source assignment
`allowed[msg.sender][spender] = value`, emits the source `Approval` event, and
returns `true`. A call that violates the compiler-generated nonpayable guard
reverts without state or log changes, and a static call fails with
`EVMC_STATIC_MODE_VIOLATION` before the attempted write changes state.

## Chosen contract readings

- The source comment's “otherwise failure” is read through implemented
  bytecode behavior: the function body has no false-return branch, while the
  dispatcher can revert for nonzero call value and EVM static mode can reject
  its write. The claims describe those implemented failures instead of
  inventing a Boolean `false` return.
- The schedule is fixed to `BYZANTIUM`, the earliest fork among the bundled
  semantics that supports the emitted `REVERT` opcode. This bytecode uses no
  later fork-dependent opcode.
- Gas accounting is disabled (`<useGas> false`) so the theorem states
  functional partial correctness rather than a minimum-gas theorem. Out-of-gas
  is therefore not part of the unsuccessful-call partition.
- Call entry is the direct runtime-bytecode EVM frame: program and valid jump
  destinations are exact, program counter/memory/memory-use are initialized to
  zero, and the operand stack starts empty. Call depth, balances, origin, block
  fields, transaction finalization, and account code are unobserved because
  the selected implementation path neither reads them nor makes them part of
  the requested function result.
- `contract.sol` is used to identify source-level storage slot 2 and event
  intent; `contract.bin` is the execution artifact actually proved.
