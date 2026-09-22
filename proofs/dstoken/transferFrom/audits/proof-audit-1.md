# Independent final proof audit: `DSToken.transferFrom`

## Verdict

**VALIDATED.** Gates A, B, and C pass. This audit was performed from the original Solidity source, exact runtime, and frozen proof sources. No constructor audit report or constructor proof evidence was used. The frozen candidate files were not modified.

## Frozen inputs and independence

The audited files had these SHA-256 hashes both before and after the audit:

| File | SHA-256 |
|---|---|
| `/app/output/spec.k` | `ff40aba260d6b3a92bb956161a7efbf254cee769d2f84d883ef3bb0bf4f7be82` |
| `/app/output/verification.k` | `140d72159e0d2954e7dc0648347f2b339764ae534f42f8dde25d666c77aa0b7b` |
| `/app/output/SCOPE.md` | `e8bad68961e935bf37321f67fb3388ace15a4475d644fbf1c33c77426e39e243` |
| `/app/output/prove.sh` | `a7a00469131f5460703a9c0975c0eb1df548d55462a7e1c5372dcf6a74d66445` |
| `/app/contract.bin` | `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82` |
| `/app/contract.sol` | `f4bcfc92c70fc8196e8802abb9dbff0ebbc05cb6f18a1e6621ad63362d90cf0e` |

I started fresh audit session `ce7e3afa-0372-49b8-9f3e-884cc8224818`, workspace `/app/.kprover/sessions/ce7e3afa-0372-49b8-9f3e-884cc8224818`, with project `/app`. Its independently selected immutable semantics descriptor is:

```text
id: evm
repo: https://github.com/nlp-research-rosu/semantics-evm
commit: 4f4c3843076c
K version from health: 7.1.337
```

`kprover semantics`, `kprover session show`, and `kprover semantics fetch evm` all reported that same descriptor. A pin-only comparison with the session named in the frozen `prove.sh` showed the same repository and commit; no constructor task ID, log, result, or evidence directory was reused. The fetch resolved the immutable shared source directory `/home/node/.config/kprover/semantics/nlp-research-rosu/semantics-evm/4f4c3843076c`; no bundled semantics were copied into the audit inputs.

Before validation, the fresh `inputs/` contained only byte-identical copies of the two proof sources:

```text
ff40aba260d6b3a92bb956161a7efbf254cee769d2f84d883ef3bb0bf4f7be82  inputs/spec.k
140d72159e0d2954e7dc0648347f2b339764ae534f42f8dde25d666c77aa0b7b  inputs/verification.k
```

The auditor-authored mutation was later added as `inputs/false-postcondition.k`, SHA-256 `8a1edb3b9b20632086087f31fc1b9abce7051d04ec13e4591807e701ccafee30`.

## Program identity and formal target

Decoding the sole hexadecimal literal in `#binRuntime(DSTOKEN)` produced 6,955 bytes. `cmp` against `/app/contract.bin` returned zero, and the decoded bytes independently hashed to `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`. Thus every entry claim places the exact supplied runtime in the token account and in `#mkCall`; the program term does not read a mutable source path.

The Solidity source defines the inherited implementation at lines 397–408 and the `stoppable note` wrapper at lines 447–451. Independent bytecode inspection found selector `0x23b872dd` dispatching to offset `0x224`; the non-payable check is at `0x225–0x22e`, the wrapper/modifier and anonymous `LogNote` path starts at `0x960`, and the inherited balance/allowance checks, three storage writes, `Transfer` event, and true return start at `0x1596`. This establishes the source-level association while the formal theorem itself is about the exact bytecode.

The seven claims are all symbolic reachability claims over addresses, amount, relevant storage, caller stack, touched/accessed sets, and surrounding configuration:

1. successful distinct-address transfer;
2. successful self-transfer;
3. stopped-token `INVALID` failure;
4. insufficient-balance `INVALID` failure;
5. insufficient-allowance `INVALID` failure;
6. destination-addition-overflow `INVALID` failure; and
7. positive-call-value `REVERT` failure.

On success they constrain ABI `true`, status, outer success flag, exact storage updates, exact two-log sequence, and touched/accessed effects. On failure they constrain empty return data, failure flag, status, and rollback of storage/logs. These cases partition the canonical call path under the stated mapping-location noncollision boundary.

## Reconstructed proof-extension inventory

The candidate has no auxiliary claims, trusted claims, claim assumptions, operational bridges, priority rules, concrete rules, totality attributes, simplification attributes, fresh values, or opaque candidate functions. The spec contains only the seven target claims. `verification.k` imports fixed `EDSL` and fixed `LEMMAS` from the pinned semantics and defines these five local extensions:

