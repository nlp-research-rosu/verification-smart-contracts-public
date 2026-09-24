# Verification scope

## Program boundary

The claim executes the supplied direct `L1StandardBridge` implementation runtime in `contract.bin` from PC 0 through dispatch and `finalizeBridgeERC20`. The runtime is 12,620 bytes, SHA-256 `6473973a3992cf61a389793f19d88185d7cbb095e6fecfbdbf6ff683c1d914cd`. The operation program is named by `verification.k`; no source-level replacement bypasses its EVM execution.

## Input domain

Canonical symbolic bridge arguments and dynamic bytes up to 2³⁰. The function arguments have their Solidity widths. The call is a fresh, canonical top-level ABI call under London with unbounded gas. The caller is authorized across domains and the configured pause responder returns true. Other dynamic byte inputs are limited to 2³⁰ bytes by the pinned ABI helper.

## Observable final state

The claim requires reversion with the exact pause error, unchanged target storage, balance, nonce and code, and unchanged initial logs. Internal stack, memory, and program counter are existentially framed after execution.

## Intended property

Paused ERC20 bridge finalization reverts with `StandardBridge: paused`.

## Chosen contract readings

The claim assumes the pause dependency returns true. Separate dependency claims establish pause behavior under their own storage, guardian, time, and address conditions; no combined guardian-to-operation theorem or deployed-proxy delegation theorem is claimed. RV's reference admits dynamic bytes up to 2⁶³, so that larger interval is outside this proof. Malformed calldata, finite-gas behavior, and source-to-bytecode compiler correctness are also outside scope.

STATUS: SOUND-BUT-LIMITED ([independent proof audit](audits/proof-audit-1.md))
