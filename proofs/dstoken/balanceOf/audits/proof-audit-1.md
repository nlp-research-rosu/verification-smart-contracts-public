# Proof audit 1

## Artifacts examined

- Original task: verify `DSToken.balanceOf(address)` with symbolic inputs and storage, covering successful and unsuccessful calls, under immutable semantics ID `evm` and a 30-minute remote cap.
- Construction session pin (identity only): `73d69834-e371-4ec8-b44b-23b8cd12edd6`, `evm`, repository `https://github.com/nlp-research-rosu/semantics-evm`, commit `4f4c3843076c`.
- Candidate sources: `/app/output/spec.k`, `/app/output/verification.k`, `/app/output/runtime.k`, `/app/output/SCOPE.md`, and `/app/output/prove.sh`.
- Program artifacts: `/app/contract.sol` and `/app/contract.bin`.
- Approved baseline: `/app/output/audits/spec-audit-1.md`.
- Clean-room session: `12f2b534-7086-4f21-b291-d4473cbf1844`, independently pinned to the same `evm` repository and commit.
- Retained replay and mutation evidence: `/app/output/evidence/audit/session-12f2b534-7086-4f21-b291-d4473cbf1844/`.

The construction report and construction proof evidence were not read or used.

Candidate hashes at audit start:

| Artifact | SHA-256 |
|---|---|
| `spec.k` | `a3babbda785eb658cfb237ed050fd67f13008fc06513a3bb8824f49832fd2f42` |
| `verification.k` | `499bc8d4edb4a83db2d3235b24079ab0322e2eed8d08abacd8985eab4d4e5a38` |
| `runtime.k` | `6bbccce7f72fbaffe3cdb150dd030519fe3a653518bc1d11d9d312adf4f4bbd1` |
| `SCOPE.md` | `e26db86c895177255ce9aa873441b592c7648781ff05d3758c645b2e07204bdc` |
| `prove.sh` | `4c1bc9cb095d9bbe21c60ed0bbee71321ad5158489597bec0fd63983078bad72` |
| `contract.sol` | `f4bcfc92c70fc8196e8802abb9dbff0ebbc05cb6f18a1e6621ad63362d90cf0e` |
| `contract.bin` | `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82` |

## Commands and outcomes

### Environment and pin

1. `kprover config` exited 0. The effective cap was `task_timeout_seconds = 1800`, with 20 proof attempts, 50 validations, and 3 runs.
2. `kprover health` exited 0 with `{"kVersion":"7.1.337","status":"ok"}`.
3. `kprover semantics` exited 0 and listed `evm` at commit `4f4c3843076c`.
4. `kprover session show 73d69834-e371-4ec8-b44b-23b8cd12edd6` exited 0 and confirmed the construction pin above.
5. `kprover session start --project /app --semantics evm` exited 0, creating audit session `12f2b534-7086-4f21-b291-d4473cbf1844` at the same pin.
6. `kprover semantics fetch --project /app evm` exited 0 and made the pinned sources available read-only for static inspection. They were not copied into `/app/output`.

Only `spec.k`, `verification.k`, and `runtime.k` were copied into the clean-room session's initial `inputs/`; their hashes equal the candidate hashes above.

### Clean-room validation and positive proofs

The validation command was:

```sh
kprover validate --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k
```

- `validation-001`, task `86ca29fa-9ba9-42ba-a9ac-f897ce88a87b`, exited 0, status `completed`, `result.valid: true`.
- The same command was inadvertently submitted a second time while the first client poll was pending. `validation-002`, task `b0a70582-935b-4059-8943-66dd7b953b0d`, also exited 0 with `result.valid: true`. Both accepted submissions are retained.

The successful-call proof command was:

```sh
kprover prove --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC.balanceOf-success
```

`proof-001`, task `3507a1aa-ff2f-4592-8a22-11924d8337aa`, exited 0, status `completed`, outcome `proved`, residual `null`; retained stdout is `PROOF PASSED: SPEC.balanceOf-success`.