| Extension | Class and semantic role | Domain, context, state, and value influence | Justification, dependents, and validation |
|---|---|---|---|
| `DSTOKEN`; `#binRuntime(DSTOKEN) => #parseByteStack("0x…")` | Definitional summary. It names supplied program bytes; it does not replace EVM execution. | Exact `DSTOKEN` constructor only. No continuation/control match and no cell read/write. Its value selects all executed code and therefore influences every observable. | The literal decodes byte-for-byte to `contract.bin`, length 6,955, with the supplied SHA-256. All seven claims depend on it. Fixed EVM semantics executes the resulting bytes. |
| `#balanceSlot(ACCOUNT)` | Definitional summary of a Solidity mapping location. | One `Int`; all claim uses additionally have 160-bit address guards. No operational context or cell effect. The value selects source/destination storage reads, writes, branches, and postconditions. | Expands to pinned `#hashedLocation("Solidity", 1, ACCOUNT .IntList)`, whose fixed equation is the EVM-compatible `keccak(key32 ++ slot32)`. All balance-sensitive claims depend on it. |
| `#allowanceSlot(SRC, GUY)` | Definitional summary of the nested approvals mapping location. | Two `Int`s; claim uses are guarded as addresses. No operational context or cell effect. The value selects allowance reads/writes and branch/postcondition values. | Expands to pinned nested `#hashedLocation("Solidity", 2, SRC GUY .IntList)`. All allowance-sensitive claims depend on it. |
| `#stoppedByteIsZero(STORAGE)` | Definitional Boolean predicate used in preconditions, not an execution rewrite. | Every `Map`; reads the fixed `#lookup(STORAGE, 4)` expression and extracts byte offset 20. It influences claim partitioning only. | Solidity layout is `_supply` slot 0, balances slot 1, approvals slot 2, authority slot 3, owner in the low 20 bytes of slot 4, and `stopped` in the next byte. All zero-value claims depend on this partition predicate. |
| `#transferFromLogs(TOKEN, GUY, SRC, DST, WAD)` | Definitional summary of the expected final list, not an operational bridge. | Five `Int`s; used after fixed execution. No cells are read or written by the equation. Its value affects only the success postcondition on `<log>`. | Expands to the anonymous `LogNote` followed by standard `Transfer`. The first topic constant is exactly `0x23b872dd << 224`; caller/source/destination topics and the legacy 196-byte note payload match the inspected bytecode. The two success claims depend on it. |

Every candidate equation is unconditional, one-step, terminating, and non-overlapping with another candidate equation for the same symbol. The slot helpers can leave the pinned `#hashedLocation` term unevaluated outside its fixed-semantics guards, but every claim use supplies the required address/range guards; none is declared total. The `VERIFICATION-SUMMARIES` module in the frozen file remained unchanged throughout proving and mutation.

`LEMMAS` and its transitive files are immutable components of the selected remote semantics, not proof-local uploads. The directly imported `lemmas/lemmas.k` has SHA-256 `4167738dde6fb2caf6493f03dc54f2b5d75f4a7dd4250b51287e219a3ea09460`. Its arithmetic, byte, map, and slot-update simplifications are part of the fixed proof theory and TCB and are ledgered below rather than misrepresented as locally proved extensions.

There are no operational bridges, so the operational-bridge context and continuation-sensitivity procedures are not applicable: no candidate rule matches or preempts an EVM instruction, call frame, continuation, return, exception, or state transition. There are also no program-derived fresh or opaque results. The pinned `keccak(Bytes)` primitive is an external fixed-semantics primitive: both EVM `SHA3` and `#hashedLocation` use it, and the theorem is interpretation-parametric except for explicitly assumed noncollision inequalities. No claim concludes a numeric hash value.

## Fresh dynamic reconstruction

### Exact-runtime check

```sh
perl -0777 -ne 'if(/#parseByteStack\("0x([0-9a-f]+)"\)/s){print pack("H*",$1)}else{exit 2}' /app/output/verification.k | sha256sum
cmp -s /app/contract.bin <(perl -0777 -ne 'if(/#parseByteStack\("0x([0-9a-f]+)"\)/s){print pack("H*",$1)}else{exit 2}' /app/output/verification.k)
```

Actual result: decoded hash `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`; `cmp` exit `0`.

### Clean-room validation

```sh
kprover validate --project /app \
  --session ce7e3afa-0372-49b8-9f3e-884cc8224818 \
  --semantics evm \
  --spec inputs/spec.k --spec-module TRANSFER-FROM-SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```

Actual result: task `00b83573-4125-4742-b251-3f6b1ec68e7d`, `status: completed`, `valid: true`, K exit `0`, definition `7_1_337-haskell-evm-4f4c3843076c-d1e156d0ddf3061f87974d71f23c0154ed8397de24c4bfa2f0f775670bd9697b`. Evidence: `validation-001/result.json`, SHA-256 `c92957a60371ac29c49bb1af7b05f3b94f2d02808e8c4e8657de838c2bd0158d`.

