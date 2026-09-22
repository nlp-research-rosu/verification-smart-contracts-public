# `DSToken:approve`

- kind: EVM function; behavior: **allowance update**
- source: [contract.sol:410](contract.sol#L410), [contract.sol:452](contract.sol#L452)
- artifact: [contract.bin](contract.bin), the complete 6,955-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `CANCUN`; gas accounting disabled

## Source

```solidity
function approve(address guy, uint256 wad) returns (bool) {
    _approvals[msg.sender][guy] = wad;

    Approval(msg.sender, guy, wad);

    return true;
}
```

```solidity
function approve(address guy, uint wad) stoppable note returns (bool) {
    return super.approve(guy, wad);
}
```

The public override applies [stoppable](contract.sol#L126) and [note](contract.sol#L92) before the inherited implementation.

## Bytecode (from the runtime)

Dispatch for `approve` (`0x095ea7b3`):

```text
0x004c  DUP1
0x004d  PUSH4 0x095ea7b3
0x0052  EQ
0x0053  PUSH2 0x0168
0x0056  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

For every well-typed symbolic owner/caller, spender, amount, and symbolic
storage map, an enabled zero-value `approve` call overwrites that caller's
allowance for the spender with the amount, emits the two implemented events,
and returns true. If the token is stopped, the Solidity 0.4 `assert` fails
through `INVALID` before logging or writing. Any nonzero-value call is rejected
by the generated nonpayable guard before the stopped check, logging, or write.

The 3 symbolic claims are stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records the successful proof and independent KIT proof audit. Audit reports and retained checks are in [audits/](audits/) and [logs/](logs/).

### Scope

Canonical ABI calldata; arbitrary in-range addresses and amount; symbolic storage and log prefix; non-static execution. Slot 4 is a uint256 word and its byte at bit offset 160 is the stopped flag.

These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, gas assumptions and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision and proves the unchanged specification. Results are saved under `.kprover/`; independent audit checks are recorded separately.
