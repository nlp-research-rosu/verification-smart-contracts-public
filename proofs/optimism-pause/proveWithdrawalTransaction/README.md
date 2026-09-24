# `OptimismPortal2:proveWithdrawalTransaction`

- kind: EVM function; behavior: **paused portal proof call reverts with `OptimismPortal_CallPaused` before recording a withdrawal proof**
- source: [contract.sol:386](contract.sol#L386)
- artifact: [contract.bin](contract.bin), the complete 23,033-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

```solidity
function proveWithdrawalTransaction(
    Types.WithdrawalTransaction memory _tx,
    uint256 _disputeGameIndex,
    Types.OutputRootProof calldata _outputRootProof,
    bytes[] calldata _withdrawalProof
)
    external
{
    // Cannot prove withdrawal transactions while the system is paused.
    _assertNotPaused();

    // Make sure that the target address is safe.
    if (_isUnsafeTarget(_tx.target)) {
        revert OptimismPortal_BadTarget();
    }

    // Cannot prove withdrawal with value when custom gas token mode is enabled.
    if (_isUsingCustomGasToken()) {
        if (_tx.value > 0) revert OptimismPortal_NotAllowedOnCGTMode();
    }

    // Fetch the dispute game proxy from the `DisputeGameFactory` contract.
    (,, IDisputeGame disputeGameProxy) = disputeGameFactory().gameAtIndex(_disputeGameIndex);

    // Game must be a Proper Game.
    if (!anchorStateRegistry.isGameProper(disputeGameProxy)) {
        revert OptimismPortal_ImproperDisputeGame();
    }

    // Game must have been respected game type when created.
    if (!anchorStateRegistry.isGameRespected(disputeGameProxy)) {
        revert OptimismPortal_InvalidDisputeGame();
    }

    // Game must not have resolved in favor of the Challenger (invalid root claim).
    if (disputeGameProxy.status() == GameStatus.CHALLENGER_WINS) {
        revert OptimismPortal_InvalidDisputeGame();
    }

    // As a sanity check, we make sure that the current timestamp is not less than or equal to
    // the dispute game's creation timestamp. Not strictly necessary but extra layer of
    // safety against weird bugs. Note that this blocks withdrawals from being proven in the
    // same block that a dispute game is created.
    if (block.timestamp <= disputeGameProxy.createdAt().raw()) {
        revert OptimismPortal_InvalidProofTimestamp();
    }

    // Extract the output root claim. Super game types use rootClaimByChainId to extract
    // the per-chain output root from the super root. Legacy game types use rootClaim directly.
    // TODO(#19816): Post interop clean up the legacy rootClaim() usage in OptimismPortal2.
    Claim outputRootClaim;
    if (GameTypes.isSuperGame(disputeGameProxy.gameType())) {
        outputRootClaim = disputeGameProxy.rootClaimByChainId(systemConfig.l2ChainId());
    } else {
        outputRootClaim = disputeGameProxy.rootClaim();
    }

    // Verify that the output root can be generated with the elements in the proof.
    if (outputRootClaim.raw() != Hashing.hashOutputRootProof(_outputRootProof)) {
        revert OptimismPortal_InvalidOutputRootProof();
    }

    // Load the ProvenWithdrawal into memory, using the withdrawal hash as a unique identifier.
    bytes32 withdrawalHash = Hashing.hashWithdrawal(_tx);

    // Compute the storage slot of the withdrawal hash in the L2ToL1MessagePasser contract.
    // Refer to the Solidity documentation for more information on how storage layouts are
    // computed for mappings.
    bytes32 storageKey = keccak256(
        abi.encode(
            withdrawalHash,
            uint256(0) // The withdrawals mapping is at the first slot in the layout.
        )
    );

    // Verify that the hash of this withdrawal was stored in the L2toL1MessagePasser contract
    // on L2. If this is true, under the assumption that the SecureMerkleTrie does not have
    // bugs, then we know that this withdrawal was actually triggered on L2 and can therefore
    // be relayed on L1.
    if (
        SecureMerkleTrie.verifyInclusionProof({
            _key: abi.encode(storageKey),
            _value: hex"01",
            _proof: _withdrawalProof,
            _root: _outputRootProof.messagePasserStorageRoot
        }) == false
    ) {
        revert OptimismPortal_InvalidMerkleProof();
    }

    // Designate the withdrawalHash as proven by storing the disputeGameProxy and timestamp in
    // the provenWithdrawals mapping. A given user may re-prove a withdrawalHash multiple
    // times, but each proof will reset the proof timer.
    provenWithdrawals[withdrawalHash][msg.sender] =
        ProvenWithdrawal({ disputeGameProxy: disputeGameProxy, timestamp: uint64(block.timestamp) });

    // Add the proof submitter to the list of proof submitters for this withdrawal hash.
    proofSubmitters[withdrawalHash].push(msg.sender);

    // Emit a WithdrawalProven events.
    emit WithdrawalProven(withdrawalHash, _tx.sender, _tx.target);
    emit WithdrawalProvenExtension1(withdrawalHash, msg.sender);
}
```

## Bytecode (from the runtime)

Dispatch for `proveWithdrawalTransaction` (`0x4870496f`):

```text
0x0165  DUP1
0x0166  PUSH4 0x4870496f
0x016b  EQ
0x016c  PUSH2 0x0362
0x016f  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

Paused portal proof call reverts with `OptimismPortal_CallPaused` before recording a withdrawal proof. The 11 symbolic claims are stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); the original independent specification and proof audit findings are in [audits/](audits/).

### Scope

Canonical withdrawal transaction, output-root proof and withdrawal-proof arrays of lengths 0–10; each nonempty element is an independent symbolic 600-byte value; the configured pause responder returns true. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves the eleven claims collected in [spec.k](spec.k). The retained positive results came from the original six-operation proof for length 0 and ten separate single-claim proofs for lengths 1–10; this collected module was not separately submitted. Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
