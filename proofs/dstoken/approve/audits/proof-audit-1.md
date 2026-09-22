# Proof audit 1

## Artifacts examined

- Construction session identifier `504ef65f-e09d-448d-ad55-5e374d7ecf1c` (used only to compare the immutable semantics pin; no constructor report was read).
- `/app/output/spec.k`, SHA-256 `cec842a3784b13f4197954c76c532167e08a84a315b4443a8d3932d917bc8a56`.
- `/app/output/verification.k`, SHA-256 `57d5ca8ddf75522b95471eb92357881241b1196c74cb3f2a3f688c8c0a7789b6`.
- `/app/output/bytecode.k`, SHA-256 `4ebbab4e293bf103408ec69b4bfacd3331ea0aaf7e3451858050de9db40b2821`.
- `/app/output/SCOPE.md`, SHA-256 `d1f5b2f1e7175e9c4ad0cc4563fce71368a3bef08c87282e87a71c4c52701c4d`.
- `/app/output/prove.sh`, SHA-256 `4d326780347401b3b75d9040bddcf8ae24b797142c8cff887637f914f994765d`.
- `/app/contract.bin`, SHA-256 `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`.
- `/app/contract.sol`, SHA-256 `f4bcfc92c70fc8196e8802abb9dbff0ebbc05cb6f18a1e6621ad63362d90cf0e`.
- `/app/output/audits/spec-audit-2.md`, SHA-256 `caa6b64a2c61bd84071a8c6005562eaf76a9f61f8d902bc1e42e517fad4d898f`, as the approved-spec baseline.
- The immutable bundled `evm` sources fetched for inspection at commit `4f4c3843076c`; they were not copied into the output or submitted as proof sources.
- Audit-created sources and retained results under `/app/output/audits/proof-audit-1-evidence/`.

No constructor report was read. The candidate files were not edited.

## Clean-room reconstruction

The independent audit session is `6c5683d6-10ee-4844-b98a-d8fbcc8c2caf`. Both it and the construction session report repository `https://github.com/nlp-research-rosu/semantics-evm`, semantics ID `evm`, and commit `4f4c3843076c`. Only `spec.k`, `verification.k`, and `bytecode.k` were copied into the audit session's `inputs/` for the positive replay; their hashes equal the candidate hashes above.

### Commands and actual results

