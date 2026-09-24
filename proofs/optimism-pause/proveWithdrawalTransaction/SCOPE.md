# Verification scope

## Program boundary

The claims execute the supplied direct `OptimismPortal2` implementation runtime in `contract.bin` from PC 0 through dispatch and `proveWithdrawalTransaction`. The runtime is 23,033 bytes, SHA-256 `fd3563d1e8783828d87f745f7e70e485651cfce39b28845bfb1566551cb6d93d`. The operation program is named by `verification.k`; no source-level replacement bypasses its EVM execution.

## Input domain

Canonical withdrawal transaction, output-root proof and withdrawal-proof arrays of lengths 0–10; each nonempty element is an independent symbolic 600-byte value. The function arguments have their Solidity widths. The call is a fresh, canonical top-level ABI call under London with unbounded gas. The configured pause responder returns true. Other dynamic byte inputs are limited to 2³⁰ bytes by the pinned ABI helper.

## Observable final state

The claim requires reversion with the exact pause error, unchanged target storage, balance, nonce and code, and unchanged initial logs. Internal stack, memory, and program counter are existentially framed after execution.

## Intended property

Paused portal proof call reverts with `OptimismPortal_CallPaused` before recording a withdrawal proof.

## Chosen contract readings

The claim assumes the pause dependency returns true. Separate dependency claims establish pause behavior under their own storage, guardian, time, and address conditions; no combined guardian-to-operation theorem or deployed-proxy delegation theorem is claimed. RV's reference admits dynamic bytes up to 2⁶³, so that larger interval is outside this proof. Malformed calldata, finite-gas behavior, and source-to-bytecode compiler correctness are also outside scope.

STATUS: SOUND-BUT-LIMITED ([independent proof audit](audits/proof-audit-1.md))
