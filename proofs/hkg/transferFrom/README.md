# `HKG:transferFrom`

- kind: EVM function; behavior: **delegated token transfer**
- source: [contract.sol:125](contract.sol#L125)
- artifact: [contract.bin](contract.bin), the complete 2,091-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `CANCUN`; gas accounting disabled

## Source

```solidity
function transferFrom(address from, address to, uint256 value) returns (bool success) {

    if ( balances[from] >= value &&
         allowed[from][msg.sender] >= value &&
         value > 0) {


        // do the actual transfer
        balances[from] -= value;
        balances[to] += value;


        // addjust the permision, after part of
        // permited to spend value was used
        allowed[from][msg.sender] -= value;

        // rise the Transfer event
        Transfer(from, to, value);
        return true;
    } else {

        return false;
    }
}
```

## Bytecode (from the runtime)

Dispatch for `transferFrom` (`0x23b872dd`):

```text
0x0041  DUP1
0x0042  PUSH4 0x23b872dd
0x0047  EQ
0x0048  PUSH2 0x00cc
0x004b  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

For every canonical symbolic call, the function returns true exactly when the
source balance and caller allowance are both at least the strictly positive
requested value.  A successful call subtracts from `balances[from]`, then adds
to `balances[to]`, then subtracts from `allowed[from][msg.sender]`, with EVM
word arithmetic and a `Transfer` event.  Every other call returns false without
changing storage or emitting a log.

The 4 symbolic claims are stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records the validated proof result; independent proof and specification reviews are in
[audits/](audits/).

### Scope

Canonical ABI calldata; arbitrary in-range addresses and amount; symbolic storage; zero call value; non-static execution. No address or mapping-key distinctness is assumed. Nonzero call value and static-call rejection are outside these four claims.

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
