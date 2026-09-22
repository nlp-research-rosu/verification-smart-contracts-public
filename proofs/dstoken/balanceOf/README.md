# `DSToken:balanceOf`

- kind: EVM function; behavior: **balance lookup**
- source: [contract.sol:379](contract.sol#L379)
- artifact: [contract.bin](contract.bin), the complete 6,955-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `BYZANTIUM`; gas accounting disabled

## Source

```solidity
function balanceOf(address src) constant returns (uint256) {
    return _balances[src];
}
```

## Bytecode (from the runtime)

Dispatch for `balanceOf` (`0x70a08231`):

```text
0x00a4  DUP1
0x00a5  PUSH4 0x70a08231
0x00aa  EQ
0x00ab  PUSH2 0x038e
0x00ae  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

If execution terminates from the stated runtime-entry configuration, a canonical zero-value call returns exactly the balance stored for the symbolic address and does not change storage. The same canonical call with any nonzero valid call value reverts with empty output and does not change storage.

The 2 symbolic claims are stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); the final independent specification and proof audits are in [audits/](audits/).

### Scope

Canonical ABI calldata; arbitrary 160-bit contract, caller and argument addresses; symbolic storage; zero or nonzero uint256 call value. Direct non-static runtime entry starts at depth 0.

These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, gas assumptions and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision and proves the unchanged specification. Results are saved under `.kprover/`; independent audit checks are recorded separately.
