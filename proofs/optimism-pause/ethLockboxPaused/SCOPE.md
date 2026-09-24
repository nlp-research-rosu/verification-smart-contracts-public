# Verification scope

## Program boundary

The claim executes the supplied `ETHLockbox` implementation runtime in `contract.bin` from PC 0 through dispatch and `paused`. The runtime is 5,006 bytes, SHA-256 `6d9c5ff2c73f41a5834061a4a60f5731f55614461f35be149d6de46e9eae1201`. The program bytes are included in the unchanged saved claim or named in `verification.k`.

## Input domain

Canonical `paused()` call with the lockbox wired to SuperchainConfig and a current active global pause. The claim assumes the supplied addresses and storage link the lockbox to that configuration. Calls use canonical ABI calldata, London, and unbounded gas.

## Observable final state

The claim requires successful call returning ABI `true` under its written preconditions. It is a separate reachability claim, not a composed guardian-to-operation transaction theorem.

## Intended property

The getter returns true during the active global pause interval.

## Chosen contract readings

The supplied storage, addresses and current-time conditions in [spec.k](spec.k) define the active pause state. The claim does not establish that every deployment has those conditions. Proxy delegation, finite-gas behavior, malformed calldata, and source-to-bytecode compiler correctness are outside scope.

STATUS: PROVED; no independent KIT proof audit completed.
