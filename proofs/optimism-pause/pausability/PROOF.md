STATUS: SOUND-BUT-LIMITED ([independent audit](audits/proof-audit-1.md))

# PROOF.md — Optimism L1 pausability

## Result

The six symbolic operation claims in [spec.k](spec.k) were proved against the supplied direct implementation runtimes under pinned EVM semantics `4f4c3843076c`. `OptimismPortal2.proveWithdrawalTransaction` was also proved for each withdrawal-proof array length 1–10 in [spec-array-N.k](spec-array-1.k), in addition to the empty-array claim in `spec.k`. Each nonempty element is independently symbolic and exactly 600 bytes long. The ten individual files have positive Prover results; the aggregate [spec-arrays.k](spec-arrays.k) is a convenient collection and is not presented as a separately completed aggregate proof.

Four additional claims in [spec-pause-symbolic.k](spec-pause-symbolic.k), [spec-global-symbolic.k](spec-global-symbolic.k), [spec-ethlockbox-inline.k](spec-ethlockbox-inline.k), and [spec-systemconfig-inline.k](spec-systemconfig-inline.k) have positive Prover results for guardian pause and the three pause getters under their written conditions. In all twenty proved claims, the retained Prover result is `proved`, exit code 0, and no residual. The operation claims and dependency claims remain separate theorems.

## Independent audit

The original six-claim package was independently replayed and checked against a false-status control. Its audit found sound execution of the supplied runtime but limited scope because the original portal-prove claim used an empty array. A later independent evidence-only audit accepted the ten positive individual array results and their matching saved K inputs, with status `SOUND-BUT-LIMITED`; it did not complete a fresh clean-room replay. The four dependency claims have positive Prover results but no separate completed KIT proof audit. [The audit record](audits/proof-audit-1.md) distinguishes these checks.

## Trust and limits

The result depends on the pinned KEVM semantics, K/KEVM prover and backend, solver, and supplied runtime-byte identity. Source-to-bytecode compiler correctness is not proved. The operation claims assume a true pause response; the separate dependency claims prove that response only under their own written preconditions. There is no single composed guardian-to-operation proof or deployed-proxy proof. The ABI helper limits other symbolic dynamic bytes to 2³⁰ bytes, whereas RV's reference admits up to 2⁶³. See [SCOPE.md](SCOPE.md) for the full input and execution boundary.
