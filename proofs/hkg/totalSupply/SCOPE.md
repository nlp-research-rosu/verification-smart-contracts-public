# Verification scope

## Program boundary

The entry computation starts at the pinned runtime EVM entry convention with
the exact runtime in `<program>`, its computed valid jump destinations,
program counter 0, and empty EVM stack and memory. The runtime image is the
exact 2,091 bytes of [contract.bin](contract.bin), embedded directly in `spec.k`. The
canonical ABI calldata is for `totalSupply()` (selector `0x18160ddd`).

The runtime dispatcher recognizes only `approve(address,uint256)`
(`0x095ea7b3`), `transferFrom(address,address,uint256)` (`0x23b872dd`),
`balanceOf(address)` (`0x70a08231`), `transfer(address,uint256)`
(`0xa9059cbb`), and `allowance(address,address)` (`0xdd62ed3e`). It does not
recognize `totalSupply()`. Consequently the requested call takes the fallback
path at byte offsets `0x006d`--`0x0071` and executes `REVERT(0,0)` without
entering any program-defined function body.

## Input domain

`totalSupply()` has no ABI arguments. The symbolic claim covers all well-formed
256-bit call values, including both zero and nonzero cases. The executing account address
is symbolic over the full 160-bit address range, the account storage is an
arbitrary symbolic K map, and the pre-existing log is symbolic. Calldata is the
canonical four-byte ABI call; malformed calldata and arbitrary trailing bytes
are excluded because they are not canonical invocations of the requested ABI
operation.

## Observable final state

The observed result is the EVM status code and return-data buffer, plus the
executing account's storage and log. The claim requires `EVMC_REVERT`, empty
output, unchanged arbitrary storage, and unchanged logs. The final program
counter, internal word stack, and scratch memory are intentionally existential
because their concrete values are not external call observables. Other framed cells are unobserved because this
dispatcher-only path neither reads nor changes them in a way relevant to the
call result.

## Intended property

For every canonical `totalSupply()` call, every symbolic account storage, and
every 256-bit call value, this supplied runtime reverts with empty return data
and makes no storage or log change. There is no successful-call branch in the
implemented bytecode. Thus the successful subset is empty and the unsuccessful
subset is the entire stated domain.

## Execution model and chosen readings

- The schedule is BYZANTIUM, the first fork in the pinned semantics that gives
  opcode `0xfd` its compiled `REVERT` meaning. The bytecode uses no later opcode
  on this path.
- Gas accounting is disabled (`<useGas> false`), so the theorem describes the
  semantic call outcome without an out-of-gas branch. This does not turn a
  failing selector into a success; the path executes only fixed-cost dispatcher
  instructions and `REVERT`.
- Execution starts directly at the runtime EVM entry rather than through a
  transaction wrapper. Transaction fees, balances, nonce changes, and rollback
  machinery are therefore outside the theorem. The executed path has no state
  writes to roll back.
- Solidity 0.4.2 state variables default to internal visibility unless marked
  `public`. The source declares `uint totalSupply;` without `public` and defines
  no function named `totalSupply`; this agrees with the absent selector in the
  compiled runtime.
- The request's phrase “including successful and unsuccessful calls” is read as
  requiring both outcome classes to be accounted for. The files supply no
  successful implementation to verify, so the spec records and proves that the
  successful class is empty instead of postulating a slot-0 getter that is not
  in the runtime.
