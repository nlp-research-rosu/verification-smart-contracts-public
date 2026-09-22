# Proof audit 1

## Artifacts examined

- Original task: verify the HKG `approve` implementation for symbolic inputs
  and storage, including successful and unsuccessful calls, with remote Prover,
  then complete an independent audit.
- Construction session identity, used only to compare semantics pins:
  `4061601c-c8bc-4ea7-bc43-5e24891ed434`.
- `/app/output/spec.k`
- `/app/output/verification.k`
- `/app/output/helpers/hkg-bytecode.k`
- `/app/output/SCOPE.md`
- `/app/output/prove.sh`
- `/app/contract.bin`
- `/app/contract.sol`
- Approved baseline `/app/output/audits/spec-audit-1.md`
- Immutable bundled semantics `evm`, repository
  `https://github.com/nlp-research-rosu/semantics-evm`, commit
  `4f4c3843076c`.

I did not inspect or rely on any construction proof result, construction proof
evidence directory, or constructor report. The candidate files were not edited.

## Independent pin and clean room

`kprover health` exited 0 and reported `status: ok`, K version `7.1.337`.
`kprover semantics` exited 0 and independently selected `evm` at commit
`4f4c3843076c`. `kprover session show` on the supplied construction session
reported that same repository and commit. `kprover semantics fetch evm` exited
0 and made those immutable sources available at:

```text
/home/node/.config/kprover/semantics/nlp-research-rosu/semantics-evm/4f4c3843076c
```

Fresh audit session:

```text
109f025c-792d-46d5-8e2e-a3fcc0312d77
```

It was created by this exit-0 command:

```sh
kprover session start --project /app --semantics evm
```

`kprover session show 109f025c-792d-46d5-8e2e-a3fcc0312d77`
exited 0 and confirmed project `/app`, repository
`https://github.com/nlp-research-rosu/semantics-evm`, commit
`4f4c3843076c`, and a fresh zeroed operation ledger.

Only the following candidate proof sources were copied under the clean-room
`workspaceDir/inputs/` before validation and positive replay:

```text
inputs/spec.k                         db47983994a17fd59fbe5e8bcfc9ad057feb66cfc15e416cefc6a83cdbe5e097
inputs/verification.k                 aea20f641e49ecc3eaa1dc4019421deb3e08126ac9eaa141b3ab87e9be315e88
inputs/helpers/hkg-bytecode.k         a91ebcaae39cc75b118494034f042614989f574f76d9b9faf400b7234cb0faa9
```

The separately authored A5 mutation was added only later as
`inputs/mutation-output-zero-spec.k`; it is not a candidate file.

## Rebuilt proof-extension inventory

The exhaustive declaration scan over the three candidate proof sources found
three target claims, one token declaration, and one rule. It found no local
`[trusted]`, `[opaque]`, `[priority]`, `[owise]`, `[concrete]`,
`[simplification]`, or `[total]` declaration, no auxiliary claim, and no
ordinary rewrite over an execution cell.

### `hkg` runtime definition

- Extension: `syntax Contract ::= "hkg" [token]` together with
  `rule #binRuntime(hkg) => #parseByteStack("0x...")` in `HKG-BYTECODE`.
- Class: definitional summary.
- Semantic role: names the supplied program bytes; it does not replace an EVM
  execution region. The target claims still begin with `<k> #execute =>
  #halt </k>`, PC 0, an empty operand stack and memory, and execute the fixed
  opcode semantics.
- Domain: the singleton token `hkg`. This is every candidate use of
  `#binRuntime`; no totality attribute is asserted.
- Matched context: a pure `#binRuntime(hkg)` occurrence. There are no active
  continuation, control-stack, binding, or state-cell patterns in this rule.
- Justification scope and context containment: exact constant expansion is
  context-independent. A byte-for-byte comparison against `/app/contract.bin`
  returned `equal=true`, `embeddedBytes=2091`, `suppliedBytes=2091`; both have
  SHA-256
  `71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`.
