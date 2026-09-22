# Proof audit 1

## Artifacts examined

- Construction session identity only: `547121a7-36d3-4228-9b32-a494d0d3ed15`.
- `/app/output/spec.k` (SHA-256
  `a15559b47f1cd89a85883643c4de90266f2a58c883059ddf18c026568ad4c40b`).
- `/app/output/verification.k` (SHA-256
  `9b1277b71ad8a1f946e0398a67a42d4c5b54c936ae72b7ba6ecf8478ca0e8507`).
- `/app/output/SCOPE.md` (SHA-256
  `60e3116ec25072bac642d4627d22f57461fdf26042a29f37caf0725cdb88917d`).
- `/app/output/prove.sh` (SHA-256
  `9f27d9ecc3f5bbac8c8d3505b7a60b0778859d57c9158ed1e35eba9558a94ec0`).
- `/app/contract.sol` (SHA-256
  `cee59f7cb8d3245e61fab5bb037753500cf71e19be40184acb1a8306dc05106b`).
- `/app/contract.bin` (SHA-256
  `71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`).
- `/app/output/audits/spec-audit-1.md` (SHA-256
  `37cbe43702ed28b194004d6c8b5afca61546c0ca745ca9912251ac775e1491e4`).
- Fetched immutable EVM sources at
  `/home/node/.config/kprover/semantics/nlp-research-rosu/semantics-evm/4f4c3843076c`.

No constructor report, constructor proof task, or constructor evidence directory
was read or used. The candidate files were not changed.

## Clean-room reconstruction

The audit created session `a63d16c5-19ca-445e-bc0c-5bf8e3db43fa`. Both the
construction and audit sessions report exactly:

```text
id: evm
repo: https://github.com/nlp-research-rosu/semantics-evm
commit: 4f4c3843076c
projectRoot: /app
```

The audit session began with zero counters and its `inputs/` initially contained
only `spec.k` and `verification.k`. Their hashes equal the candidate hashes
above. The independently authored mutation was added later as the proof source
`inputs/spec-false.k`.

### Positive validation

Command:

```sh
kprover validate --project /app --session a63d16c5-19ca-445e-bc0c-5bf8e3db43fa --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION
```

Exit status: `0`.

Typed result:

```text
task.id: c564b1ff-5c6f-47c3-9c1d-b6e3738b54ba
task.status: completed
task.kind: proofDryRun
task.result.valid: true
task.result.definitionId: 7_1_337-haskell-evm-4f4c3843076c-8de2aa8e95f822c67b82152ab4108caea672b57b3d82ef2b3fe48239db915512
task.toolRuns[0].tool: kprove
task.toolRuns[0].exitCode: 0
```

Downloaded stdout:

```text
kore-exec /data/definitions/7_1_337-haskell-evm-4f4c3843076c-8de2aa8e95f822c67b82152ab4108caea672b57b3d82ef2b3fe48239db915512/definition/definition.kore --module VERIFICATION --prove /tmp/.kprove-2026-09-15-08-27-02-433-f2439828-1228-4b33-8dac-ff6a439093c9/spec.kore --spec-module SPEC --output /tmp/.kprove-2026-09-15-08-27-02-433-f2439828-1228-4b33-8dac-ff6a439093c9/result.kore
```

Downloaded stderr contains only compiler warnings: one unused `B2` in the
bundled `bytes-simplification.k`, the intentionally existential final variables
`?WS`, `?MEM`, `?PC`, and `?MU`, and unused `STORAGE` on the revert claim. The
complete unmodified stdout and stderr are retained in
`/app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa/validation-001/result.json`
(SHA-256 `d73acc57e7f0eb32f12c2ca5b3cea2338a909eb966840934d171f376769fb38e`).

### Positive unfiltered proof

Command:

```sh
kprover prove --project /app --session a63d16c5-19ca-445e-bc0c-5bf8e3db43fa --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION
```

There was no `--claim`, `--exclude-claim`, `--trusted`, or `--depth` option.
Exit status: `0`.

Typed result:

