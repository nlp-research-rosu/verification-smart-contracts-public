# Smart-contract verification

Smart-contract specifications verified with KIT and K EVM semantics, with
proof evidence and independent KIT audits.

| Contract | Verified packages |
| --- | --- |
| [HKG](proofs/hkg/) | allowance, approve, balanceOf, totalSupply rejection, transfer, transferFrom |
| [DSToken](proofs/dstoken/) | allowance, approve, balanceOf, totalSupply, transfer, transferFrom |
| [DSValue](proofs/dsvalue/) | peek, read |
| [storagevar00](proofs/storagevar00/) | execute |

See [STATUS.md](STATUS.md) for results. Each function directory contains its
source, bytecode, specification, required helpers, proof record, audits and
reproduction command.

Proofs establish the stated properties under their recorded assumptions;
they do not certify every behavior of a contract. See each package’s SCOPE.md
and PROOF.md for gas, fork, call-domain and trust assumptions.
