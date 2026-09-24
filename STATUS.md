# Verification status

| Contract | Function | Proof | Independent KIT audit |
| --- | --- | --- | --- |
| hkg | [allowance](proofs/hkg/allowance/) | Proved | PASS |
| hkg | [approve](proofs/hkg/approve/) | Proved | PASS |
| hkg | [balanceOf](proofs/hkg/balanceOf/) | Proved | PASS |
| hkg | [totalSupply](proofs/hkg/totalSupply/) | Proved | PASS |
| hkg | [transfer](proofs/hkg/transfer/) | Proved | PASS |
| hkg | [transferFrom](proofs/hkg/transferFrom/) | Proved | PASS |
| dstoken | [allowance](proofs/dstoken/allowance/) | Proved | PASS |
| dstoken | [approve](proofs/dstoken/approve/) | Proved | PASS |
| dstoken | [balanceOf](proofs/dstoken/balanceOf/) | Proved | PASS |
| dstoken | [totalSupply](proofs/dstoken/totalSupply/) | Proved | PASS |
| dstoken | [transfer](proofs/dstoken/transfer/) | Proved | PASS |
| dstoken | [transferFrom](proofs/dstoken/transferFrom/) | Proved | PASS |
| dsvalue | [peek](proofs/dsvalue/peek-read/) | Proved | PASS |
| dsvalue | [read](proofs/dsvalue/peek-read/) | Proved | PASS |
| storagevar00 | [execute](proofs/storagevar00/execute/) | Proved | PASS |
| optimism-pause | [OptimismPortal2.proveWithdrawalTransaction](proofs/optimism-pause/pausability/) | Proved for array lengths 0–10 | SOUND-BUT-LIMITED |
| optimism-pause | [OptimismPortal2.finalizeWithdrawalTransaction](proofs/optimism-pause/pausability/) | Proved | SOUND-BUT-LIMITED |
| optimism-pause | [L1StandardBridge.finalizeBridgeETH](proofs/optimism-pause/pausability/) | Proved | SOUND-BUT-LIMITED |
| optimism-pause | [L1StandardBridge.finalizeBridgeERC20](proofs/optimism-pause/pausability/) | Proved | SOUND-BUT-LIMITED |
| optimism-pause | [L1ERC721Bridge.finalizeBridgeERC721](proofs/optimism-pause/pausability/) | Proved | SOUND-BUT-LIMITED |
| optimism-pause | [L1CrossDomainMessenger.relayMessage](proofs/optimism-pause/pausability/) | Proved | SOUND-BUT-LIMITED |
| optimism-pause | [SuperchainConfig.pause](proofs/optimism-pause/pausability/) | Proved under stated guardian conditions | No separate audit |
| optimism-pause | [SuperchainConfig.paused](proofs/optimism-pause/pausability/) | Proved under stated timestamp conditions | No separate audit |
| optimism-pause | [ETHLockbox.paused](proofs/optimism-pause/pausability/) | Proved under stated pause conditions | No separate audit |
| optimism-pause | [SystemConfig.paused](proofs/optimism-pause/pausability/) | Proved under stated pause conditions | No separate audit |

HKG `totalSupply` proves rejection of an unsupported selector.

The first four projects contain 14 proof packages covering 15 function targets;
DSValue `peek` and `read` share one package. The Optimism package adds six
paused-operation targets and four separate pause-dependency claims under the
limits stated in its [scope](proofs/optimism-pause/pausability/SCOPE.md).
