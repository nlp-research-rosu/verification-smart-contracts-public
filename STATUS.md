# Verification status

| Contract | Function | Proof | KIT Audit (subagent) |
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

HKG `totalSupply` proves rejection of an unsupported selector.

The repository contains 14 proof packages covering 15 function targets;
DSValue `peek` and `read` share one package.