```text
task.id: a8b099af-6942-46bf-9874-5899788d14ed
task.status: completed
task.kind: proof
task.result.outcome: proved
task.result.residual: null
task.result.definitionId: 7_1_337-haskell-evm-4f4c3843076c-8de2aa8e95f822c67b82152ab4108caea672b57b3d82ef2b3fe48239db915512
task.toolRuns[0].tool: kprove
task.toolRuns[0].outcome: success
task.toolRuns[0].exitCode: 0
```

The client contract defines `outcome: proved` as closure with a `#Top` KAST.
The KEVM frontend renders that terminal result in downloaded stdout as:

```text
PROOF PASSED: SPEC.allowance-nonpayable-failure
PROOF PASSED: SPEC.allowance-success
```

Downloaded stderr, verbatim:

```text
WARNING 2026-09-15 08:29:36,922 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
```

Evidence:
`/app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa/proof-001/result.json`
(SHA-256 `614530a57de364048b334ae75d28affef0397e48559c8da48f5b59401e3882b7`).

## Rebuilt proof-extension inventory

Candidate declarations were exhaustively searched in `spec.k` and
`verification.k`. The only candidate declarations are the two target claims.

| Extension | Class | Semantic role | Domain/context/state/value influence | Justification and dependents | Validation |
|---|---|---|---|---|---|
| `VERIFICATION-SUMMARIES` | No extension; empty module | Imports the pinned `EDSL` only | Adds no symbol, rule, equation, totality attribute, rewrite, claim, opaque term, priority, or cell framing | None | Byte-for-byte inspected; unchanged from the approved spec baseline |
| `VERIFICATION` | No extension; import aggregator | Imports the empty module above and pinned `LEMMAS` | Adds no candidate behavior | None | Byte-for-byte inspected |
| `allowance-success` | Target claim, not a proof extension | Executes fixed EVM semantics | Full target configuration described below | No other claim depends on it; it was not trusted | Clean unfiltered proof passed |
| `allowance-nonpayable-failure` | Target claim, not a proof extension | Executes fixed EVM semantics | Full target configuration described below | No other claim depends on it; it was not trusted | Clean unfiltered proof passed |

`EDSL` and `LEMMAS` are immutable sources supplied by the selected semantics,
not proof-local candidate helpers. The candidate-specific helper list is empty.
In particular, the proof does not import `EDSL-SUMMARY`, `KEVM-SUMMARIES`, or
any candidate operational summary. `#lookup` is a pinned total definition with
the `some`, `none`, and `notInt` cases at `evm-types.md:418-424`;
`#hashedLocation` is defined by guarded recursive equations at
`hashed-locations.md:57-64`; `#abiCallData` is defined at `abi.md:141-147`.
There is no candidate equation whose coverage, overlap, descent, or guard must
be admitted, and no candidate operational bridge requiring a connection
theorem or operational-sensitivity witness.

## Gate A — real-program soundness: PASS

### A1: program identity and body sensitivity

Both claims start with `<k> #execute => #halt </k>`, `<pc> 0 => ?PC </pc>`, an
empty word stack and memory, and `<program> PGM </program>`. Their precondition
constrains `PGM` to `#parseByteStack` of one exact 2,091-byte literal. There are
two occurrences and one unique literal. This command exited `0`:

```sh
test "$(rg -o '0x[0-9a-f]+' /app/output/spec.k | sort -u | wc -l)" -eq 1 && test "$(rg -o '0x[0-9a-f]+' /app/output/spec.k | head -1 | cut -c3-)" = "$(od -An -v -tx1 /app/contract.bin | tr -d ' \n')"
```

Actual measurements:

```text
spec-bytecode-literals=2
unique-literals=1
literal-bytes=2091
contract-bin-bytes=2091
```

Thus the term actually executed is the supplied runtime, not a source file or
an unconstrained program. Fixed semantics fetches opcodes from `PGM` at `PC`
under `#execute` (`evm.md:332-361`). No program-defined operation is replaced.
The two claims cover disjoint call-value branches and both were replayed.