- State footprint: none.
- Value influence: selects the program and computed jump destinations in all
  three target claims.
- Value justification: exhaustive equality of all 2,091 bytes, rather than a
  sampled comparison or an opaque symbol.
- Dependents: `SPEC.approve-success`,
  `SPEC.approve-nonpayable-revert`, and `SPEC.approve-static-failure`.
- Control validation: not applicable; it is not an operational bridge.
- Value validation: the complete byte comparison above. The singleton equation
  terminates in one step and has no local overlapping rule.

### Other theory

- `VERIFICATION-SUMMARIES` contains only `imports HKG-BYTECODE`. It contains no
  function, equation, rule, claim, or opaque term. This matches the approved
  spec-audit baseline, which explicitly recorded that the module introduced no
  mathematical summary. No post-audit summary meaning was added.
- `VERIFICATION` imports the empty summary wrapper and the immutable bundled
  `LEMMAS` module. `EDSL`, `EVM-OPTIMIZATIONS`, and `LEMMAS` are files in the
  selected, server-pinned `evm` bundle, not uploaded or copied proof-local
  modules. Their correctness is part of the named semantics/backend trust
  boundary below.
- The three declarations in `SPEC` are theorems being proved, not assumed
  claims. No `--trusted` option was used.

There is therefore no proof-local operational bridge to which the operational-
bridge context procedure applies, and no fresh, opaque, or newly summarized
result-bearing value to which the opposite-interpretation procedure applies.

## Commands and actual results

### Environment and semantics

The following read-only commands all exited 0:

```sh
kprover config
kprover health
kprover semantics
kprover session show 4061601c-c8bc-4ea7-bc43-5e24891ed434
kprover semantics fetch evm
kprover session start --project /app --semantics evm
kprover session show 109f025c-792d-46d5-8e2e-a3fcc0312d77
sha256sum /app/output/spec.k /app/output/verification.k /app/output/helpers/hkg-bytecode.k /app/output/SCOPE.md /app/output/prove.sh /app/contract.bin /app/contract.sol /app/output/audits/spec-audit-1.md
```

The configured proof-attempt limit was 20; the audit used four. The final
session ledger showed `attemptsUsed: 4`, `validationsUsed: 3`, and `runsUsed:
0`.

### Validation

The exact positive validation invocation was:

```sh
kprover validate --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k
```

The first accepted invocation created validation task
`0f8c44c9-645a-4810-bf5c-37bd4a7a9389`, but its local polling handle was lost
after the command yielded; the retained `validation-001/result.json` contains
only `status: queued`. No conclusion relies on it. The same exact validation was
submitted again and retained to completion as validation 002:

```text
task: 26f8dea9-8dbd-441d-b649-8905b76bf740
status: completed
result.valid: true
tool: kprove
tool outcome: success
exit code: 0
definition: 7_1_337-haskell-evm-4f4c3843076c-838526e00c4c5d0f17f8a69ccb011bba700a6e6518cabd906c03dd009f6de911
```

Its complete downloaded stdout and stderr are preserved at
`/app/.kprover/sessions/109f025c-792d-46d5-8e2e-a3fcc0312d77/validation-002/result.json`.
The stderr contains only compiler warnings for unused existential/unobserved
variables and one bundled-lemma variable; it contains no error.

### Positive claim replays

Each command used the same options below, adding only the shown `--claim`; no
depth bound, exclusion, or trust declaration was used:

```sh
kprover prove --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k --claim SPEC.approve-success
kprover prove --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k --claim SPEC.approve-nonpayable-revert
kprover prove --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k --claim SPEC.approve-static-failure
```

Actual retained results:

