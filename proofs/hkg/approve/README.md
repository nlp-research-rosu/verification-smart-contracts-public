# `HKG:approve`

- kind: EVM function; behavior: **allowance update**
- source: [contract.sol:178](contract.sol#L178)
- artifact: [contract.bin](contract.bin), the complete 2,091-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `BYZANTIUM`; gas accounting disabled

## Source

```solidity
function approve(address spender, uint256 value) returns (bool success) {



    // now spender can use balance in
    // ammount of value from owner balance
    allowed[msg.sender][spender] = value;

    // rise event about the transaction
    Approval(msg.sender, spender, value);

    return true;
}
```

## Bytecode (from the runtime)

Dispatch for `approve` (`0x095ea7b3`):

```text
0x0036  DUP1
0x0037  PUSH4 0x095ea7b3
0x003c  EQ
0x003d  PUSH2 0x0072
0x0040  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

For any symbolic owner/caller, spender, amount, and prior storage, a canonical
ordinary call implements the source assignment
`allowed[msg.sender][spender] = value`, emits the source `Approval` event, and
returns `true`. A call that violates the compiler-generated nonpayable guard
reverts without state or log changes, and a static call fails with
`EVMC_STATIC_MODE_VIOLATION` before the attempted write changes state.

The 3 symbolic claims are stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records the validated proof result; independent proof and specification reviews are in
[audits/](audits/).

### Scope

Canonical ABI calldata; arbitrary 160-bit contract, caller and spender addresses; uint256 amount; symbolic storage and logs. Nonpayable and static-call rejection are included.

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