| Command | Exit | Actual result |
|---|---:|---|
| `kprover health` | 0 | `{"kVersion":"7.1.337","status":"ok"}` before the required submissions. |
| `kprover semantics` | 0 | Registry entry `evm`, repository `semantics-evm`, commit `4f4c3843076c`. |
| `kprover session show 504ef65f-e09d-448d-ad55-5e374d7ecf1c` | 0 | Construction pin: `evm` at `4f4c3843076c`. |
| `kprover session start --project /app --semantics evm` | 0 | Fresh session `6c5683d6-10ee-4844-b98a-d8fbcc8c2caf`, pin `4f4c3843076c`. |
| `kprover session show --project /app 6c5683d6-10ee-4844-b98a-d8fbcc8c2caf` | 0 | Confirmed the fresh project, repository, ID, revision, workspace, and zero initial counters. |
| `sha256sum` over candidate and clean-room copies | 0 | All three copied proof sources matched byte-for-byte. |
| `kprover validate --project /app --session 6c5683d6-10ee-4844-b98a-d8fbcc8c2caf --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/bytecode.k` | 0 | Task `7dd58f0c-c5d4-49f6-95d7-0323fa443d34`, `status: completed`, `valid: true`, K exit `0`. |
| `kprover prove --project /app --session 6c5683d6-10ee-4844-b98a-d8fbcc8c2caf --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/bytecode.k` | 0 | Task `48fd473b-2887-48bc-8b45-40fbce4a3410`, `status: completed`, `outcome: proved`, null residual, K exit `0`. Raw EVM-frontend stdout: `PROOF PASSED: SPEC.approve-stopped`, `PROOF PASSED: SPEC.approve-nonpayable`, and `PROOF PASSED: SPEC.approve-success`. Raw stderr contains only the non-fatal warning that `--equation-max-local-steps` is ignored for non-booster `kore-rpc`. |
| `kprover validate --project /app --session 6c5683d6-10ee-4844-b98a-d8fbcc8c2caf --semantics evm --spec inputs/false-postcondition.k --spec-module AUDIT-FALSE-SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/bytecode.k` | 0 | Task `0e77d7c8-9654-4855-b3c8-9f9a3b207032`, `valid: true`, K exit `0`. |
| `kprover prove --project /app --session 6c5683d6-10ee-4844-b98a-d8fbcc8c2caf --semantics evm --spec inputs/false-postcondition.k --spec-module AUDIT-FALSE-SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/bytecode.k` | 1 | Task `aaaf04c1-1ce2-49f3-8073-129c0e37bdaf`, `status: completed`, `outcome: notProved`, K exit `1`. The raw failing node has path condition `#Top`; its `OUTPUT_CELL` is actual `00...01 #Implies 00...00`, so matching fails exactly at the false result. |
| `perl -0777 -e '...compare #parseByteStack payload with contract.bin...'` | 0 | `candidate_bytes=6955`, `contract_bytes=6955`, `exact_match=true`. |
| `kprover semantics fetch --project /app evm` | 0 | Fetched the immutable `4f4c3843076c` source tree for read-only inspection. |
| `rg`/`sed` inspections of candidate declarations and the pinned ABI, hashed-location, buffer, storage-lookup, LOG, and execution rules | 0 | Confirmed the extension inventory, equation definitions, Solidity key order, byte extraction, lookup behavior, and fixed LOG state transition described below. |
| `node /app/output/audits/proof-audit-1-evidence/stopped-clear-boundaries.js` | 0 | Bytes/clear results: `0/true`, `0/true`, `1/false`, `255/false`, and `7/false` for the five recorded boundary words. |

The retained positive validation/proof and mutation validation/proof JSON files contain both raw stdout and stderr. The EVM frontend renders terminal closure as one `PROOF PASSED` line per claim; the structured Prover result simultaneously records `outcome: proved`, null residual, and exit `0`.

After all required dynamic evidence had completed, an additional, non-load-bearing body-sensitivity artifact was prepared that changes the claim's actual `<program>` and account `<code>` to a one-byte `STOP` body. Its validation request received HTTP `502 Bad Gateway` before a task was created; a session check showed no validation or proof counter was consumed, and subsequent health checks also returned 502. This optional probe is not reported as passed and is not used to support the verdict. Program identity instead rests on the exact binary comparison, the actual unbounded execution replay, and the result-sensitive A5 rejection.

## Fresh A5 mutation witness

`proof-audit-1-evidence/false-postcondition.k` is a distinct module authored during this audit. It keeps the exact `DSTOKEN_RUNTIME` program, binding, inputs, precondition, status, storage update, and logs of `SPEC.approve-success`, but changes only the expected output from ABI true, `#buf(32, 1)`, to ABI false, `#buf(32, 0)`.

A satisfiable witness is `ACCT = 0`, `CALLER_ID = 1`, `GUY = 2`, `WAD = 7`, any log prefix, and a storage map whose slot-4 word is zero. All address/word range constraints hold and `stoppedClear` is true. The symbolic mutation failed under path condition `#Top`, stronger evidence than failure only at that ground witness. Its retained stdout identifies the unmet result exactly: the real terminal output ends in byte `01`, whereas the destination ends in byte `00`.

## Rebuilt proof-extension inventory

There are no proof-local auxiliary claims, trusted claims, priority rules, simplification/concrete rules, ordinary execution rewrites, or operational bridges. `VERIFICATION` imports the immutable bundled `LEMMAS`; it does not add or override one. The approved `VERIFICATION-SUMMARIES` content has hash `57d5ca8d...89b6`, exactly the content named by the approved spec audit.

