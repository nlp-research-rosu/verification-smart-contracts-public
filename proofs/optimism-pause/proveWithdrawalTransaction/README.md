# `OptimismPortal2:proveWithdrawalTransaction`

- kind: EVM function; behavior: **paused portal proof call reverts with `OptimismPortal_CallPaused` before recording a withdrawal proof**
- source: [contract.sol:386](contract.sol#L386)
- artifact: [contract.bin](contract.bin), the complete 23,033-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

The target function is [`proveWithdrawalTransaction`](contract.sol#L386) in the supplied `OptimismPortal2` implementation. The claim executes the implementation runtime in [contract.bin](contract.bin).

## Bytecode (from the runtime)

Execution starts at program counter 0 and passes through the runtime dispatcher. [verification.k](verification.k) defines the supplied program bytes; [contract.bin](contract.bin) contains the complete runtime.

## Claim

Paused portal proof call reverts with `OptimismPortal_CallPaused` before recording a withdrawal proof. The 11 symbolic claims are stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); the original independent specification and proof audit findings are in [audits/](audits/).

### Scope

Canonical withdrawal transaction, output-root proof and withdrawal-proof arrays of lengths 0–10; each nonempty element is an independent symbolic 600-byte value; the configured pause responder returns true. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves the eleven claims collected in [spec.k](spec.k). The retained positive results came from the original six-operation proof for length 0 and ten separate single-claim proofs for lengths 1–10; this collected module was not separately submitted. Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
