# `L1StandardBridge:finalizeBridgeERC20`

- kind: EVM function; behavior: **paused ERC20 bridge finalization reverts with `StandardBridge: paused`**
- source: [helpers/StandardBridge.sol:272](helpers/StandardBridge.sol#L272), [contract.sol:123](contract.sol#L123)
- artifact: [contract.bin](contract.bin), the complete 12,620-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

```solidity
function finalizeBridgeERC20(
    address _localToken,
    address _remoteToken,
    address _from,
    address _to,
    uint256 _amount,
    bytes calldata _extraData
)
    public
    onlyOtherBridge
{
    require(paused() == false, "StandardBridge: paused");
    if (_isOptimismMintableERC20(_localToken)) {
        require(
            _isCorrectTokenPair(_localToken, _remoteToken),
            "StandardBridge: wrong remote token for Optimism Mintable ERC20 local token"
        );

        IOptimismMintableERC20(_localToken).mint(_to, _amount);
    } else {
        deposits[_localToken][_remoteToken] = deposits[_localToken][_remoteToken] - _amount;
        IERC20(_localToken).safeTransfer(_to, _amount);
    }

    // Emit the correct events. By default this will be ERC20BridgeFinalized, but child
    // contracts may override this function in order to emit legacy events as well.
    _emitERC20BridgeFinalized(_localToken, _remoteToken, _from, _to, _amount, _extraData);
}
```

The L1 implementation supplies the [pause check](contract.sol#L123):

```solidity
function paused() public view override returns (bool) {
    return systemConfig.paused();
}
```

The target function is inherited from [helpers/StandardBridge.sol](helpers/StandardBridge.sol#L272); `contract.sol` contains the L1 implementation.

## Bytecode (from the runtime)

Dispatch for `finalizeBridgeERC20` (`0x0166a07a`):

```text
0x0180  DUP1
0x0181  PUSH4 0x0166a07a
0x0186  EQ
0x0187  PUSH2 0x0268
0x018a  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

Paused ERC20 bridge finalization reverts with `StandardBridge: paused`. The symbolic claim is stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); the original independent specification and proof audit findings are in [audits/](audits/).

### Scope

Canonical symbolic bridge arguments and dynamic bytes up to 2³⁰; an authorized cross-domain caller and a true response from the configured pause responder. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves [spec.k](spec.k). Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
