# KIT specification audit 2

## Artifacts examined

- `/app/contract.sol`
- `/app/contract.bin`
- revised `/app/output/spec.k`
- revised `/app/output/verification.k`
- `/app/output/SCOPE.md`
- `evm` semantics commit `4f4c3843076c`
- construction session `0965306b-374d-4868-a291-37d3096894d4`

## Mechanical check

Command:

`kprover validate --session 0965306b-374d-4868-a291-37d3096894d4 --spec inputs/spec.k --spec-module TRANSFER-FROM-SPEC --verification inputs/verification.k --verification-module VERIFICATION`

Result: exit 0; validation 4; task `2b12cf04-f175-4b06-bc3c-0fdce6e1ecd5`; `valid: true`; evidence `/app/.kprover/sessions/0965306b-374d-4868-a291-37d3096894d4/validation-004/result.json`.

The repair from audit 1 is faithful: every successful claim injects call value zero, and `#transferFromLogs` now encodes `#uint256(0)` for `LogNote.wad` while retaining `WAD` in calldata and the `Transfer` event.

## Finding

### F1 — ordinary contract address zero is silently excluded

Scope/formal phrase: `SCOPE.md` says the deployed token address is “above 9,” and every claim requires `TOKEN >Int 9`, justified as excluding Shanghai precompiles.

Pinned-semantics behavior: `#isPrecompiledAccount(ACCTCODE, SCHED)` reduces to `0 <Int ACCTCODE andBool ACCTCODE <=Int #precompiledAccountsUB(SCHED)`. Under Shanghai, addresses 1 through 9 are precompiles; address 0 is not.

Witness: `TOKEN = 0`, with any otherwise satisfying success or failure inputs. `#mkCall` executes the supplied runtime at address zero, but every drafted claim's precondition is false. An address is a 160-bit value and the original task does not exclude zero, so this is candidate-caused input-domain narrowing rather than a fixed-model boundary.

Required repair: replace `TOKEN >Int 9` with `TOKEN ==Int 0 orBool TOKEN >Int 9` (properly parenthesized in conjunctions), and update `SCOPE.md` to say only precompile addresses 1 through 9 are excluded.

No additional contrary witness was found in the revised branch partition, storage updates/rollback, ABI outputs, event summaries, packed stopped-byte definition, or runtime-image binding. All must be rechecked after repair.

VERDICT: FAIL
TARGET: writing-spec
REASON: Every claim unnecessarily excludes ordinary non-precompile contract address zero.
