# `DSToken:transfer`

- kind: EVM function; behavior: **token transfer**
- source: [contract.sol:386](contract.sol#L386), [contract.sol:444](contract.sol#L444)
- artifact: [contract.bin](contract.bin), the complete 6,955-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `BYZANTIUM`; gas accounting disabled

## Source

```solidity
function transfer(address dst, uint wad) returns (bool) {
    assert(_balances[msg.sender] >= wad);

    _balances[msg.sender] = sub(_balances[msg.sender], wad);
    _balances[dst] = add(_balances[dst], wad);

    Transfer(msg.sender, dst, wad);

    return true;
}
```

```solidity
function transfer(address dst, uint wad) stoppable note returns (bool) {
    return super.transfer(dst, wad);
}
```

The public override applies [stoppable](contract.sol#L126) and [note](contract.sol#L92) before the inherited implementation.

## Bytecode (from the runtime)

Dispatch for `transfer` (`0xa9059cbb`):

```text
0x00f1  DUP1
0x00f2  PUSH4 0xa9059cbb
0x00f7  EQ
0x00f8  PUSH2 0x0568
0x00fb  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

For zero call value and an unstopped token, transfer succeeds exactly when the
source balance covers `WAD` and (for distinct balance slots) crediting the
destination does not overflow.  It returns `true`, subtracts `WAD` from the
source, adds `WAD` to the destination, and otherwise preserves storage.  A
nonzero call value reverts.  A stopped token, insufficient source balance, or
destination overflow raises the compiler's invalid-instruction assertion path;
the enclosing call reports failure and rolls back all storage effects.

The 12 symbolic claims are stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records the successful proof and independent KIT proof audit. Audit reports and retained checks are in [audits/](audits/) and [logs/](logs/).

### Scope

Canonical ABI calldata and non-static execution; symbolic addresses, uint256 amounts and relevant storage words. Raw-execution claims admit all 160-bit token addresses; enclosing-call claims require token address > 8. Equal mapping locations are covered explicitly. The stopped byte is at bit offset 160 of slot 4.

These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, gas assumptions and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision and proves the unchanged specification. Results are saved under `.kprover/`; independent audit checks are recorded separately.
