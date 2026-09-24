# `L1StandardBridge:finalizeBridgeETH`

- kind: EVM function; behavior: **paused ETH bridge finalization reverts with `StandardBridge: paused`**
- source: [helpers/StandardBridge.sol:239](helpers/StandardBridge.sol#L239), [contract.sol:123](contract.sol#L123)
- artifact: [contract.bin](contract.bin), the complete 12,620-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

```solidity
function finalizeBridgeETH(
    address _from,
    address _to,
    uint256 _amount,
    bytes calldata _extraData
)
    public
    payable
    onlyOtherBridge
{
    require(paused() == false, "StandardBridge: paused");
    require(msg.value == _amount, "StandardBridge: amount sent does not match amount required");
    require(_to != address(this), "StandardBridge: cannot send to self");
    require(_to != address(messenger), "StandardBridge: cannot send to messenger");

    // Emit the correct events. By default this will be _amount, but child
    // contracts may override this function in order to emit legacy events as well.
    _emitETHBridgeFinalized(_from, _to, _amount, _extraData);

    bool success = SafeCall.call(_to, gasleft(), _amount, hex"");
    require(success, "StandardBridge: ETH transfer failed");
}
```

The L1 implementation supplies the [pause check](contract.sol#L123):

```solidity
function paused() public view override returns (bool) {
    return systemConfig.paused();
}
```

The target function is inherited from [helpers/StandardBridge.sol](helpers/StandardBridge.sol#L239); `contract.sol` contains the L1 implementation.

## Bytecode (from the runtime)

Dispatch for `finalizeBridgeETH` (`0x1635f5fd`):

```text
0x015a  DUP1
0x015b  PUSH4 0x1635f5fd
0x0160  EQ
0x0161  PUSH2 0x02ae
0x0164  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

Paused ETH bridge finalization reverts with `StandardBridge: paused`. The symbolic claim is stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); the original independent specification and proof audit findings are in [audits/](audits/).

### Scope

Canonical symbolic bridge arguments and dynamic bytes up to 2³⁰; an authorized cross-domain caller and a true response from the configured pause responder. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves [spec.k](spec.k). Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