| Claim | Task ID | Exit | Typed result | Residual | Downloaded stdout |
|---|---|---:|---|---|---|
| `SPEC.approve-success` | `51869741-a325-4c5e-81cc-166334508dae` | 0 | `proved` | `null` | `PROOF PASSED: SPEC.approve-success` |
| `SPEC.approve-nonpayable-revert` | `90786117-baad-48af-b6f2-9259ce8f2a90` | 0 | `proved` | `null` | `PROOF PASSED: SPEC.approve-nonpayable-revert` |
| `SPEC.approve-static-failure` | `a794a9ce-b3bb-457e-b3e6-b903a054b03e` | 0 | `proved` | `null` | `PROOF PASSED: SPEC.approve-static-failure` |

For this EVM frontend the retained raw stdout says `PROOF PASSED`; the client
contract defines typed `proved` with null residual as closure with a `#Top`
KAST. Every proof's exact downloaded stderr is the same non-fatal warning:

```text
WARNING 2026-09-15 08:37:11,599 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

with timestamps `08:39:51,083` and `08:41:46,327` for the second and third
tasks. Complete evidence is preserved in clean-room `proof-001/result.json`,
`proof-002/result.json`, and `proof-003/result.json`.

### Fresh false-postcondition mutation

The independently authored file
`inputs/mutation-output-zero-spec.k` (SHA-256
`1a008b5c7940d3bf83f8dad4ac662deb6eb73deb65bf0cd21f23cd0ea65a11ff`)
retains the exact real program, initial state, precondition, status, log, and
storage postcondition from `approve-success`, but changes only:

```diff
- <output> .Bytes => #buf(32, 1) </output>
+ <output> .Bytes => #buf(32, 0) </output>
```

A satisfiable witness is `CONTRACT = 1`, `CALLER_ID = 2`, `SPENDER = 3`,
`VALUE = 7`, initially empty storage and log. All four range predicates hold;
the failing proof itself reports path condition `#Top`.

Validation command (exit 0, task
`60dae044-1c33-4776-a6fa-6ea95bb27455`, `result.valid: true`):

```sh
kprover validate --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/mutation-output-zero-spec.k --spec-module MUTATION-SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k
```

Proof command:

```sh
kprover prove --session 109f025c-792d-46d5-8e2e-a3fcc0312d77 --project /app --semantics evm --spec inputs/mutation-output-zero-spec.k --spec-module MUTATION-SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/helpers/hkg-bytecode.k --claim MUTATION-SPEC.approve-success-false-output
```

Actual result (exit 1):

```text
task: 9a794063-4755-49e6-9640-312c98097057
status: completed
outcome: notProved
PROOF FAILED: MUTATION-SPEC.approve-success-false-output
1 Failure nodes. (0 pending and 1 failing)
Failure reason:
  Matching failed.
  The following cells failed matching individually (antecedent #Implies consequent):
  OUTPUT_CELL: b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01" #Implies b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
Path condition:
  #Top
```

Although the typed response's optional `residual` field is null, the retained
stdout contains the concrete stuck/failing node and unmet condition quoted
above. Full stdout and stderr are preserved at clean-room
`proof-004/result.json`.

### Mechanical program checks

The independent Node byte comparison exited 0 and printed:

```text
{"equal":true,"embeddedBytes":2091,"suppliedBytes":2091}
```

A separate byte-pattern check exited 0 and found the `approve` selector at byte
55, the approve entry sequence at byte 600 (`0x258`), the Approval topic at
byte 778, and the return-true sequence at byte 833. Conversion of the topic
hexadecimal to decimal exited 0 and produced exactly
`63486140976153616755203102783360879283472101686154884697241723088393386309925`,
the value constrained in `spec.k`.

## Gate A — real-program soundness: PASS

- A1 and program pinning: every entry claim executes `#execute` over the exact
  supplied 2,091-byte runtime at PC 0, with the exact canonical ABI calldata.
  The helper equation is exhaustive byte identity, and the actual bytecode body
  is interpreted by fixed opcode semantics. The result/status/state are
  constrained rather than left as a free result.
- A2 and A3: there is no proof-local operational bridge. No candidate rule
  skips lookup, argument evaluation, SSTORE, LOG3, return, revert, static-mode
  handling, control, or an observable cell. Thus there is no bridge context or
  abrupt-control footprint to justify.