The nonzero-value proof command was:

```sh
kprover prove --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC.balanceOf-nonzero-value-reverts
```

`proof-002`, task `8993885f-4be8-46fe-8593-fc47640a4f20`, exited 0, status `completed`, outcome `proved`, residual `null`; retained stdout is `PROOF PASSED: SPEC.balanceOf-nonzero-value-reverts`.

The current KEVM frontend reports a closed claim as `PROOF PASSED` rather than printing a literal `#Top` term in stdout. In both tasks, the Prover's typed outcome is `proved`, K exited 0, and the typed residual is null. The retained result JSON is the raw client evidence used here.

### Fresh non-vacuity and sensitivity mutations

All mutation files are auditor-authored distinct specs retained under the audit evidence directory. Each was validated before proving against the unchanged candidate verification definition.

1. Successful result off-by-one: `spec-false-output.k` changes the expected success output from `#buf(32, #lookup(...))` to `#buf(32, #lookup(...) +Int 1)`. A witness is `WHO = 0`, any valid distinct `ACCT` and `CALLER_ID`, empty `STORAGE`, and call value 0; the reported path condition is the stronger fact `#Top`.
   - Validation command:

     ```sh
     kprover validate --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-false-output.k --spec-module SPEC-FALSE-OUTPUT --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-FALSE-OUTPUT.balanceOf-success-false
     ```

   - `validation-004`, task `b6bdfd45-5883-49d4-9628-6d5fed6b203b`, exited 0 with `result.valid: true`.
   - Proof command:

     ```sh
     kprover prove --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-false-output.k --spec-module SPEC-FALSE-OUTPUT --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-FALSE-OUTPUT.balanceOf-success-false
     ```

   - `proof-003`, task `055355b8-a66e-4798-b4d2-56337ceca5b5`, exited 1 with outcome `notProved`. Its failure node has path condition `#Top` and the explicit mismatch `#lookup(...) #Implies #lookup(...) +Int 1` in `OUTPUT_CELL`.

2. Program-body sensitivity: `spec-body-stop.k` changes the actual `<program>` term executed by the success claim, and its jump destinations, from `DSTOKEN_RUNTIME` to `#parseByteStack("0x00")`. The rest of the intended success postcondition is unchanged.
   - Validation command:

     ```sh
     kprover validate --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-body-stop.k --spec-module SPEC-BODY-STOP --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-BODY-STOP.balanceOf-success-body-stop
     ```

   - `validation-005`, task `4c5d340e-bd24-4610-83a8-a4a798b3b126`, exited 0 with `result.valid: true`.
   - Proof command:

     ```sh
     kprover prove --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-body-stop.k --spec-module SPEC-BODY-STOP --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-BODY-STOP.balanceOf-success-body-stop
     ```

   - `proof-004`, task `e036e8e2-2bd8-40b4-bebb-dcf35dd29e66`, exited 1 with outcome `notProved`. Its failure node has path condition `#Top` and the explicit mismatch `b"" #Implies #buf(32, #lookup(...))` in `OUTPUT_CELL`.

3. Revert-status sensitivity: `spec-false-revert-status.k` changes the nonzero-value claim's expected status from `EVMC_REVERT` to `EVMC_SUCCESS`. A witness is `WHO = 0`, any valid `ACCT` and `CALLER_ID`, empty `STORAGE`, and `CALL_VALUE = 1`; again, the reported path condition is `#Top`.
   - Validation command:

     ```sh
     kprover validate --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-false-revert-status.k --spec-module SPEC-FALSE-REVERT-STATUS --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-FALSE-REVERT-STATUS.balanceOf-nonzero-value-reverts-false
     ```

   - `validation-006`, task `7f88afdf-028c-49b4-be0b-c02d26afd592`, exited 0 with `result.valid: true`.
   - Proof command:

     ```sh
     kprover prove --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-false-revert-status.k --spec-module SPEC-FALSE-REVERT-STATUS --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k --claim SPEC-FALSE-REVERT-STATUS.balanceOf-nonzero-value-reverts-false
     ```

   - `proof-005`, task `5766d827-8689-42fc-a732-64d1d197a2d5`, exited 1 with outcome `notProved`. Its failure node has path condition `#Top` and the explicit mismatch `EVMC_REVERT #Implies EVMC_SUCCESS` in `STATUSCODE_CELL`.

