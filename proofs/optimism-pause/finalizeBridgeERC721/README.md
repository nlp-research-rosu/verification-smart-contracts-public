# `L1ERC721Bridge:finalizeBridgeERC721`

- kind: EVM function; behavior: **paused ERC721 bridge finalization reverts with `L1ERC721Bridge: paused`**
- source: [contract.sol:86](contract.sol#L86)
- artifact: [contract.bin](contract.bin), the complete 6,186-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

The target function is [`finalizeBridgeERC721`](contract.sol#L86) in the supplied `L1ERC721Bridge` implementation. The claim executes the implementation runtime in [contract.bin](contract.bin).

## Bytecode (from the runtime)

Execution starts at program counter 0 and passes through the runtime dispatcher. [verification.k](verification.k) defines the supplied program bytes; [contract.bin](contract.bin) contains the complete runtime.

## Claim

Paused ERC721 bridge finalization reverts with `L1ERC721Bridge: paused`. The symbolic claim is stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); the original independent specification and proof audit findings are in [audits/](audits/).

### Scope

Canonical symbolic bridge arguments and dynamic bytes up to 2³⁰; an authorized cross-domain caller and a true response from the configured pause responder. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves [spec.k](spec.k). Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
