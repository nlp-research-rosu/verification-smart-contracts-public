# `HKG:allowance`

- kind: EVM function; behavior: **allowance lookup**
- source: [contract.sol:203](contract.sol#L203)
- artifact: [contract.bin](contract.bin), the complete 2,091-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `BYZANTIUM`; gas accounting disabled

## Source

```solidity
function allowance(address owner, address spender) constant returns (uint256 remaining) {
  return allowed[owner][spender];
}
```

## Bytecode (from the runtime)

Dispatch for `allowance` (`0xdd62ed3e`):

```text
0x0062  DUP1
0x0063  PUSH4 0xdd62ed3e
0x0068  EQ
0x0069  PUSH2 0x01ec
0x006c  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

For a canonical zero-value call, the runtime returns the allowance stored in
`allowed[owner][spender]` and does not mutate storage. For the same call with
nonzero value, the compiler-generated nonpayable guard reverts with empty
output and does not mutate storage.

The 2 symbolic claims are stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records the validated proof result; independent proof and specification reviews are in
[audits/](audits/).

### Scope

Canonical ABI calldata; arbitrary 160-bit owner, spender and contract addresses; symbolic storage, including absent entries; zero or nonzero uint256 call value.

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