### A2: operational state preservation

There is no operational bridge. Fixed EVM instructions perform the dispatcher,
ABI decoding, hashing, `SLOAD`, return, and nonpayable revert. The claim observes
and preserves the executing account's entire `STORAGE` map. Success constrains
the exact 32-byte output and `EVMC_SUCCESS`; failure constrains empty output and
`EVMC_REVERT`. Final stack, memory, PC, and memory high-water mark are explicit
existentials. Omitted cells are framed by the reachability pattern. Therefore no
candidate extension skips or abstracts a state footprint.

### A3: binding, evaluation, and control fidelity

There is no bridge that can preempt lookup, evaluation, return, revert, frame
popping, exception propagation, or a continuation. Binding is fixed by the
literal runtime, dispatcher entry PC 0, canonical allowance calldata, and the
executing account. The success and failure postconditions constrain both result
and status at `#halt`. Operational-bridge and result-bearing-abstraction
procedures are not applicable because there is no candidate bridge and no fresh,
opaque, or newly summarized value.

The pinned `keccak` operation is an EVM primitive, not program-derived candidate
opacity. The theorem is relative to the pinned semantics' interpretation; its
human EVM meaning is listed in the trust ledger.

### A4: logical consistency and rule validity

The candidate adds no functions, totality declarations, equations,
simplifications, concrete/owise/priority rules, ordinary rewrites, or auxiliary
claims. Therefore candidate guard coverage, overlap, descent, and totalization
checks are vacuous. The approved empty `VERIFICATION-SUMMARIES` module was not
edited.

### A5: satisfiable witness and fresh false-postcondition mutation

A satisfiable ground witness is `ACCT = OWNER = SPENDER = 0`, `STORAGE = .Map`,
zero call value, and `PGM` equal to the parsed runtime literal. All address
ranges hold, and pinned `#lookup.none` makes the requested storage word `0`.

The audit copied the target spec to the clean audit session and made exactly
these changes (mutation SHA-256
`b5696ba0443b0a9d8976d8ecb8ab863b23df67346e84628e9eeb56771b0648ee`):

```diff
-module SPEC
+module SPEC-FALSE-AUDIT
-  claim [allowance-success]:
+  claim [allowance-success-false]:
-    <output> .Bytes => #buf(32, #lookup(STORAGE, #hashedLocation("Solidity", 2, OWNER SPENDER))) </output>
+    <output> .Bytes => #buf(32, #lookup(STORAGE, #hashedLocation("Solidity", 2, OWNER SPENDER)) +Int 1) </output>
```

For the witness, the real output is the 32-byte encoding of `0`; the mutation
demands the 32-byte encoding of `1`.

Mutation validation command:

```sh
kprover validate --project /app --session a63d16c5-19ca-445e-bc0c-5bf8e3db43fa --semantics evm --spec inputs/spec-false.k --spec-module SPEC-FALSE-AUDIT --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC-FALSE-AUDIT.allowance-success-false
```

Exit status `0`; task `11fd159d-7c47-48a4-bedc-ec48692fd067`; status
`completed`; `task.result.valid: true`; tool exit `0`. Complete stdout/stderr:
`/app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa/validation-002/result.json`
(SHA-256 `fd3368052a87975fdff570085576cdf0c1c47963abd856a584a95e6bcfc0aad8`).

Mutation proof command:

```sh
kprover prove --project /app --session a63d16c5-19ca-445e-bc0c-5bf8e3db43fa --semantics evm --spec inputs/spec-false.k --spec-module SPEC-FALSE-AUDIT --verification inputs/verification.k --verification-module VERIFICATION --claim SPEC-FALSE-AUDIT.allowance-success-false
```

Exit status: `1`.

Typed result:

```text
task.id: 8020df9e-02d4-4514-9aaf-269d2fe8965e
task.status: completed
task.kind: proof
task.result.outcome: notProved
task.result.residual: null
task.toolRuns[0].tool: kprove
task.toolRuns[0].outcome: exit_error
task.toolRuns[0].exitCode: 1
```

