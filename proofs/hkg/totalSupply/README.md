# `HKG:totalSupply`

- kind: unsupported ABI selector; behavior: **empty revert**
- source: [contract.sol:14](contract.sol#L14)
- artifact: [contract.bin](contract.bin), the complete 2,091-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `BYZANTIUM`; gas accounting disabled

## Source

```solidity
uint totalSupply;
```

## Bytecode (from the runtime)

Selector `0x18160ddd` has no dispatcher entry and reaches this fallback:

```text
0x006d  JUMPDEST
0x006e  PUSH1 0x00
0x0070  DUP1
0x0071  REVERT
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

For every canonical `totalSupply()` call, every symbolic account storage, and
every 256-bit call value, this supplied runtime reverts with empty return data
and makes no storage or log change. There is no successful-call branch in the
implemented bytecode. Thus the successful subset is empty and the unsuccessful
subset is the entire stated domain.

The symbolic claim is stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records the validated proof result; independent proof and specification reviews are in
[audits/](audits/).

### Scope

Canonical four-byte totalSupply calldata; arbitrary 160-bit contract address, uint256 call value, storage map and log list. The source has an internal variable but no totalSupply() getter.

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
