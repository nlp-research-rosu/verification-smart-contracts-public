# `SystemConfig:paused`

- kind: EVM function; behavior: **the getter returns true during the active global pause interval**
- source: [contract.sol:568](contract.sol#L568)
- artifact: [contract.bin](contract.bin), the complete 12,382-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

```solidity
function paused() public view returns (bool) {
    return IOptimismPortal2(payable(optimismPortal())).ethLockbox().paused();
}
```

## Bytecode (from the runtime)

Dispatch for `paused` (`0x5c975abb`):

```text
0x0221  DUP1
0x0222  PUSH4 0x5c975abb
0x0227  EQ
0x0228  PUSH2 0x0671
0x022b  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

The getter returns true during the active global pause interval. The symbolic claim is stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); no independent KIT proof audit was completed for this dependency claim.

### Scope

Canonical `paused()` call with SystemConfig wired through its dependencies to an active SuperchainConfig pause; the supplied addresses and storage link the configured dependencies. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves [spec.k](spec.k). Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
