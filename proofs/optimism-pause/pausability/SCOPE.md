# Verification scope

## Program boundary

Six operation claims execute the supplied direct implementation runtime bytecode from PC 0 through dispatch for the two `OptimismPortal2` withdrawal functions, the two `L1StandardBridge` finalization functions, `L1ERC721Bridge.finalizeBridgeERC721`, and `L1CrossDomainMessenger.relayMessage`. Ten further claims execute the same portal runtime for nonempty withdrawal-proof arrays. Four separate claims execute the supplied `SuperchainConfig`, `ETHLockbox`, and `SystemConfig` runtimes to check guardian pause and pause getters. Ground definitions in `verification.k` and `verification-pause.k` name the operation and SuperchainConfig runtimes; the other two dependency runtimes are inline in their claims. Runtime files are in `bytecode/`.

## Input domain

Scalar ABI arguments are symbolic over their Solidity widths. Calls have canonical ABI calldata. Dynamic `bytes` are symbolic up to 2³⁰ bytes, the pinned ABI helper's maximum. The portal withdrawal-proof array has a fixed length of 0–10 across eleven claims; each element in a nonempty array is a distinct symbolic byte string of exactly 600 bytes.

Bridge finalization claims assume the source-authorized cross-domain caller, messenger, and remote-bridge configuration. The operation claims assume their configured pause responder returns ABI `true`. The four dependency claims establish their stated timestamp write or true pause response under their own guardian, account-wiring, storage, and time preconditions. Executions are fresh top-level calls under London with unbounded gas.

## Observable final state

Each operation claim requires `EVMC_REVERT`, the exact ABI pause-error payload for that function, and preservation of target account storage, balance, nonce, code, and initial logs. The dependency claims observe the guardian timestamp write or a true pause response under their stated conditions. These are separate reachability claims, not a combined transaction theorem.

## Intended property

Under the stated paused and authorization environment, canonical calls in the proved input domain reach the pause check and revert before later operation logic takes effect.

## Chosen contract readings

“Paused” means the configured dependency executes and returns true. The operation proofs use concrete responder bytecode rather than a rule that replaces operation execution. The dependency proofs check the supplied pause implementations separately. This package does not claim a machine-checked composition from a guardian transaction through every operation, or that a deployed proxy delegates to these implementations.

The 2³⁰-byte ceiling is in the pinned KEVM ABI encoding helper, not in the Optimism Solidity functions. RV's reference scope extends to 2⁶³ bytes, so that larger input interval is not proved here. Arrays outside 0–10, non-600-byte proof elements in nonempty arrays, malformed calldata, unauthorized bridge calls, finite-gas failures, alternate EVM schedules, and source-to-bytecode compiler correctness are also outside scope.
