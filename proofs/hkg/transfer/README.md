# `HKG:transfer`

- kind: EVM function; behavior: **token transfer**
- source: [contract.sol:94](contract.sol#L94)
- artifact: [contract.bin](contract.bin), the complete 2,091-byte runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `BYZANTIUM`; gas accounting disabled

## Source

```solidity
function transfer(address to, uint256 value) returns (bool success) {


    if (balances[msg.sender] >= value && value > 0) {

        // do actual tokens transfer
        balances[msg.sender] -= value;
        balances[to]         += value;

        // rise the Transfer event
        Transfer(msg.sender, to, value);
        return true;
    } else {

        return false;
    }
}
```

## Bytecode (from the runtime)

Dispatch for `transfer` (`0xa9059cbb`):

```text
0x0057  DUP1
0x0058  PUSH4 0xa9059cbb
0x005d  EQ
0x005e  PUSH2 0x0192
0x0061  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

For call value zero:

- If `VALUE > 0` and the caller's balance at Solidity mapping slot 1 is at least `VALUE`, execution returns ABI boolean `true`, subtracts `VALUE` from the caller, then adds `VALUE` to the recipient using EVM 256-bit word arithmetic, and appends `Transfer(CALLER, TO, VALUE)`.
- If `VALUE == 0` or the caller's balance is less than `VALUE`, execution returns ABI boolean `false`, leaves storage unchanged, and appends no log.

For positive call value, the runtime's nonpayable guard returns `EVMC_REVERT` with empty output before touching storage or logs.

The 3 symbolic claims are stated in [spec.k](spec.k). [PROOF.md](PROOF.md) records the successful proof and independent KIT proof audit. Audit reports and retained checks are in [audits/](audits/) and [logs/](logs/).

### Scope

Canonical ABI calldata; arbitrary in-range addresses and amount; symbolic storage and existing logs; non-static execution. Source and destination storage locations need not be distinct. Recipient addition wraps modulo 2^256; self-transfer is included.

These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, gas assumptions and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision and proves the unchanged specification. Results are saved under `.kprover/`; independent audit checks are recorded separately.