Although the structured `residual` field is null, the downloaded frontend
stdout contains the retained failing node and its unmet condition, verbatim in
material part:

```text
PROOF FAILED: SPEC-FALSE-AUDIT.allowance-success-false
1 Failure nodes. (0 pending and 1 failing)

Failing nodes:

  Node id: 3
  Failure reason:
    Matching failed.
    The following cells failed matching individually (antecedent #Implies consequent):
    OUTPUT_CELL: #buf ( 32 , #lookup ( STORAGE:Map , keccak ( #buf ( 32 , SPENDER:Int ) +Bytes #buf ( 32 , keccak ( #buf ( 32 , OWNER:Int ) +Bytes b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02" ) ) ) ) #Implies #lookup ( STORAGE:Map , keccak ( #buf ( 32 , SPENDER:Int ) +Bytes #buf ( 32 , keccak ( #buf ( 32 , OWNER:Int ) +Bytes b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02" ) ) ) ) +Int 1 )
  Path condition:
    #Top
```

Downloaded stderr, verbatim:

```text
WARNING 2026-09-15 08:35:25,978 kevm_pyk.__main__ - Ignoring --equation-max-local-steps for non-booster server: kore-rpc
WARNING 2026-09-15 08:36:45,747 pyk.proof.proof - Terminating proof early because fail_fast is set: SPEC-FALSE-AUDIT.allowance-success-false
```

Complete evidence:
`/app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa/proof-002/result.json`
(SHA-256 `5016909fbee87a651b1d34a6fa0f41541dd801797947805e4526d4c7f2734338`).
This is a meaningful rejection, not a parser error, timeout, or unreachable
claim.

## Residual Gate B — intent adequacy: PASS

- **B1 input domain:** The clean proof contains the same two claims approved by
  `spec-audit-1.md`, without filtering. Owner, spender, and account cover the
  complete 160-bit address ranges; storage is symbolic; canonical calls are
  split over call value `0` and every nonzero 256-bit value. No `requires` was
  strengthened and no claim was dropped during proving.
- **B2 language model:** The theorem explicitly selects `BYZANTIUM` and disables
  gas. These model choices and the exclusion of malformed dispatcher inputs,
  mid-runtime entry, and resource exhaustion are explicit in `SCOPE.md`. The
  audit session and construction session use the same immutable EVM revision.
- **B3 summary/property:** There is no candidate summary. Success relates the
  returned word directly to pinned `#lookup(STORAGE,
  #hashedLocation("Solidity", 2, OWNER SPENDER))`; failure directly observes
  revert. Proving added no equation capable of shifting this meaning.
- **B4 implementation/intent:** `contract.sol:203-205` contains `return
  allowed[owner][spender]`. Both spec literals equal all 2,091 bytes of
  `contract.bin`, and selector `dd62ed3e` occurs in that runtime. The theorem is
  deliberately about the supplied runtime rather than a broader ERC-20
  interface.

There is no bounded unrolling, fixed-size restriction, trusted auxiliary claim,
or construction-time narrowing. Gate B therefore remains PASS after proving.

## Gate C — trust and evidence auditability: PASS

### Trust ledger

| Named boundary or assumption | Effect | Dependents | Evidence/status |
|---|---|---|---|
| Pinned `evm` semantics and K backend faithfully model the stated EVM execution | Value, control, state, status, and termination | Both claims | Explicit foundational trust boundary; server health `ok`, K `7.1.337`, immutable repo/commit matched across sessions |
| Pinned `keccak`/`Keccak256` primitive denotes EVM Keccak-256 | Selector construction and symbolic nested storage location | Both claims for canonical selector; success for storage location | Fixed external primitive, outside the bytecode-defined theorem; the proof is relative to the pinned interpretation and uses the same fixed operation in EVM `SHA3` and `#hashedLocation` |
| Solidity 0.4 storage/ABI reading associates `allowed` with nested mapping base slot 2 | Human interpretation of the formal storage location | Success claim's source-level reading | Source declaration order, pinned guarded `#hashedLocation("Solidity",...)` equations, runtime selector check; not claimed as a separately proved compiler-correctness theorem |
| Supplied `contract.bin` is the authoritative runtime to verify | Program identity | Both claims | Exact 2,091-byte equality against both spec literals, SHA-256 recorded |
| `contract.sol` describes the source intent of the supplied runtime | Source-level adequacy only | Human reading of both claims | Source lines 203-205 and selector presence provide mechanical support; no reproducible compiler build was supplied or claimed |