### Complete unfiltered positive proof

```sh
kprover prove --project /app \
  --session ce7e3afa-0372-49b8-9f3e-884cc8224818 \
  --semantics evm \
  --spec inputs/spec.k --spec-module TRANSFER-FROM-SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION
```

No `--claim`, `--exclude-claim`, `--trusted`, or `--depth` option was used. Actual result: task `fa777b3f-e1e6-45c2-9f3e-1986d655731a`, `status: completed`, typed `outcome: proved`, `residual: null`, K exit `0`, tool outcome `success`. Evidence: `proof-001/result.json`, SHA-256 `78df68c947c951b5601b2d12baacdfb2ca69b13b3eee65a7854340c11cefbd69`.

Actual retained stdout:

```text
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-failure-nonpayable
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-failure-balance
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-failure-allowance
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-success-self
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-failure-stopped
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-success-distinct
PROOF PASSED: TRANSFER-FROM-SPEC.transferfrom-failure-overflow
```

Thus the claim set is complete relative to the seven declarations: seven declarations and seven distinct pass lines.

## Gate A5 non-vacuity mutation

The satisfiable witness chosen before mutation was:

```text
TOKEN = 10, GUY = 11, SRC = 12, DST = 13, WAD = 1
slot 4 = 0
balanceSlot(12) = 1
balanceSlot(13) = 0
allowanceSlot(12,11) = 1
```

OpenSSL `KECCAK-256` produced the following concrete locations, all pairwise distinct and different from slot 4:

```text
balanceSlot(12)       = 0x23bf72df16f8335be9a3eddfb5ef1c739b12847d13a384ec83f578699d38eb89
balanceSlot(13)       = 0x86b3fa87ee245373978e0d2d334dbde866c9b8b039036b87c5eb2fd89bcb6bab
allowanceSlot(12,11)  = 0xfaa9dc7ff6c9564b9ded978eeefddefb0bb3385990cc35712d4b9faba663b02b
```

Exact witness commands (32-byte big-endian words; the last command uses the preceding inner hash `bd814762…67c0`):

```sh
perl -e 'print pack("H*",("00"x31)."0c".("00"x31)."01")' | openssl dgst -keccak-256
perl -e 'print pack("H*",("00"x31)."0d".("00"x31)."01")' | openssl dgst -keccak-256
perl -e 'print pack("H*",("00"x31)."0c".("00"x31)."02")' | openssl dgst -keccak-256
perl -e 'print pack("H*",("00"x31)."0b"."bd814762a7e35d5c162a7570d14baa68bd622cabb1ad83d40dd70f8a88aa67c0")' | openssl dgst -keccak-256
```

Actual outputs, in order: `23bf72df…eb89`, `86b3fa87…6bab`, `bd814762…67c0`, and `faa9dc7f…b02b`; mismatch/slot-4 comparisons all returned true. The selector oracle was `printf 'transferFrom(address,address,uint256)' | openssl dgst -keccak-256`, which returned `23b872dd7302113369cda2901243429419bec145408fa8b352b3dd92b66c680b`.

The mutation is in distinct module `TRANSFER-FROM-FALSE-POST-SPEC`, with distinct label `transferfrom-success-distinct-false`. Its only semantic change is:

```diff
-    <output> .Bytes => #buf(32, 1) </output>
+    <output> .Bytes => #buf(32, 0) </output>
```

The mutation validation task `b91ec1df-1aca-4f58-8e33-63bc5d743916` was `valid: true` with exit `0`; evidence is `validation-002/result.json`, SHA-256 `5280fae9de1360c37bc9bc818b709a1e3c45c82331d66137a3f13c36ee66316d`.

Mutation proof command:

```sh
kprover prove --project /app \
  --session ce7e3afa-0372-49b8-9f3e-884cc8224818 \
  --semantics evm \
  --spec inputs/false-postcondition.k \
  --spec-module TRANSFER-FROM-FALSE-POST-SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --claim TRANSFER-FROM-FALSE-POST-SPEC.transferfrom-success-distinct-false
```

Actual result: task `9e8a62ea-cdd0-4774-8de4-f5ccded8f934`, typed `outcome: notProved`, K exit `1`, one failing node, zero pending nodes. The structured `residual` field is null in this backend response, but the retained prover stdout contains the required stuck-node residual and exact unmet postcondition (so this is not being inferred from the exit code):

```text
PROOF FAILED: TRANSFER-FROM-FALSE-POST-SPEC.transferfrom-success-distinct-false
1 Failure nodes. (0 pending and 1 failing)
Failure reason: Matching failed.
OUTPUT_CELL: b"...\x01" #Implies b"...\x00"
Path condition:
  #Top
```

Evidence: `proof-002/result.json`, SHA-256 `52e734b812fbb41da67df1673a78b276cc33c9ca4193ccbd4a2c104e644654ff`. This is a meaningful rejection of the reachable successful path.

