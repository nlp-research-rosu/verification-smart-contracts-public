# `HKG:balanceOf`

- kind: EVM function; behavior: **balance lookup**
- source: [contract.sol:161](contract.sol#L161)
- artifact: [contract.bin](contract.bin), the complete 2,091-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `BYZANTIUM`; gas accounting disabled

## Source

```solidity
function balanceOf(address owner) constant returns (uint256 balance) {
    return balances[owner];
}
```

## Bytecode (from the runtime)

Dispatch for `balanceOf` (`0x70a08231`):

```text
0x004c  DUP1
0x004d  PUSH4 0x70a08231
0x0052  EQ
0x0053  PUSH2 0x0145
0x0056  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

If a zero-value call in the stated selector/decoder domain terminates, it
succeeds and returns the stored token balance of `owner` without changing
storage. If the same call carries a nonzero value, it terminates by reverting
with empty output and without changing storage.

The 2 symbolic claims are stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records the validated proof result; independent proof and specification reviews are in
[audits/](audits/).

### Scope

Exactly 36 calldata bytes with the balanceOf selector. Address decoding masks the high 96 padding bits. Contract and caller are arbitrary 160-bit addresses; storage is symbolic with a uint256 selected balance. Direct non-static entry uses depth 0 and an empty call stack.

These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, gas assumptions and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision,
and proves the unchanged specification. New results are saved under `.kprover/`;
this package retains proof and audit conclusions rather than session
transcripts.
