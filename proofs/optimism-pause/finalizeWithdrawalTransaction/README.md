# `OptimismPortal2:finalizeWithdrawalTransaction`

- kind: EVM function; behavior: **paused portal finalization reverts with `OptimismPortal_CallPaused` before finalizing a withdrawal**
- source: [contract.sol:492](contract.sol#L492)
- artifact: [contract.bin](contract.bin), the complete 23,033-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

```solidity
function finalizeWithdrawalTransaction(Types.WithdrawalTransaction memory _tx) external {
    finalizeWithdrawalTransactionExternalProof(_tx, msg.sender);
}
```

The wrapper calls [finalizeWithdrawalTransactionExternalProof](contract.sol#L573), whose first check rejects a paused system:

```solidity
function finalizeWithdrawalTransactionExternalProof(
    Types.WithdrawalTransaction memory _tx,
    address _proofSubmitter
)
    public
{
    // Cannot finalize withdrawal transactions while the system is paused.
    _assertNotPaused();

    // Cannot finalize withdrawal with value when custom gas token mode is enabled.
    if (_isUsingCustomGasToken()) {
        if (_tx.value > 0) revert OptimismPortal_NotAllowedOnCGTMode();
    }

    // Make sure that the l2Sender has not yet been set. The l2Sender is set to a value other
    // than the default value when a withdrawal transaction is being finalized. This check is
    // a defacto reentrancy guard.
    if (l2Sender != Constants.DEFAULT_L2_SENDER) {
        revert OptimismPortal_NoReentrancy();
    }

    // Make sure that the target address is safe.
    if (_isUnsafeTarget(_tx.target)) {
        revert OptimismPortal_BadTarget();
    }

    // Grab the withdrawal.
    bytes32 withdrawalHash = Hashing.hashWithdrawal(_tx);

    // Check that the withdrawal can be finalized.
    checkWithdrawal(withdrawalHash, _proofSubmitter);

    // Mark the withdrawal as finalized so it can't be replayed.
    finalizedWithdrawals[withdrawalHash] = true;

    // If using ETHLockbox, unlock the ETH from the ETHLockbox.
    if (_isUsingLockbox()) {
        if (_tx.value > 0) ethLockbox.unlockETH(_tx.value);
    }

    // Set the l2Sender so contracts know who triggered this withdrawal on L2.
    l2Sender = _tx.sender;

    // Trigger the call to the target contract. We use a custom low level method
    // SafeCall.callWithMinGas to ensure two key properties
    //   1. Target contracts cannot force this call to run out of gas by returning a very large
    //      amount of data (and this is OK because we don't care about the returndata here).
    //   2. The amount of gas provided to the execution context of the target is at least the
    //      gas limit specified by the user. If there is not enough gas in the current context
    //      to accomplish this, `callWithMinGas` will revert.
    bool success = SafeCall.callWithMinGas(_tx.target, _tx.gasLimit, _tx.value, _tx.data);

    // Reset the l2Sender back to the default value.
    l2Sender = Constants.DEFAULT_L2_SENDER;

    // All withdrawals are immediately finalized. Replayability can
    // be achieved through contracts built on top of this contract
    emit WithdrawalFinalized(withdrawalHash, success);

    // If using ETHLockbox, send ETH back to the Lockbox in the case of a failed transaction or
    // it'll get stuck here and would need to be moved back via admin action.
    if (_isUsingLockbox()) {
        if (!success && _tx.value > 0) {
            ethLockbox.lockETH{ value: _tx.value }();
        }
    }

    // Reverting here is useful for determining the exact gas cost to successfully execute the
    // sub call to the target contract if the minimum gas limit specified by the user would not
    // be sufficient to execute the sub call.
    if (!success && tx.origin == Constants.ESTIMATION_ADDRESS) {
        revert OptimismPortal_GasEstimation();
    }
}
```

## Bytecode (from the runtime)

Dispatch for `finalizeWithdrawalTransaction` (`0x8c3152e9`):

```text
0x00ed  DUP1
0x00ee  PUSH4 0x8c3152e9
0x00f3  EQ
0x00f4  PUSH2 0x048c
0x00f7  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

Paused portal finalization reverts with `OptimismPortal_CallPaused` before finalizing a withdrawal. The symbolic claim is stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); the original independent specification and proof audit findings are in [audits/](audits/).

### Scope

Canonical symbolic withdrawal transaction and other scalar arguments; the configured pause responder returns true. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves [spec.k](spec.k). Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
