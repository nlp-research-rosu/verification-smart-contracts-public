# Verification scope

## Program boundary

The claim executes the supplied `SystemConfig` implementation runtime in `contract.bin` from PC 0 through dispatch and `paused`. The runtime is 12,382 bytes, SHA-256 `135e31ff4a9292c3dbb5162c44c0adaf8c2345cbf09f1ec78a7974a25fe5f9e8`. The program bytes are included in the unchanged saved claim or named in `verification.k`.

## Input domain

Canonical `paused()` call with SystemConfig wired through its dependencies to an active SuperchainConfig pause. The claim assumes the supplied addresses and storage link the configured dependencies. Calls use canonical ABI calldata, London, and unbounded gas.

## Observable final state

The claim requires successful call returning ABI `true` under its written preconditions. It is a separate reachability claim, not a composed guardian-to-operation transaction theorem.

## Intended property

The getter returns true during the active global pause interval.

## Chosen contract readings

The supplied storage, addresses and current-time conditions in [spec.k](spec.k) define the active pause state. The claim does not establish that every deployment has those conditions. Proxy delegation, finite-gas behavior, malformed calldata, and source-to-bytecode compiler correctness are outside scope.

STATUS: PROVED; no independent KIT proof audit completed.
