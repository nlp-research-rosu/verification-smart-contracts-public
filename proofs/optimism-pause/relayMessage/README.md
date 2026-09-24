# `L1CrossDomainMessenger:relayMessage`

- kind: EVM function; behavior: **paused message relay reverts with `CrossDomainMessenger: paused`**
- source: [helpers/CrossDomainMessenger.sol:222](helpers/CrossDomainMessenger.sol#L222), [contract.sol:64](contract.sol#L64)
- artifact: [contract.bin](contract.bin), the complete 9,614-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

```solidity
function relayMessage(
    uint256 _nonce,
    address _sender,
    address _target,
    uint256 _value,
    uint256 _minGasLimit,
    bytes calldata _message
)
    external
    payable
{
    // On L1 this function will check the Portal for its paused status.
    // On L2 this function should be a no-op, because paused will always return false.
    require(paused() == false, "CrossDomainMessenger: paused");

    (, uint16 version) = Encoding.decodeVersionedNonce(_nonce);
    require(version < 2, "CrossDomainMessenger: only version 0 or 1 messages are supported at this time");

    // If the message is version 0, then it's a migrated legacy withdrawal. We therefore need
    // to check that the legacy version of the message has not already been relayed.
    if (version == 0) {
        bytes32 oldHash = Hashing.hashCrossDomainMessageV0(_target, _sender, _message, _nonce);
        require(successfulMessages[oldHash] == false, "CrossDomainMessenger: legacy withdrawal already relayed");
    }

    // We use the v1 message hash as the unique identifier for the message because it commits
    // to the value and minimum gas limit of the message.
    bytes32 versionedHash =
        Hashing.hashCrossDomainMessageV1(_nonce, _sender, _target, _value, _minGasLimit, _message);

    if (_isOtherMessenger()) {
        // These properties should always hold when the message is first submitted (as
        // opposed to being replayed).
        assert(msg.value == _value);
        assert(!failedMessages[versionedHash]);
    } else {
        require(msg.value == 0, "CrossDomainMessenger: value must be zero unless message is from a system address");

        require(failedMessages[versionedHash], "CrossDomainMessenger: message cannot be replayed");
    }

    require(
        _isUnsafeTarget(_target) == false, "CrossDomainMessenger: cannot send message to blocked system address"
    );

    require(successfulMessages[versionedHash] == false, "CrossDomainMessenger: message has already been relayed");

    // If there is not enough gas left to perform the external call and finish the execution,
    // return early and assign the message to the failedMessages mapping.
    // We are asserting that we have enough gas to:
    // 1. Call the target contract (_minGasLimit + RELAY_CALL_OVERHEAD + RELAY_GAS_CHECK_BUFFER)
    //   1.a. The RELAY_CALL_OVERHEAD is included in `hasMinGas`.
    // 2. Finish the execution after the external call (RELAY_RESERVED_GAS).
    //
    // If `xDomainMsgSender` is not the default L2 sender, this function
    // is being re-entered. This marks the message as failed to allow it to be replayed.
    if (
        !SafeCall.hasMinGas(_minGasLimit, RELAY_RESERVED_GAS + RELAY_GAS_CHECK_BUFFER)
            || xDomainMsgSender != Constants.DEFAULT_L2_SENDER
    ) {
        failedMessages[versionedHash] = true;
        emit FailedRelayedMessage(versionedHash);

        // Revert in this case if the transaction was triggered by the estimation address. This
        // should only be possible during gas estimation or we have bigger problems. Reverting
        // here will make the behavior of gas estimation change such that the gas limit
        // computed will be the amount required to relay the message, even if that amount is
        // greater than the minimum gas limit specified by the user.
        if (tx.origin == Constants.ESTIMATION_ADDRESS) {
            revert("CrossDomainMessenger: failed to relay message");
        }

        return;
    }

    xDomainMsgSender = _sender;
    bool success = SafeCall.call(_target, gasleft() - RELAY_RESERVED_GAS, _value, _message);
    xDomainMsgSender = Constants.DEFAULT_L2_SENDER;

    if (success) {
        // This check is identical to one above, but it ensures that the same message cannot be relayed
        // twice, and adds a layer of protection against rentrancy.
        assert(successfulMessages[versionedHash] == false);
        successfulMessages[versionedHash] = true;
        emit RelayedMessage(versionedHash);
    } else {
        failedMessages[versionedHash] = true;
        emit FailedRelayedMessage(versionedHash);

        // Revert in this case if the transaction was triggered by the estimation address. This
        // should only be possible during gas estimation or we have bigger problems. Reverting
        // here will make the behavior of gas estimation change such that the gas limit
        // computed will be the amount required to relay the message, even if that amount is
        // greater than the minimum gas limit specified by the user.
        if (tx.origin == Constants.ESTIMATION_ADDRESS) {
            revert("CrossDomainMessenger: failed to relay message");
        }
    }
}
```

The L1 implementation supplies the [pause check](contract.sol#L64):

```solidity
function paused() public view override returns (bool) {
    return systemConfig.paused();
}
```

The target function is inherited from [helpers/CrossDomainMessenger.sol](helpers/CrossDomainMessenger.sol#L222); `contract.sol` contains the L1 implementation.

## Bytecode (from the runtime)

Dispatch for `relayMessage` (`0xd764ad0b`):

```text
0x007b  DUP1
0x007c  PUSH4 0xd764ad0b
0x0081  EQ
0x0082  PUSH2 0x052e
0x0085  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

Paused message relay reverts with `CrossDomainMessenger: paused`. The symbolic claim is stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); the original independent specification and proof audit findings are in [audits/](audits/).

### Scope

Canonical symbolic message arguments and dynamic bytes up to 2³⁰; the configured pause responder returns true. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves [spec.k](spec.k). Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