| Extension | Class and complete domain | Behavior, footprint, and value influence | Justification, dependents, and validation |
|---|---|---|---|
| `DSTOKEN_RUNTIME => #parseByteStack("0x...")` | Definitional summary; one unguarded terminating equation | Expands a name to bytes; it skips no EVM transition. It fixes the program and account code used by all claims. | The 6,955-byte payload equals `/app/contract.bin` byte-for-byte. All three claims depend on it and passed fixed-semantics replay. |
| `approveCallData(GUY,WAD)` | Definitional summary; unguarded equation, used where `GUY` is a 160-bit address and `WAD` a 256-bit word | Constructs the fixed semantics' canonical `approve(address,uint256)` ABI input. It affects dispatcher selection and decoded arguments, but performs no EVM step. | Pinned ABI equations generate the signature and encode `#address`/`#uint256`; claim guards cover their value guards. All claims depend on it and replay closed. |
| `approveSlot(OWNER,GUY)` `[function,total]` | Definitional summary; one unguarded terminating equation, used for ranged addresses | Names the nested Solidity mapping slot. It affects the success storage postcondition only; no state is changed by the definition. | Pinned `#hashedLocation` equations fold `OWNER GUY` as `keccak(GUY . keccak(OWNER . slot(2)))`, matching `_approvals[OWNER][GUY]`. `approve-success` connects actual SSTORE execution to the term. No collision-freedom assertion is made. |
| `stoppedClear(STORAGE)` `[function,total]` | Definitional predicate; one unguarded terminating equation over `Map`, used with a ranged slot-4 word | Reads no live cell and performs no transition; it partitions the zero-value claims by packed bits 160–167 of slot 4. | `#lookup` returns the 256-bit slot word, division by `2^160` shifts, `#buf(32,...)` is big-endian, and byte range `(31,1)` selects the low byte of that quotient. The two guards are Boolean complements. Boundary artifact confirms `0,0,1,255,7`; static arithmetic establishes full-domain truth. |
| `approveNoteData(GUY,WAD)` | Definitional summary; one unguarded terminating equation | Names the anonymous note event's non-indexed data: zero call value, dynamic offset 64, calldata length 68, then canonical calldata. It affects only the success log postcondition. | Fixed execution of LOG4 closed against this destination; inputs are in the ABI summary domain. |
| `approveNoteLog(ACCT,CALLER_ID,GUY,WAD)` | Definitional summary; one unguarded terminating equation | Constructs one `SubstateLogEntry`; it does not append a log itself. Its value affects the first appended success log. | Topic 0 is the left-aligned `095ea7b3` selector, followed by caller, decoded address word, and amount; data is `approveNoteData`. Fixed LOG4 execution closed against it. |
| `approvalLog(ACCT,CALLER_ID,GUY,WAD)` | Definitional summary; one unguarded terminating equation | Constructs one `SubstateLogEntry`; it affects the second appended success log. | It uses the ERC-20 Approval topic `8c5be1e5...c3b925`, indexed caller and spender, and 32-byte amount data. Fixed LOG3 execution closed against it. |

Every equation has one defining rule, hence no pairwise overlap; each structurally reduces to pinned built-ins and has no recursion. The two `[total]` declarations have unguarded defining equations. The remaining summaries are reached only under the range conditions needed by their pinned ABI/hash subterms. No extension introduces a fresh result, abrupt control, frame change, exception, or state abstraction. Consequently the operational-bridge context procedure and bridge connection-theorem obligation are inapplicable.

The only opaque result-bearing operation is the immutable semantics' `keccak` at the EVM cryptographic boundary. It is not program-defined or introduced by this proof. Execution and the storage-location postcondition are interpretation-parametric in that fixed operation, and the theorem asserts neither a concrete symbolic hash nor collision resistance. There is no same-symbol circularity introduced by an execution bridge.

## Gate A — PASS