### Static and artifact checks

- `runtime_hex=$(sed -n 's/.*#parseByteStack("0x\([0-9a-f]*\)").*/\1/p' /app/output/runtime.k); bin_hex=$(od -An -tx1 -v /app/contract.bin | tr -d ' \n'); test "$runtime_hex" = "$bin_hex"` exited 0. The macro contains 13,910 hex digits, exactly 6,955 bytes.
- `sha256sum /app/contract.bin` exited 0 with `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`.
- `rg` inspection of the candidate found only the two claims and the exact runtime macro rule; `VERIFICATION-SUMMARIES` contains no rules, equations, functions, totality declarations, priorities, auxiliary claims, or trusted claims.
- Read-only inspection of the pinned Solidity source and disassembled runtime path exited 0. The dispatcher compares selector `0x70a08231` and jumps to wrapper offset `0x038e`. The zero-value path ABI-decodes the address and jumps to body offset `0x0c6d`; that body masks the address, stores address and base slot `1` in memory, executes `SHA3`, `SLOAD`, and returns. The nonzero path executes `PUSH1 0; DUP1; REVERT` at offsets `0x0395` through `0x0398`.
- The source declares `_supply` followed by `_balances` and implements `balanceOf` as `return _balances[src]`; the runtime's explicit `PUSH1 0x01` independently fixes the mapping base slot.

### Supplementary bridge-removal experiment

An auditor-authored variant removed the optional `EDSL-SUMMARY`, `LEMMAS`, and `EVM-OPTIMIZATIONS` imports to try a direct base-EVM replay. Its exact command was:

```sh
kprover validate --project /app --session 12f2b534-7086-4f21-b291-d4473cbf1844 --semantics evm --spec inputs/spec-fixed.k --spec-module SPEC --verification inputs/verification-fixed.k --verification-module VERIFICATION-FIXED --source inputs/runtime-fixed.k
```

`validation-003`, task `77b8127a-ba4c-4176-8924-2c3a5b4950ba`, failed during definition compilation: Java was killed at the server's 8 GiB limit (exit 137; client exit 1). This optional experiment is retained as an instrument/resource failure and is not treated as evidence for or against the candidate proof. The required clean-room candidate proofs and mutations all ran successfully.

## Proof-extension inventory

### Candidate-specific extensions

| Extension | Class | Domain and role | State/control/value effect | Justification and dependents |
|---|---|---|---|---|
| `DSTOKEN_RUNTIME` macro | Definitional summary | A closed constant naming the submitted runtime bytes; it does not replace a program-defined operation. | Supplies the `<program>` term only. No fresh or opaque value, continuation change, or state rewrite. | Exact 6,955-byte equality with `/app/contract.bin`; both entry claims depend on it. The body mutation shows the claims execute this term. |
| `VERIFICATION-SUMMARIES` | None | The module imports `DSTOKEN-RUNTIME` and defines no symbols or rules. | None. | No candidate summary can preempt execution or alter the approved summary module's meaning. |
| `balanceOf-success` and `balanceOf-nonzero-value-reverts` | Target claims, not assumed lemmas | Symbolic entry reachability claims. Neither is marked trusted or used as a circularity for the other. | Constrain output/status and preserve the framed state as stated. | Each was selected and proved separately in the audit session. |

There are no candidate operational bridges, priority rules, ordinary execution rewrites, simplification rules, total functions, auxiliary claims, or opaque result symbols. Consequently the operational-bridge context and opposite-interpretation procedures have no candidate extension to apply to.

### Pinned bundled theory used by the candidate

