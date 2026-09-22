# Specification audit 1

## Artifacts examined

- `/app/contract.sol` (SHA-256 `cee59f7cb8d3245e61fab5bb037753500cf71e19be40184acb1a8306dc05106b`)
- `/app/contract.bin` (2,091 bytes; SHA-256 `71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`)
- `/app/output/spec.k`
- `/app/output/verification.k`, especially `VERIFICATION-SUMMARIES`
- `/app/output/SCOPE.md`
- pinned semantics `evm` at revision `4f4c3843076c`

This is a same-agent stage review performed from the on-disk artifacts, as permitted by KIT's orchestration workflow before the independent final proof audit.

## Commands and results

1. `kprover session show be08e0e3-e40e-4601-8a5d-f2c542d32676` — exit 0; the session pins semantics ID `evm`, repository `nlp-research-rosu/semantics-evm`, commit `4f4c3843076c`.
2. `diff -qr /app/semantics /home/node/.config/kprover/semantics/nlp-research-rosu/semantics-evm/4f4c3843076c` — exit 0; supplied and pinned source trees are identical.
3. `sha256sum contract.sol contract.bin` — exit 0; hashes are listed above.
4. `TASK_RUNTIME_HEX="$(od -An -v -tx1 contract.bin | tr -d ' \\n')" perl -ne 'while (/#parseByteStack\\("([0-9a-f]+)"\\)/g) { die "bytecode mismatch\\n" unless $1 eq $ENV{TASK_RUNTIME_HEX}; $count++ } END { print "exact-runtime-literals=$count\\n" }' output/spec.k` — exit 0; `exact-runtime-literals=6`. Every program and jump-destination occurrence contains the complete supplied runtime.
5. Selector-route check over the runtime hex — exit 0; found `63a9059cbb14610192` at byte offset 89, routing canonical `transfer(address,uint256)` calldata to `0x0192`.
6. `kprover validate --session be08e0e3-e40e-4601-8a5d-f2c542d32676 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION` — exit 0; task `164dc472-ea18-4d01-aef9-8a2b6edfc5fa`, `status: completed`, `result.valid: true`. Retained result: `/app/output/evidence/validation-007.json`.

## Gate B adequacy

### Plain-language formal contract

All claims begin at runtime PC 0 on canonical `transfer(address,uint256)` calldata with symbolic addresses, value, storage, and prior log state. With zero call value, the success claim requires a positive transfer value no greater than the caller balance and requires boolean true, two sequential storage writes, and the exact ABI Transfer log. The false claim covers the logical complement (`value == 0` or balance below value) and requires boolean false with storage/log unchanged. The nonpayable claim covers every positive word-sized call value and requires an empty-data revert with storage/log unchanged.

This matches source lines 94–110 and the supplied runtime. The source guard, update order, event, and returns correspond exactly. The additional nonpayable claim records behavior inserted by the compiler and present in the runtime.

### Domain coverage

For canonical ABI calls in the selected functional execution model, call value is partitioned into zero and positive cases. At zero call value, the source guard is partitioned into success and failure without overlap or gap. Address and uint guards cover their complete ABI ranges. Storage is an unbounded symbolic `Map`, not a finite set of examples.

The explicit exclusions—malformed calldata, other selectors, static context, transaction-envelope checks, and out-of-gas termination—are execution-environment boundaries recorded in `SCOPE.md`, not hidden restrictions on the transfer arguments or storage theorem.

### Storage and event fidelity

`balances` is slot 1 because inherited `totalSupply` precedes it at slot 0. The runtime visibly builds the Solidity mapping key with slot 1 around both SLOAD and SSTORE sequences. The success RHS models the writes sequentially: the recipient read is from the map after the sender deduction. Therefore caller/recipient aliasing and any coincident storage location are not incorrectly assumed away. `-Word` and `+Word` match the EVM arithmetic; the success guard prevents sender underflow while recipient overflow remains wrapping behavior.

The log uses the semantics' `#abiEventLog` with two indexed address arguments and one non-indexed uint256 argument, matching `Transfer(msg.sender, to, value)`.

### Model boundary

The BYZANTIUM schedule is witnessed by `0xfd` in the supplied runtime's nonpayable guards. Gas accounting is explicitly disabled, so no claim is made about gas usage or out-of-gas results. The fixed semantics tree supplied in `/app/semantics` is byte-identical to the remote pinned source tree.

## Summary faithfulness

`VERIFICATION-SUMMARIES` introduces no candidate mathematical function or equation; it only imports the bundled `EDSL`. There is therefore no candidate summary equation requiring boundary or differential evaluation. The theorem's result, storage, and log postconditions are stated directly in the claims using bundled EVM/ABI operations.

## Findings

No adequacy, scope-record, summary-faithfulness, identifier, parser, or module finding remains. Concrete program identifiers were eliminated; the final spec uses direct byte literals and symbolic variable names that do not collide with opcode tokens.

VERDICT: PASS
REASON: The three symbolic claims faithfully and completely partition canonical transfer calls in the recorded functional EVM boundary, and the candidate bundle validates against the pinned semantics.
