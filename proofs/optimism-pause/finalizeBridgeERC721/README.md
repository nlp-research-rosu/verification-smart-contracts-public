# `L1ERC721Bridge:finalizeBridgeERC721`

- kind: EVM function; behavior: **paused ERC721 bridge finalization reverts with `L1ERC721Bridge: paused`**
- source: [contract.sol:86](contract.sol#L86), [contract.sol:66](contract.sol#L66)
- artifact: [contract.bin](contract.bin), the complete 6,186-byte implementation runtime
- semantics: [`evm`](https://github.com/nlp-research-rosu/semantics-evm/tree/4f4c3843076c) at `4f4c3843076c`; `LONDON`; unbounded gas

## Source

```solidity
function finalizeBridgeERC721(
    address _localToken,
    address _remoteToken,
    address _from,
    address _to,
    uint256 _tokenId,
    bytes calldata _extraData
)
    external
    onlyOtherBridge
{
    require(paused() == false, "L1ERC721Bridge: paused");
    require(_localToken != address(this), "L1ERC721Bridge: local token cannot be self");

    // Checks that the L1/L2 NFT pair has a token ID that is escrowed in the L1 Bridge.
    require(
        deposits[_localToken][_remoteToken][_tokenId] == true,
        "L1ERC721Bridge: Token ID is not escrowed in the L1 Bridge"
    );

    // Mark that the token ID for this L1/L2 token pair is no longer escrowed in the L1
    // Bridge.
    deposits[_localToken][_remoteToken][_tokenId] = false;

    // When a withdrawal is finalized on L1, the L1 Bridge transfers the NFT to the
    // withdrawer.
    IERC721(_localToken).safeTransferFrom({ from: address(this), to: _to, tokenId: _tokenId });

    // slither-disable-next-line reentrancy-events
    emit ERC721BridgeFinalized(_localToken, _remoteToken, _from, _to, _tokenId, _extraData);
}
```

The L1 implementation supplies the [pause check](contract.sol#L66):

```solidity
function paused() public view override returns (bool) {
    return systemConfig.paused();
}
```

## Bytecode (from the runtime)

Dispatch for `finalizeBridgeERC721` (`0x761f4493`):

```text
0x007d  DUP1
0x007e  PUSH4 0x761f4493
0x0083  EQ
0x0084  PUSH2 0x026d
0x0087  JUMPI
```

Offsets are hexadecimal. These excerpts identify dispatch; the claims execute the complete [runtime](contract.bin).

## Claim

Paused ERC721 bridge finalization reverts with `L1ERC721Bridge: paused`. The symbolic claim is stated in [spec.k](spec.k). The validated result and limitations are summarized in [PROOF.md](PROOF.md); the original independent specification and proof audit findings are in [audits/](audits/).

### Scope

Canonical symbolic bridge arguments and dynamic bytes up to 2³⁰; an authorized cross-domain caller and a true response from the configured pause responder. These are partial-correctness claims under the pinned EVM model. Source-to-bytecode compiler correctness is not proved. See [SCOPE.md](SCOPE.md) for the exact entry state, observed cells, and exclusions.

## Reproduce

With `kprover`, Python 3 and access to Prover configured, run from this directory:

```sh
./prove.sh
```

The command starts a fresh session, checks the pinned semantics revision, and proves [spec.k](spec.k). Results are saved under `.kprover/`; independent audit checks, where completed, are recorded separately.
