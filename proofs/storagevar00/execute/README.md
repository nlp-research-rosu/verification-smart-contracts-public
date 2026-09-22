# `storagevar00:execute`

- kind: EVM function; behavior: **storage lookup**
- source: [contract.sol:5](contract.sol#L5)
- artifact: [contract.bin](contract.bin), the complete 161-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `CANCUN`; gas accounting disabled

## Source

```solidity
function execute() view public returns(uint) {
    return n;
}
```

## Bytecode (from the runtime)

Dispatch for `execute` (`0x61461954`):

```text
0x0035  DUP1
0x0036  PUSH4 0x61461954
0x003b  EQ
0x003c  PUSH1 0x44
0x003e  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

For every symbolic EVM storage map, a canonical zero-value call returns the slot-0 lookup as an ABI uint256 word (zero when absent) and preserves storage. The same call with any nonzero uint256 value reverts with empty output and unchanged storage.

The 2 symbolic claims are stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records the successful proof and independent KIT proof audit. Audit reports and retained checks are in [audits/](audits/) and [logs/](logs/).

### Scope

Canonical four-byte execute() calldata; arbitrary 160-bit contract address and complete symbolic storage map; zero or nonzero uint256 call value. Slot 0 may be present or absent. Other call-context fields are framed as recorded in spec.k.

These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, gas assumptions and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision and proves the unchanged specification. Results are saved under `.kprover/`; independent audit checks are recorded separately.
