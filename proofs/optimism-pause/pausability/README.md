# Optimism L1 pausability

- kind: EVM functions; behavior: **paused calls revert before operation logic**
- source: [OptimismPortal2](contracts/OptimismPortal2.sol), [L1StandardBridge](contracts/L1StandardBridge.sol), [L1ERC721Bridge](contracts/L1ERC721Bridge.sol), [L1CrossDomainMessenger](contracts/L1CrossDomainMessenger.sol), and the [pause dependencies](contracts/)
- artifacts: the seven complete implementation runtimes in [bytecode/](bytecode/)
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

The six target functions are `OptimismPortal2.proveWithdrawalTransaction`, `OptimismPortal2.finalizeWithdrawalTransaction`, `L1StandardBridge.finalizeBridgeETH`, `L1StandardBridge.finalizeBridgeERC20`, `L1ERC721Bridge.finalizeBridgeERC721`, and `L1CrossDomainMessenger.relayMessage`. The bridge and messenger functions are implemented in the inherited [StandardBridge](contracts/StandardBridge.sol), [ERC721Bridge](contracts/ERC721Bridge.sol), and [CrossDomainMessenger](contracts/CrossDomainMessenger.sol) sources. The dependency claims execute [SuperchainConfig](contracts/SuperchainConfig.sol), [ETHLockbox](contracts/ETHLockbox.sol), and [SystemConfig](contracts/SystemConfig.sol) implementations.

## Bytecode (from the runtime)

The claims start at program counter 0 and execute the supplied implementation runtimes through their dispatchers. [verification.k](verification.k) names the four operation runtimes and concrete response programs; [verification-pause.k](verification-pause.k) names the SuperchainConfig runtime. The ETHLockbox and SystemConfig runtimes are included directly in their claim files. All seven runtime images are in [bytecode/](bytecode/).

## Claim

For canonical calls in the stated paused environment, all six operations revert with their exact pause errors and preserve target account state and logs. The six claims are in [spec.k](spec.k). `proveWithdrawalTransaction` covers an empty withdrawal-proof array there and each fixed array length 1–10 in the separate proved [spec-array-N.k](spec-array-1.k) files. Every element of a nonempty array is an independent symbolic 600-byte value. [spec-arrays.k](spec-arrays.k) also collects those ten claims, but the retained positive results are for the individual files.

Four more claims check the guardian timestamp write and true pause responses from SuperchainConfig, ETHLockbox, and SystemConfig: [guardian](spec-pause-symbolic.k), [global getter](spec-global-symbolic.k), [ETHLockbox](spec-ethlockbox-inline.k), and [SystemConfig](spec-systemconfig-inline.k). Their conditions are written in the claims; they are separate from the six operation proofs.

The results and audit limits are in [PROOF.md](PROOF.md) and [audits/](audits/).

### Scope

These are partial-correctness claims for direct implementation calls under the pinned EVM model. Dynamic byte inputs stop at 2³⁰ bytes because of the pinned ABI helper; RV's reference admits up to 2⁶³. The package does not prove proxy entry or one combined guardian-to-operation transaction. [SCOPE.md](SCOPE.md) gives the exact assumptions and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The script checks the semantics revision, then submits the unchanged six-claim module, ten individual array modules, and four dependency modules in a fresh session. Results are saved under `.kprover/`; independent audit checks are recorded separately. Proving all claims can take substantial time.
