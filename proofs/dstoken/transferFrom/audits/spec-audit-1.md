# KIT specification audit 1

## Artifacts examined

- `/app/contract.sol`
- `/app/contract.bin` (6,955 bytes; SHA-256 `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`)
- `/app/output/spec.k`
- `/app/output/verification.k`, especially `VERIFICATION-SUMMARIES`
- `/app/output/SCOPE.md`
- pinned semantics `evm` at commit `4f4c3843076c`
- construction session `0965306b-374d-4868-a291-37d3096894d4`

## Mechanical checks

- `kprover validate --session 0965306b-374d-4868-a291-37d3096894d4 --spec inputs/spec.k --spec-module TRANSFER-FROM-SPEC --verification inputs/verification.k --verification-module VERIFICATION`
  - validation 1: exit 1, parser collision from symbolic name `CALLER`; repaired without changing the theorem.
  - validation 2: exit 113, parser collision from symbolic name `CALLVALUE`; repaired without changing the theorem.
  - validation 3: exit 0; task `636b692d-a72a-46ea-862b-793636981356`; `valid: true`; evidence `/app/.kprover/sessions/0965306b-374d-4868-a291-37d3096894d4/validation-003/result.json`.

Concrete identifiers `DSTOKEN`, helper applications, all seven claim labels, modules, and the complete source bundle parse and compile under the pinned definition.

## Formal contract restatement

The claims cover canonical `transferFrom(address,address,uint256)` calldata for symbolic 160-bit source, destination, caller, and deployed token addresses, symbolic uint256 amount, and otherwise arbitrary storage. With zero call value, the claims partition stopped, insufficient-balance, insufficient-allowance, overflow, distinct-address success, and self-transfer success. A positive-call-value claim covers the non-payable revert. Success constrains status, ABI `true`, external-call success flag, exact storage updates, and both logs; failure constrains the status and external-call failure flag while call snapshots restore storage and substate.

The exclusions and readings in `SCOPE.md` are visible rather than silent: canonical calldata only, Shanghai schedule, gas disabled, no precompile deployment address, and a mapping-slot non-collision trust boundary.

## Findings

### F1 — `LogNote.wad` summary is unfaithful

Source contract phrase: `LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);` in `DSNote.note`.

Formal term: `#transferFromLogs(TOKEN, GUY, SRC, DST, WAD)` defines the anonymous note's non-indexed data as `#encodeArgs(#uint256(WAD), #bytes(#abiCallData(...)))`.

Witness: take canonical zero-value `transferFrom(SRC, DST, 1)`. The implementation logs `msg.value = 0` as the first data word, while the summary logs token amount `1`. The claims therefore assert the wrong observable successful log for every success with `WAD =/=Int 0`.

Required repair: encode `#uint256(0)` in the anonymous note data (or parameterize the helper by actual call value, which is zero on every successful claim), then rerun validation and this audit.

The runtime image equation, Solidity mapping locations, packed stopped-byte extraction, Transfer-event term, branch partition, storage postconditions, and rollback reading showed no contrary witness in this audit. Those items must nevertheless be re-audited after the predecessor changes.

VERDICT: FAIL
TARGET: writing-spec
REASON: The successful-log summary encodes token amount WAD where the implemented anonymous LogNote encodes zero msg.value.