No candidate proof rule, trusted claim, opaque program-derived value, or
operational bridge is in the trust boundary.

### Reproducible evidence

The exact live commands, task IDs, exit codes, typed results, logs, evidence
paths, and hashes are recorded above. Additional mechanical checks and actual
outputs:

```sh
rg -n 'function allowance|return allowed\[owner\]\[spender\]' /app/contract.sol
```

Exit `0`:

```text
55:    function allowance(address owner, address spender) constant returns (uint256 remaining);
203:    function allowance(address owner, address spender) constant returns (uint256 remaining) {
204:      return allowed[owner][spender];
```

```sh
od -An -v -tx1 /app/contract.bin | tr -d ' \n' | rg -o 'dd62ed3e'
```

Exit `0`, output:

```text
dd62ed3e
```

```sh
test -f /app/output/spec.k -a -f /app/output/verification.k -a -f /app/output/SCOPE.md -a -x /app/output/prove.sh -a -f /app/contract.sol -a -f /app/contract.bin -a -f /app/output/audits/spec-audit-1.md -a -f /app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa/validation-001/result.json -a -f /app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa/proof-001/result.json -a -f /app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa/validation-002/result.json -a -f /app/.kprover/sessions/a63d16c5-19ca-445e-bc0c-5bf8e3db43fa/proof-002/result.json && sh -n /app/output/prove.sh && ! rg -n -- '--depth|--claim|--exclude-claim|--trusted' /app/output/prove.sh
```

Exit `0`. `prove.sh` is syntactically valid, calls the global client, pins the
construction session and `evm`, and contains no depth bound, filter, exclusion,
or trusted claim. It was not executed in the audit because clean-room policy
forbids reusing the construction session.

Fetched `abi.md`, `edsl.md`, `evm.md`, and `driver.md` match the supplied
`/app/semantics` copies byte-for-byte (all four `cmp` exits were `0`). No
differential or concrete behavioral test is claimed. The identity checks above
are finite mechanical evidence, not a universal language-semantics proof.

### Honest result language

The formal theorem is the two K reachability claims over the exact runtime and
pinned semantics. The source-level labels are conditional on the trust ledger.
The mechanical identity checks are evidence rather than proofs of compiler
correctness. Excluded behavior remains exactly what `SCOPE.md` states.

## Command and instrument notes

The commands used to decide the audit are reproduced above. Discovery commands
`which kprover`, `kprover --help`, `kprover config`, `kprover health`,
`kprover semantics`, all relevant `--help` calls, `kprover semantics fetch evm`,
both `kprover session show` calls, file/hash/`rg`/`cmp`/`sed` inspections, and
`sh -n` exited `0`. `kprover health` returned `{"kVersion":"7.1.337",
"status":"ok"}`. `kprover semantics fetch evm` returned status `ready` with
the source directory named above.

Two convenience inspection attempts were non-substantive: `jq` exited `127`
because it is not installed, after which the unmodified JSON was read with
`sed`; attempting to read the fetch response's nominal `semantics.k` entry file
exited `2` because that path is absent from the downloaded archive, after which
the returned source directory and its actual files were inspected. Neither
affected the client, task evidence, semantics pin, or gate decisions.

## Findings and status

- Gate A: PASS.
- Gate B: PASS.
- Gate C: PASS.
- Final proof status: `VALIDATED`.

No finding requires repair or routing to an earlier stage.

VERDICT: PASS
REASON: Gates A, B, and C pass; the clean-room replay and discriminating mutation establish status VALIDATED.
