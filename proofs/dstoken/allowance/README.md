# `DSToken:allowance`

- kind: EVM function; behavior: **allowance lookup**
- source: [contract.sol:382](contract.sol#L382)
- artifact: [contract.bin](contract.bin), the complete 6,955-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `BYZANTIUM`; gas accounting disabled

## Source

```solidity
function allowance(address src, address guy) constant returns (uint256) {
    return _approvals[src][guy];
}
```

## Bytecode (from the runtime)

Dispatch for `allowance` (`0xdd62ed3e`):

```text
0x0112  DUP1
0x0113  PUSH4 0xdd62ed3e
0x0118  EQ
0x0119  PUSH2 0x062c
0x011c  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

A zero-value canonical call to `allowance(src,guy)` returns `_approvals[src][guy]` without modifying storage. A canonical call carrying nonzero Ether is rejected by the generated nonpayable guard, returns no data, and does not modify storage.

The 2 symbolic claims are stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); the final independent specification and proof audits are in [audits/](audits/).

### Scope

Canonical ABI calldata; arbitrary 160-bit contract, caller and argument addresses; symbolic storage; zero or nonzero uint256 call value; direct non-static execution.

These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, gas assumptions and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision and proves the unchanged specification. Results are saved under `.kprover/`; independent audit checks are recorded separately.
