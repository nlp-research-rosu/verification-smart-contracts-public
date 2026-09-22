STATUS: VALIDATED ([independent proof audit](audits/proof-audit-1.md))

# PROOF.md — `DSToken:transfer`

The supplied DSToken runtime implements the public
`transfer(address,uint256)` behavior stated below under the pinned
Byzantium EVM model with gas accounting disabled. The independent audit
replayed all twelve claims and rejected both a false postcondition and a
material change to the executed transfer body.

## What is proven

For canonical ABI calldata, non-static execution, 160-bit addresses, and
uint256 words, the raw claims cover all contract addresses and these six
cases. The stopped flag occupies the byte at bit offset 160 of storage
slot 4; balance locations are Solidity mapping slots rooted at slot 1.

| Condition, in execution order | Raw result and storage |
|---|---|
| Nonzero call value | `EVMC_REVERT`; no storage or log changes. |
| Stopped flag is nonzero | `EVMC_INVALID_INSTRUCTION`; no storage or log changes. |
| Source balance is below the amount | Invalid instruction; storage unchanged, LogNote retained. |
| Distinct balance slots and destination credit overflows | Invalid instruction; source debit and LogNote retained. |
| Distinct slots, enough source balance, no overflow | Success, ABI true, debit/credit, LogNote and Transfer. |
| Equal slots and enough source balance | Success, ABI true, effective balance restored, both events. |

The additional six enclosing-call claims execute fixed call-stack and
world-state operations at token addresses greater than 8. They commit
successful changes and roll every failed call's storage and logs back,
returning the caller-stack success bit 1 or 0. They describe this nested
call boundary, not complete Ethereum transaction processing.

## Formal claim (from `spec.k`)

Let `h(a) = keccak(encode256(a) ++ encode256(1))`, `M = 2^256`, and
`stopped(S) = (S[4] div 2^160) mod 256`. For zero call value, a call
succeeds precisely when `stopped(S)=0`, `amount <= S[h(source)]`,
and `(h(source)=h(destination) or S[h(destination)] + amount < M)`.
Success returns `encode256(1)` and performs the two balance writes. Equal
slots restore their initial effective value. The exact K claims constrain
the complete token storage map and exact event records; machine-local
final values are existential. The byte-level statement is in
[spec.k](spec.k), and its explicit scope is in [SCOPE.md](SCOPE.md).

## Proof-extension inventory

The only local equation defines `#binRuntime(DSTOKEN)` as the original
6,955-byte runtime, SHA-256
`65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`.
It is a terminating singleton constant definition, not an execution
shortcut. All twelve reachability claims are proved, with no local
operational bridge, result oracle, trusted claim, filter, or depth bound.
[Inventory](logs/evidence/audit/independent-inventory.json) and
[static review](logs/evidence/audit/static-review.md) contain the complete review.

## Exact commands and actual outputs

Audit session `1780f457-da0a-48bc-b9fe-eaf832efe9fb` pins `evm` to
`4f4c3843076cfa7c30b7fbffa731f3346cf379bb` in
`https://github.com/nlp-research-rosu/semantics-evm`.
[Exact invocations](logs/evidence/audit/commands.md) use caller-provided
`XDG_CONFIG_HOME`. [The task ledger](logs/evidence/audit/task-ledger.json) links all
stdout, stderr, typed results, and timings. The unfiltered replay task is
`487c0300-1608-4ca7-a68e-f0a7cc13e39f`: `proved`, null structured residual,
K/CLI exit 0, and twelve actual `PROOF PASSED` labels. Backend execution
was 1696.355 seconds.
The service supplied passed labels rather than raw `#Top` output.

The concrete witness task `fca12717-e5a1-401a-89f2-ee935a1a712b` is
`proved`, exit 0. The false-return task `a6f79d35-ae0f-425d-89e3-5f7f871512af`
is `notProved`, exit 1, with actual ABI output 1 against expected 2.
The changed-body task `e7de0ffb-acbe-4f90-b592-edbdab05c743` is `notProved`,
exit 1, with actual output 0 against expected 1. Both failures contain a
real OUTPUT_CELL matching residual and no pending nodes. Their `#Top`
path condition is not a proof success. The first body validation had an
import-path preparation error, corrected before the body proof; its
original evidence remains in the ledger.

## Per-gate results

- **A PASS:** exact runtime execution, exhaustive local theory review,
  realizable witness, meaningful false-postcondition rejection, and
  observed dependence on the executed body.
- **B PASS:** all twelve symbolic claims retain their intended domains;
  the seven reference requirements are covered after explicit functional
  model normalization.
- **C PASS:** assumptions and exclusions are stated, and every claimed
  proof/control result has retained reproducible evidence.

The [independent audit](audits/proof-audit-1.md) gives the complete verdict.

## Trust boundary

The result is conditional on the pinned EVM semantics, bundled
optimizations/lemmas, K compiler/backend, SMT solver, cryptographic and
bytes hooks, and Prover executing the submitted sources faithfully. It
does not prove the implementations of those tools or source-to-bytecode
compilation. Symbolic hash collision resistance is not assumed: equal and
unequal storage locations are both covered.

## Empirically supported facts

The concrete self-transfer witness and two mutation checks are finite
controls, not a replacement for the twelve symbolic proofs. Exact byte
identity was checked for the original program and every reference runtime
constant. No external EVM implementation differential test is claimed.

## Excluded behavior

Excluded: finite-gas thresholds and out-of-gas behavior, malformed or
noncanonical calldata, static calls, other entry points including
`transferFrom`, deployment, and complete transaction-level processing.
Raw exceptional execution is distinguished from enclosing-call rollback.
Same-slot success preserves effective storage; an absent zero-valued slot
can become an explicit zero map entry, as stated in the exact claim.
