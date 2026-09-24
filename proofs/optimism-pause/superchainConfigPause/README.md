# `SuperchainConfig:pause`

- kind: EVM function; behavior: **a guardian call records a positive global pause timestamp**
- source: [contract.sol:81](contract.sol#L81)
- artifact: [contract.bin](contract.bin), the complete 3,195-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

```solidity
function pause(address _identifier) external {
    // Only the Guardian can pause the system.
    _assertOnlyGuardian();

    // Cannot pause if the identifier is already paused to prevent re-pausing without either
    // unpausing, extending, or resetting the pause timestamp.
    if (pauseTimestamps[_identifier] != 0) {
        revert SuperchainConfig_AlreadyPaused(_identifier);
    }

    // Set the pause timestamp.
    pauseTimestamps[_identifier] = block.timestamp;
    emit Paused(_identifier);
}
```

## Bytecode (from the runtime)

Dispatch for `pause` (`0x76a67a51`):

```text
0x007d  DUP1
0x007e  PUSH4 0x76a67a51
0x0083  EQ
0x0084  PUSH2 0x028f
0x0087  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

A guardian call records a positive global pause timestamp. The symbolic claim is stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); no independent KIT proof audit was completed for this dependency claim.

### Scope

Canonical `pause(address(0))` call from the configured nonzero guardian with a positive symbolic timestamp; the caller matches the configured guardian. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves [spec.k](spec.k). Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