- A4: the sole candidate equation is a true singleton constant definition,
  terminating, covered on every use, and non-overlapping. There is no candidate
  oracle, opaque result, circular summary, totalization, priority interaction,
  or assumed auxiliary theorem.
- A5: the input domain is satisfiable; the independent false-output mutation
  was accepted, executed the actual program, exited nonzero with `notProved`,
  and exposed actual word 1 versus demanded word 0 under path condition `#Top`.

No Gate A finding exists.

## Residual Gate B — intent adequacy: PASS

- B1: the claims retain the approved symbolic domain: every 160-bit contract,
  caller, and spender; every uint256 value; arbitrary initial contract storage
  and logs. Canonical calls are partitioned by call value and static mode:
  zero/non-static success, every nonzero call value revert with either static
  flag, and zero/static exceptional failure. Proving added no restriction,
  assumption, bounded unrolling, or dropped claim.
- B2: the pinned semantics represents the relevant EVM bytes, status codes,
  storage maps, logs, ABI data, and static-mode behavior. `BYZANTIUM` and
  disabled gas accounting are explicit scope choices; no unsupported model-
  boundary claim is used.
- B3: there is no abstract human-facing result summary. The theorem directly
  constrains the ABI word, status, exact nested storage update, and exact log.
- B4: this matches the implementation: the Solidity body assigns
  `allowed[msg.sender][spender] = value`, emits `Approval`, and returns true.
  Its body has no Boolean-false branch; the two unsuccessful behaviors are the
  implemented dispatcher nonpayable revert and EVM static write violation.

The proven theorem is not narrower than the approved baseline or original task.

## Gate C — trust and evidence auditability: PASS

### Trust ledger

| Named assumption | Scope and effect | Dependents | Evidence |
|---|---|---|---|
| Immutable bundled `evm` semantics and bundled `EDSL`/`EVM-OPTIMIZATIONS`/`LEMMAS` are a sound model/theory for BYZANTIUM execution | Can affect value, control, state, termination, and simplification | All three claims and the mutation | Server pin `4f4c3843076c`, fetched immutable sources, K `7.1.337`; no bundled source was copied or edited |
| K backend, Kore RPC, and SMT implementation are sound | Can affect all formal conclusions | All proof tasks | Independent validation and four typed proof tasks with retained stdout/stderr |
| The supplied runtime is the program whose implemented behavior is requested | Determines source-to-bytecode provenance; the proof itself is directly about the supplied bytes | Source-level reading of all claims | Exact 2,091-byte equality, common SHA-256, selector/body/topic/return pattern checks; compilation provenance is not itself formally proved |

There is no `--trusted` claim and no unproved candidate-local primitive,
bridge, equation, or summary. The result is conditional on the named semantics
and prover trust boundary, as all machine-checked K results necessarily are.

### Reproducible evidence

- Formal evidence: clean-room validation 002 and proof tasks 001–003, with
  exact commands, task IDs, typed outcomes, exit codes, and downloaded logs
  above.
- Non-vacuity evidence: clean-room validation 003 and proof 004, exact mutation,
  satisfiable witness, exit 1, `notProved`, and the actual output mismatch.
- Program-identity check: exact full-byte comparison, not a sample. Its oracle
  reads `/app/contract.bin` directly and compares it to bytes independently
  decoded from the K string. Scope is all 2,091 bytes; mismatch count is zero.
- Pattern checks are finite explanatory evidence for source/ABI alignment, not
  a replacement for the symbolic proof.

### Honest result language

The formal result is execution under the pinned K theory. Source correspondence
and the supplied-bytecode identity check are separately identified, the trust
boundary is explicit, and excluded behavior is not presented as proved.

No Gate C finding exists.

VERDICT: PASS
REASON: All three symbolic claims close independently under the pinned EVM semantics, the candidate adds no unsound execution shortcut, the fresh false-output mutation is rejected with the expected unmet condition, and Gates A, B, and C pass for status VALIDATED.
