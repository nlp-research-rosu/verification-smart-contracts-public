# `DSValue:peek() / read()`

- kind: two functions in one proof package; behavior: **value and validity lookup**
- source: [contract.sol:256](contract.sol#L256), [contract.sol:259](contract.sol#L259)
- artifact: [contract.bin](contract.bin), the complete 2,874-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `ISTANBUL`; positive-infinite gas with cost tracking

## Source

```solidity
function peek() public view returns (bytes32, bool) {
    return (val,has);
}
```

```solidity
function read() public view returns (bytes32) {
    bytes32 wut; bool haz;
    (wut, haz) = peek();
    require(haz, "haz-not");
    return wut;
}
```

## Bytecode (from the runtime)

Dispatch for `peek` (`0x59e02dd7`):

```text
0x007d  DUP1
0x007e  PUSH4 0x59e02dd7
0x0083  EQ
0x0084  PUSH2 0x011d
0x0087  JUMPI
```

Dispatch for `read` (`0x57de26a4`):

```text
0x0072  DUP1
0x0073  PUSH4 0x57de26a4
0x0078  EQ
0x0079  PUSH2 0x00ff
0x007c  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

A zero-value `peek()` call returns the stored value and `has != 0` as two ABI words. A zero-value `read()` call returns the value when the has byte is nonzero, and otherwise reverts with `Error("haz-not")`. Successful read decreases gas metadata by exactly 2,043 under the recorded infinite-gas model. Nonzero call value causes an empty revert for either selector. All five claims preserve storage.

The 5 symbolic claims are stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records their results and the independent proof audit. The specification review and proof audit are in [audits/](audits/).

### Scope

The peek() or read() selector may be followed by up to 1,250,000,000 arbitrary calldata bytes. Storage, caller, current account, call value and static flag are symbolic, with EVM address/word ranges. The account must exist. Missing storage slots read zero; the has byte is bits 160–167 of slot 1 and val is slot 2.

These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, gas assumptions and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision and proves the unchanged specification. Results are saved under `.kprover/`; the independent audit conclusions are recorded in [PROOF.md](PROOF.md) and [audits/](audits/).
