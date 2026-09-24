# `ETHLockbox:paused`

- kind: EVM function; behavior: **the getter returns true during the active global pause interval**
- source: [contract.sol:112](contract.sol#L112)
- artifact: [contract.bin](contract.bin), the complete 5,006-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

The target function is [`paused`](contract.sol#L112) in the supplied `ETHLockbox` implementation. The claim executes the implementation runtime in [contract.bin](contract.bin).

## Bytecode (from the runtime)

Execution starts at program counter 0 and passes through the runtime dispatcher. [verification.k](verification.k) defines the supplied program bytes; [contract.bin](contract.bin) contains the complete runtime.

## Claim

The getter returns true during the active global pause interval. The symbolic claim is stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); no independent KIT proof audit was completed for this dependency claim.

### Scope

Canonical `paused()` call with the lockbox wired to SuperchainConfig and a current active global pause; the supplied addresses and storage link the lockbox to that configuration. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves [spec.k](spec.k). Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
