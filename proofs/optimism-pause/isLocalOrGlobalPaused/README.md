# `SuperchainConfig:isLocalOrGlobalPaused`

- kind: EVM function; behavior: **the getter returns true during the active global pause interval**
- source: [contract.sol:152](contract.sol#L152)
- artifact: [contract.bin](contract.bin), the complete 3,195-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

```solidity
function isLocalOrGlobalPaused(address _identifier) external view returns (bool) {
    return paused(address(0)) || paused(_identifier);
}
```

## Bytecode (from the runtime)

Dispatch for `isLocalOrGlobalPaused` (`0x9956fd9e`):

```text
0x0036  DUP1
0x0037  PUSH4 0x9956fd9e
0x003c  EQ
0x003d  PUSH2 0x02b5
0x0040  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

The getter returns true during the active global pause interval. The symbolic claim is stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); no independent KIT proof audit was completed for this dependency claim.

### Scope

Canonical `isLocalOrGlobalPaused(address)` call with a positive pause timestamp and current time within the active interval; the supplied storage and timestamp represent an active global pause. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves [spec.k](spec.k). Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