- **A1/program pinning:** Each entry claim begins at `#execute` with `DSTOKEN_RUNTIME` in both `<program>` and the account `<code>`. The named payload exactly equals the supplied runtime. There is no bridge that can replace the dispatcher, modifiers, logging, or base approve body. The clean-room unbounded replay executes the body and closes all three claims.
- **A2/A3 state and control:** No operational bridge exists. The claims observe terminal control, status, output, the complete contract storage map, and the complete log list. Success updates exactly one computed storage key, preserves the rest, and appends exactly two logs; both failures preserve complete storage and log state. The stopped failure reaches invalid-instruction status; nonpayable reaches revert status. Binding is fixed by canonical selector calldata and the exact runtime dispatcher.
- **A4 equations:** The inventory above is terminating, covered at every use, non-overlapping, and truthful relative to the immutable semantics. No candidate rule assumes the requested operational result.
- **A5/non-vacuity:** The stated ground witness satisfies the success precondition. The fresh false-output module validates, then fails with `notProved`, exit `1`, and a residual failing node showing actual ABI true cannot imply ABI false under `#Top`.

## Residual Gate B — PASS

- **B1 input domain:** The theorem ranges over every 160-bit account/caller/spender, every 256-bit amount, arbitrary symbolic storage subject only to the fixed model's slot-word well-formedness where read, and arbitrary existing log prefixes. Zero-value calls are exhaustively partitioned by complementary stopped predicates; every nonzero 256-bit call value is covered independently of stopped state. No proof-time guard, bounded unrolling, claim drop, or strengthened requirement was introduced.
- **B2 model:** The theorem intentionally states functional partial correctness for canonical typed calldata in normal, non-static, infinite-gas direct runtime execution under Cancun. Malformed/short/selector-mismatched/trailing calldata, static-context failure, finite-gas/out-of-gas behavior, balance/fee effects, and transaction-wrapper rollback are explicit environment exclusions, not silently narrowed symbolic source inputs. The old runtime's executed opcodes are defined by the selected schedule.
- **B3 summary meaning:** ABI data, packed stopped byte, nested allowance slot, LogNote payload/topics, Approval event, and ABI true output are tied to the fixed semantics by the successful execution proof; no separately assumed human-facing result lemma exists.
- **B4 implementation/intent:** The runtime behavior proved for selector `approve(address,uint256)` matches `DSToken.approve`: nonpayable guard first, `stoppable` assertion, `note` event, base allowance overwrite, Approval event, and true return. The theorem is about the supplied runtime; it makes no recompilation or compiler-correctness claim for `contract.sol`.

The proved theorem is the same three-claim theorem approved in `spec-audit-2.md`; proving added no assumptions, filters, depth bounds, trusted claims, or new equations. Therefore there is no residual narrowing.

## Gate C — PASS

### Trust ledger

| Named boundary | Effect | Dependents | Evidence/status |
|---|---|---|---|
| Immutable bundled `evm` semantics at `4f4c3843076c`, including Cancun opcode behavior, ABI helpers, Solidity hashed locations, and `keccak` | Defines execution, symbolic hashes, status, storage, logs, and output | All three claims | Independently pinned to the same revision; sources inspected read-only. This is the fixed semantics requested by the task, not a candidate extension. |
| K/KEVM proof engine and its SMT/backend implementation | Establishes symbolic reachability closure | All formal results | Prover 7.1.337 retained task IDs, definition ID, exit codes, typed outcomes, stdout, and stderr. |
| Supplied runtime identity | Determines which program is proved | All three claims | Candidate payload and `/app/contract.bin` are both 6,955 bytes and identical. No source-recompilation claim is made. |

There are no `--trusted` claims and no candidate-specific semantic assumptions. The positive replay, source validation, false-postcondition validation/rejection, exact-byte comparison, and boundary test all have existing artifacts and exact commands recorded above. The arithmetic boundary script is finite corroboration only; universal summary correctness comes from the equations plus the symbolic proof. The unsuccessful optional body probe is explicitly not evidence.

## Findings

No soundness, adequacy, or auditability finding was identified. The mandatory instruments completed before the later transient service outage.

VERDICT: PASS
REASON: All three gates pass, so the independently replayed and non-vacuous DSToken approve theorem has final status VALIDATED.
