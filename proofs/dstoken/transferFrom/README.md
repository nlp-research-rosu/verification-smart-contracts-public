# `DSToken:transferFrom`

- kind: EVM function; behavior: **delegated token transfer**
- source: [contract.sol:397](contract.sol#L397), [contract.sol:447](contract.sol#L447)
- artifact: [contract.bin](contract.bin), the complete 6,955-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `SHANGHAI`; gas accounting disabled

## Source

```solidity
function transferFrom(address src, address dst, uint wad) returns (bool) {
    assert(_balances[src] >= wad);
    assert(_approvals[src][msg.sender] >= wad);

    _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
    _balances[src] = sub(_balances[src], wad);
    _balances[dst] = add(_balances[dst], wad);

    Transfer(src, dst, wad);

    return true;
}
```

```solidity
function transferFrom(
    address src, address dst, uint wad
) stoppable note returns (bool) {
    return super.transferFrom(src, dst, wad);
}
```

The public override applies [stoppable](contract.sol#L126) and [note](contract.sol#L92) before the inherited implementation.

## Bytecode (from the runtime)

Dispatch for `transferFrom` (`0x23b872dd`):

```text
0x006d  DUP1
0x006e  PUSH4 0x23b872dd
0x0073  EQ
0x0074  PUSH2 0x0224
0x0077  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

For a canonical zero-value call while running, `transferFrom` succeeds exactly when the source balance and caller allowance cover `WAD` and the destination addition does not overflow (self-transfer cannot overflow after the prior subtraction).  Success returns ABI `true`, decrements the caller's allowance, moves the balance for distinct addresses or restores it for a self-transfer, preserves every other storage entry, and appends the exact note and transfer logs.  A stopped token, insufficient balance, insufficient allowance, or destination overflow reaches the compiler's `INVALID`; the enclosing message-call rollback restores storage and logs and returns call-success flag zero.  A positive call value reaches the non-payable `REVERT` with the same rollback and zero call-success flag.

The 7 symbolic claims are stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records the successful proof and independent KIT proof audit. Audit reports and retained checks are in [audits/](audits/) and [logs/](logs/).

### Scope

Canonical ABI calldata and non-static execution; symbolic in-range addresses, amounts and relevant storage words. Token address is 0 or > 9, excluding Shanghai precompiles 1–9. The success/overflow claims require the explicit non-collision inequalities among relevant mapping locations and slot 4. Failures are observed after enclosing-call rollback.

These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, gas assumptions and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision and proves the unchanged specification. Results are saved under `.kprover/`; independent audit checks are recorded separately.
