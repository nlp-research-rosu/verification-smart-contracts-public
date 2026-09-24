# Verification scope

## Program boundary

The claim executes the supplied `SuperchainConfig` implementation runtime in `contract.bin` from PC 0 through dispatch and `isLocalOrGlobalPaused`. The runtime is 3,195 bytes, SHA-256 `e315cc7339f9754ab718c3c7bea367b9bde48a4a3f94c415c50e64eb26f45249`. The program bytes are included in the unchanged saved claim or named in `verification.k`.

## Input domain

Canonical `isLocalOrGlobalPaused(address)` call with a positive pause timestamp and current time within the active interval. The claim assumes the supplied storage and timestamp represent an active global pause. Calls use canonical ABI calldata, London, and unbounded gas.

## Observable final state

The claim requires successful call returning ABI `true` under its written preconditions. It is a separate reachability claim, not a composed guardian-to-operation transaction theorem.

## Intended property

The getter returns true during the active global pause interval.

## Chosen contract readings

The supplied storage, addresses and current-time conditions in [spec.k](spec.k) define the active pause state. The claim does not establish that every deployment has those conditions. Proxy delegation, finite-gas behavior, malformed calldata, and source-to-bytecode compiler correctness are outside scope.

STATUS: PROVED; no independent KIT proof audit completed.
