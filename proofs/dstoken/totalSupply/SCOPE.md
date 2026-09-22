# Verification scope

## Program boundary

The theorem executes the exact 6,955-byte runtime image in `contract.bin`
(SHA-256 `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`)
from EVM program counter 0 with an empty stack and memory.  The
candidate-specific `DSTOKEN-BIN` definition binds `#binRuntime(DSTOKEN)`
byte-for-byte to that image.  The entry calldata is the canonical ABI selector
for `totalSupply()`; execution includes the bytecode dispatcher and the
implemented function body through `#halt`.

## Input domain

The success claim covers every symbolic contract address in the 160-bit address
range and every well-formed symbolic EVM storage map when call value is zero.
The unsuccessful-call claim covers the same symbolic addresses and storage maps
for every nonzero `uint256` call value.  `totalSupply()` has no Solidity
arguments, so canonical calldata has no argument words.  Malformed selectors,
short calldata, and trailing noncanonical calldata are excluded because they
are not ABI calls to this function.

## Observable final state

The observed results are final EVM status, return-data bytes, and the complete
storage map of the executing account.  On success the status is
`EVMC_SUCCESS`, the output is the 32-byte ABI encoding of
`#lookup(STORAGE, 0)`, and storage is unchanged.  On nonzero-value failure the
status is `EVMC_REVERT`, output remains empty, and storage is unchanged.
The final PC, stack, memory, and memory high-water mark are execution internals
and are intentionally existentially framed because the requested function
contract does not observe them.  All other configuration cells are framed and
unobserved.

## Intended property

A zero-value canonical call to the implemented `totalSupply()` returns the
uint256 stored at slot 0 without changing storage.  A canonical call carrying
any nonzero uint256 value is rejected by the compiler-generated nonpayable
guard with empty revert data and without changing storage.

## Chosen contract readings

- The supplied runtime bytecode, not recompilation of `contract.sol`, is the
  executable under verification; the source identifies slot 0 as
  `DSTokenBase._supply`, and the bytecode body at offset `0x0957` performs
  `SLOAD 0`.
- “Successful and unsuccessful calls” is read as the two behaviors of this
  function's compiler-generated nonpayable entry: zero call value succeeds and
  nonzero call value reverts.  Calls with a different selector are calls to
  another dispatcher branch (or fallback), not calls to `totalSupply()`.
- The EVM schedule is `SHANGHAI`; this legacy bytecode uses no
  fork-sensitive opcode whose meaning changes the stated behavior.
- Execution uses `NORMAL` mode with gas accounting disabled
  (`<useGas> false`).  This proves functional behavior independently of a gas
  limit and does not claim an exact gas cost or out-of-gas behavior.
- The current call is non-transactional direct runtime execution beginning at
  PC 0.  Caller, origin, block fields, balances, code stored in the account,
  logs, and other accounts are not read by either covered path and are framed.