`verification.k` imports the immutable bundle's `EDSL-SUMMARY` and `LEMMAS`; `runtime.k` imports bundled `EDSL`, which imports `EVM-OPTIMIZATIONS`. These are semantics-side modules at the selected, immutable `evm@4f4c3843076c` pin, not candidate-authored proof-local extensions. Static path reconstruction shows that the potentially applicable no-gas opcode summaries are:

`PUSH-SUMMARY-NOGAS`, `MSTORE-SUMMARY-NOGAS`, `CALLDATASIZE-SUMMARY-NOGAS`, `LT-SUMMARY-NOGAS`, `CALLDATALOAD-SUMMARY-NOGAS`, `SWAP-SUMMARY-NOGAS`, `DIV-SUMMARY-NOGAS`, `AND-SUMMARY-NOGAS`, `DUP-SUMMARY-NOGAS`, `EQ-SUMMARY-NOGAS`, `JUMPDEST-SUMMARY-NOGAS`, `ISZERO-SUMMARY-NOGAS`, `REVERT-SUMMARY-NOGAS`, `POP-SUMMARY-NOGAS`, `ADD-SUMMARY-NOGAS`, `MLOAD-SUMMARY-NOGAS`, `SHA3-SUMMARY-NOGAS`, `SLOAD-SUMMARY-NOGAS-BERLIN`, `SUB-SUMMARY-NOGAS`, and `RETURN-SUMMARY-NOGAS`.

These bundled rules are operational accelerators for one decoded opcode. Their complete matched control prefix is `#next [ OP ] ~> .K` with the existing continuation `_K_CELL` retained. The no-gas guards require `notBool USEGAS_CELL`, matching the claims' fixed `<useGas> false`. Arithmetic and stack rules update only stack, PC, and (vacuously here) gas; memory rules additionally update local memory/memory-used; `SLOAD` reads the active account ID and storage and pushes exactly `#lookup(STORAGE, key)` without writing storage; `RETURN` and `REVERT` consume the offset/width, set output and the appropriate status, and replace only the active `#next` by `#halt`, retaining the outer continuation. No rule introduces a fresh oracle or pops an unmentioned call frame. The fixed `JUMP`, `JUMPI`, and `CALLVALUE` semantics cover control decisions not represented by those summary modules.

The bundled `keccak` hook is the only result-bearing external primitive on the success path. Execution applies it to `pad32(WHO) ++ pad32(1)`, and the postcondition states the same value through the bundled definition of `#hashedLocation("Solidity", 1, WHO .IntList)`. The theorem is therefore conditional on the pinned semantics' Keccak/EVM primitive contract, rather than a proof of cryptographic implementation correctness. No candidate fresh symbol is shared circularly between execution and postcondition.

## Gate A — real-program soundness: PASS

- A1/program identity: the entry `<k>` is `#execute`, PC is 0, and `<program>` is the exact submitted 6,955-byte runtime. The macro equality check passes. The `0x70a08231` dispatcher, nonpayable guard, ABI decode, slot-1 mapping hash, `SLOAD`, and terminal return/revert are present in the executed bytecode. Replacing the actual program term by `STOP` makes the success theorem fail on a satisfiable `#Top` path.
- A2/state footprint: success reads storage and constrains the returned 32-byte word; nonzero value reverts before the body. The selected account storage is unchanged in both claims. No `SSTORE`, call, log, allocation, or exception-producing external operation occurs on either selected path. Status and output are explicitly constrained.
- A3/binding, evaluation, and control: selector and ABI input are generated by the pinned ABI definitions; the dispatcher selects the supplied runtime's `balanceOf` entry. The candidate adds no operational bridge. Static inspection of the applicable bundled one-opcode summaries found no dropped continuation or omitted observable write; in particular `RETURN` and `REVERT` retain the outer continuation and set the exact status/output cells.
- A4/logical consistency: the sole candidate equation is the closed runtime macro and is byte-for-byte true. `VERIFICATION-SUMMARIES` is empty. There are no candidate equation overlaps, uncovered total functions, recursion, priority conflicts, or opaque result values.
- A5/non-vacuity: concrete witnesses such as `WHO=0`, valid account/caller IDs, empty storage, and call values 0 or 1 satisfy the respective preconditions. Both result mutations are rejected with explicit `#Top`-path residual mismatches, and the program-body mutation is rejected as well.