## Gate results

### Gate A — PASS

- **A1:** The entry term resolves to and executes the exact runtime through fixed semantics. No program-defined body is summarized or bridged. The selector and relevant bytecode path were independently inspected.
- **A2/A3:** There are no operational bridges. Fixed semantics performs dispatch, modifier evaluation, logging, mapping hashes, arithmetic, writes, return, exception propagation, snapshot rollback, and outer-call restoration. The claims constrain relevant result, control, and observable cells.
- **A4:** All five candidate definitions are truthful definitional expansions, unconditional/non-overlapping, and terminating. No candidate totalization, priority, or opaque oracle exists. Fixed `keccak` remains a named interpretation-parametric primitive; noncollision is explicit.
- **A5:** The concrete witness above satisfies the success precondition. The independently authored false ABI-return mutation is `notProved`, exit `1`, with a one-node residual showing actual `...01` versus required `...00` under `#Top`.

### Residual Gate B — PASS

- The address and amount variables cover their full EVM bit-widths; storage is otherwise symbolic. The zero-value branches form the implemented stopped/balance/allowance/overflow/success partition, including self-transfer, and the positive-value branch covers the non-payable revert.
- `TOKEN` excludes precompile addresses 1–9 because Shanghai dispatches them as precompiles rather than account code; zero remains represented. Canonical ABI calls, normal/non-static mode, and gas-disabled functional behavior are explicit model boundaries, not hidden restrictions.
- The source wrapper and inherited implementation align with the inspected selector path in the exact runtime. The slot and log summaries expand to the property stated by the claims.
- The success/overflow claims explicitly require relevant mapping locations to be distinct from each other and slot 4. This is the standard cryptographic storage-layout noncollision trust boundary; the conclusion is conditional on it and does not claim collision cases.

### Gate C — PASS

Every unproved component and model boundary is ledgered below. All claimed dynamic artifacts exist, with exact commands, inputs, outputs, task IDs, hashes, and oracles. Formal proof, conditional conclusions, deterministic integrity checks, and exclusions are separated.

## Trust ledger

| Assumption or TCB component | Effect and dependents | Evidence / treatment |
|---|---|---|
| Remote `evm@4f4c3843076c`, its bundled `LEMMAS`, K `7.1.337`, Haskell backend, and SMT reasoning are sound. | Value, control, state, and termination reasoning for all claims. | Immutable registry/session pin, fetched sources for inspection, successful validation, fresh proof replay. This is the formal-method TCB, not a theorem proved here. |
| EVM `keccak(Bytes)` denotes the intended hash primitive. | Mapping locations in every storage-sensitive claim. | Fixed semantics makes `SHA3` and `#hashedLocation` use the same primitive. The claims are parametric in its numeric results. |
| Relevant Solidity storage locations do not collide. | The distinct-success, self-success, and overflow claims' readable update descriptions. | Explicit `requires` inequalities; concrete witness above shows satisfiability. No universal collision-resistance claim is made. |
| The supplied source is associated with the supplied runtime. | Source-level name `DSToken.transferFrom`; not needed for the bytecode theorem itself. | Selector, dispatcher, modifier, inherited body, event, and return offsets independently inspected. Compiler correctness was not assumed as a proved theorem. |
| Initial call-frame setup and omitted configuration cells satisfy the displayed claim pattern. | All claims; especially outer call restoration and direct positive-value call. | Explicit claim cells plus K framing; behavior outside this call-entry model is excluded below. |

## Empirical and deterministic evidence

- Byte decoding, length, SHA-256, and `cmp` are deterministic integrity evidence that the claim executes the supplied runtime.
- Selector hashing and concrete storage-location hashes are finite witness checks. They establish the displayed witness and constants, not universal injectivity.
- No differential test, fuzz test, or finite sample is claimed as a universal proof.

## Excluded behavior

- malformed, short, trailing, or otherwise noncanonical calldata and other selectors;
- out-of-gas/resource behavior because `<useGas> false`;
- static-call behavior because `<static> false`;
- call-setup failures outside the modeled fresh call frame (depth, caller-balance, or other enclosing-call failures) and Ether-balance observations;
- execution with `TOKEN` at Shanghai precompile addresses 1–9;
- storage-hash collision cases excluded by the explicit successful/overflow preconditions;
- other public functions, authorization helpers, deployment/constructor behavior, and concurrency/reentrancy not exercised by this function (the verified path makes no external call).

## Preserved evidence

All fresh-session inputs and backend results remain under `/app/.kprover/sessions/ce7e3afa-0372-49b8-9f3e-884cc8224818/`. Final counters are two validations, two proof attempts, and zero concrete runs. The only audit outputs outside that workspace are this mandated report and `/app/output/PROOF.md`.
