# `L1CrossDomainMessenger:relayMessage`

- kind: EVM function; behavior: **paused message relay reverts with `CrossDomainMessenger: paused`**
- source: [helpers/CrossDomainMessenger.sol:222](helpers/CrossDomainMessenger.sol#L222)
- artifact: [contract.bin](contract.bin), the complete 9,614-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

The target function is [`relayMessage`](helpers/CrossDomainMessenger.sol#L222) in the supplied `L1CrossDomainMessenger` implementation. The claim executes the implementation runtime in [contract.bin](contract.bin).

## Bytecode (from the runtime)

Execution starts at program counter 0 and passes through the runtime dispatcher. [verification.k](verification.k) defines the supplied program bytes; [contract.bin](contract.bin) contains the complete runtime.

## Claim

Paused message relay reverts with `CrossDomainMessenger: paused`. The symbolic claim is stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); the original independent specification and proof audit findings are in [audits/](audits/).

### Scope

Canonical symbolic message arguments and dynamic bytes up to 2³⁰; the configured pause responder returns true. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves [spec.k](spec.k). Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
