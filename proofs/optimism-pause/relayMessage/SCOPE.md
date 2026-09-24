# Verification scope

## Program boundary

The claim executes the supplied direct `L1CrossDomainMessenger` implementation runtime in `contract.bin` from PC 0 through dispatch and `relayMessage`. The runtime is 9,614 bytes, SHA-256 `27d48068a43f90cd262440f294fd5eaf96028f372c69c1fc37e4866ccdb6e1f2`. The operation program is named by `verification.k`; no source-level replacement bypasses its EVM execution.

## Input domain

Canonical symbolic message arguments and dynamic bytes up to 2³⁰. The function arguments have their Solidity widths. The call is a fresh, canonical top-level ABI call under London with unbounded gas. The configured pause responder returns true. Other dynamic byte inputs are limited to 2³⁰ bytes by the pinned ABI helper.

## Observable final state

The claim requires reversion with the exact pause error, unchanged target storage, balance, nonce and code, and unchanged initial logs. Internal stack, memory, and program counter are existentially framed after execution.

## Intended property

Paused message relay reverts with `CrossDomainMessenger: paused`.

## Chosen contract readings

The claim assumes the pause dependency returns true. Separate dependency claims establish pause behavior under their own storage, guardian, time, and address conditions; no combined guardian-to-operation theorem or deployed-proxy delegation theorem is claimed. RV's reference admits dynamic bytes up to 2⁶³, so that larger interval is outside this proof. Malformed calldata, finite-gas behavior, and source-to-bytecode compiler correctness are also outside scope.

STATUS: SOUND-BUT-LIMITED ([independent proof audit](audits/proof-audit-1.md))
