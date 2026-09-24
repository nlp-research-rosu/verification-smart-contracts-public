# `ETHLockbox:paused`

- kind: EVM function; behavior: **the getter returns true during the active global pause interval**
- source: [contract.sol:112](contract.sol#L112)
- artifact: [contract.bin](contract.bin), the complete 5,006-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

```solidity
function paused() public view returns (bool) {
    return superchainConfig.isLocalOrGlobalPaused(address(this));
}
```

## Bytecode (from the runtime)

Dispatch for `paused` (`0x5c975abb`):

```text
0x0070  DUP1
0x0071  PUSH4 0x5c975abb
0x0076  EQ
0x0077  PUSH2 0x02a5
0x007a  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

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