No false-conclusion witness exists for a candidate proof extension because no candidate operational or result-bearing extension was introduced.

## Residual Gate B — intent adequacy: PASS

- Input domain: success quantifies over every 160-bit ABI address, arbitrary KEVM storage map, valid symbolic contract/caller addresses, and call value 0. The failure claim covers every nonzero 256-bit call value over the same canonical call domain. This is symbolic, not bounded.
- Property: success returns the modulo-256-bit storage value at Solidity mapping base slot 1, including default zero for an absent key, with success status. Nonzero value produces empty output and `EVMC_REVERT`. The selected storage is preserved.
- Source alignment: `DSTokenBase.balanceOf` is exactly `return _balances[src]`; source order and runtime instructions both identify base slot 1.
- No proving-time narrowing occurred relative to the approved spec: both approved claims were present and separately replayed, with unchanged `requires` clauses and unchanged `VERIFICATION-SUMMARIES`.
- Explicit model/exclusions: the theorem is a direct, canonical ABI call in unmetered Byzantine EVM semantics. It excludes malformed or trailing calldata, unknown selectors, constructor behavior, other functions, transaction-envelope checks, and out-of-gas behavior. These exclusions are outside the source-level canonical `balanceOf(address)` call contract, not finite proof bounds. The result is reported as partial correctness under that model.

## Gate C — trust and evidence auditability: PASS

### Trust ledger

| Assumption/boundary | Effect | Dependents | Evidence/status |
|---|---|---|---|
| Immutable `evm@4f4c3843076c` faithfully models the relevant Byzantine EVM opcodes, ABI helpers, storage maps, and optional bundled accelerator/lemma modules. | Value, control, memory, storage reads, and termination behavior. | Both claims. | Explicit semantics pin; independent replay at the same pin; source inspection of relevant fixed and summary rules. This audit does not re-freeze or re-prove the bundled semantics. |
| Bundled Keccak hook implements the EVM hash primitive. | Selects the mapping storage key. | Success claim. | Explicit external primitive boundary. The theorem is stated using the same pinned primitive and does not claim cryptographic implementation verification. |
| `/app/contract.bin` is the target deployed runtime artifact. | Determines the program proved. | Both claims. | Runtime macro exact-byte equality and SHA-256 pin. Source-to-binary recompilation is not claimed. |
| Solidity source layout identifies `_balances` as slot 1. | Connects the bytecode storage key to the human-facing field name. | Human-facing interpretation of success. | Source declaration order and independent runtime `PUSH1 0x01` witness. |
| Unmetered Byzantine direct-call model is the requested functional model. | Excludes out-of-gas and transaction-envelope behavior. | Both claims. | Explicit in both claims and `SCOPE.md`; no claim of other schedules or metered execution. |

### Reproducible evidence and result language

- Every accepted audit-session task is accounted for: six validations and five proofs. Commands, task IDs, typed outcomes, exit statuses, and retained result JSON are listed above.
- The exact-byte comparison, runtime hash, and disassembly checks are reproducible from retained candidate/program artifacts.
- Three fresh mutations are retained with their exact spec files and complete backend results. They are machine-checked sensitivity evidence, not universal semantics validation.
- No differential test is claimed and no candidate abstraction relies on finite testing.
- Formally proved facts, conclusions conditional on the pinned semantics and external Keccak primitive, artifact checks, and excluded behavior are separated above.

## Final status

All three gates pass. The result is `VALIDATED` for the exact submitted runtime, the symbolic canonical-call domain, and the pinned unmetered Byzantine EVM model.

VERDICT: PASS
REASON: Gates A, B, and C pass, so the independently replayed proof has final status VALIDATED within the stated pinned EVM model and scope.
