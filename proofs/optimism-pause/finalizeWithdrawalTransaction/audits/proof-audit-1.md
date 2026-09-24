# Proof audit

## Artifacts examined

The original six-operation claim module, its runtime definitions and Prover results. For the portal withdrawal-array claims, a later audit also examined the saved single-claim inputs and positive results.

## Result

The independent audit checked runtime identity, replayed all six original operation claims, and rejected a false-status control. It found sound execution under the stated assumptions, with limited coverage. The later array audit accepted the ten exact saved inputs and positive results but did not complete a fresh clean-room replay. The dynamic-byte bound remains 2³⁰ against RV's 2⁶³ reference. These are separate audit findings for the original and array proofs; this extracted per-function module was not itself independently replayed.

STATUS: SOUND-BUT-LIMITED
