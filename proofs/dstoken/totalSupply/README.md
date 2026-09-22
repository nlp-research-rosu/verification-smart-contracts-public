# `DSToken:totalSupply`

- kind: EVM function; behavior: **supply lookup**
- source: [contract.sol:376](contract.sol#L376)
- artifact: [contract.bin](contract.bin), the complete 6,955-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `SHANGHAI`; gas accounting disabled

## Source

```solidity
function totalSupply() constant returns (uint256) {
    return _supply;
}
```

## Bytecode (from the runtime)

Dispatch for `totalSupply` (`0x18160ddd`):

```text
0x0062  DUP1
0x0063  PUSH4 0x18160ddd
0x0068  EQ
0x0069  PUSH2 0x01fb
0x006c  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

A zero-value canonical call to the implemented `totalSupply()` returns the
uint256 stored at slot 0 without changing storage.  A canonical call carrying
any nonzero uint256 value is rejected by the compiler-generated nonpayable
guard with empty revert data and without changing storage.

The 2 symbolic claims are stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records the successful proof and independent KIT proof audit. Audit reports and retained checks are in [audits/](audits/) and [logs/](logs/).

### Scope

Canonical four-byte ABI calldata; arbitrary 160-bit contract address, symbolic storage and uint256 call value. The claims start at direct runtime entry, PC 0.

These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, gas assumptions and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision and proves the unchanged specification. Results are saved under `.kprover/`; independent audit checks are recorded separately.
