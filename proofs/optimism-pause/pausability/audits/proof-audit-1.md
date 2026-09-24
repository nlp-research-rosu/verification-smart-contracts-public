# Proof audit

## Audit identity and artifacts

The six operation claims in `spec.k` and their `verification.k` definitions received an independent KIT proof audit. The ten nonempty-array claims received a later independent evidence-only KIT audit of saved Prover results and exact K inputs. The four pause-dependency claims have positive Prover results but no completed independent KIT proof audit.

The full original audit records and machine-readable result evidence are preserved in the [Optimism experiment archive](https://github.com/nlp-research-rosu/verification-smart-contracts-experiments/tree/main/contracts/optimism-pause/experiments/code-to-spec/runs/gpt-5.6-sol). This package retains the exact claim and verification files.

## Gate A — supplied program execution

The original operation audit checked the ground runtime definitions against the supplied bytecode, confirmed that they do not replace EVM execution, replayed all six claims, and rejected a false-status control. The array audit checked that all ten saved individual results were `proved` with exit code 0 and no residual, and that their saved K inputs matched the claim files. Its fresh clean-room replay did not complete, so it is not counted as one.

## Gate B — scope

The original portal-prove claim covered only an empty withdrawal-proof array. Ten subsequently proved claims cover lengths 1–10 with independent symbolic 600-byte elements. The pinned ABI helper still restricts other dynamic byte inputs to 2³⁰ bytes. RV's reference uses 2⁶³; that interval is not covered by these theorems. The operation claims also assume a true pause response rather than proving a combined call chain.

## Gate C — trust boundary

The result is conditional on the pinned `evm` semantics at `4f4c3843076c`, supplied implementation bytecode, the K/KEVM toolchain and solver, canonical ABI calls, London, and the stated paused and authorization environment. Proxy deployment, finite gas, and source-to-bytecode compilation are not proved. The dependency claims establish pause behavior only under their own storage, address, guardian, and time conditions.

STATUS: SOUND-BUT-LIMITED for the independently audited operation and array evidence; no separate KIT audit status is asserted for the four dependency claims.
