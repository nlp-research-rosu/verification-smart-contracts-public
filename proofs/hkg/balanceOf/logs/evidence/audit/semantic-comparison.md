# HKG balanceOf reference comparison

The comparison target is `reference/specs/balanceOf-spec.k`. The other HKG
reference functions are outside this function-specific audit. The candidate
also proves the nonpayable revert case, which this RV reference does not state.

## Program and property

Every program and jump-destination byte string in the candidate and the RV
reference decodes to the same 2,091-byte runtime. The runtime SHA-256 is
`71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`.
The on-disk hexadecimal text file has its own distinct SHA-256, recorded in
`source-hashes.json`.

The RV postcondition is successful termination with output `#buf(32, BAL)`
and unchanged selected storage. The candidate output is an expanded memory
expression. Its correspondence is derived from the actual expression:

1. Write `W(x)` for a 32-byte, unsigned, big-endian word. The initial memory
   constant `M0` is 96 bytes and contains `W(96)` at bytes 64 through 95.
2. The candidate precondition identifies
   `A = maxUInt160 &Int #asWord(#range(CALLDATA, 4, 32)) = OWNER`.
   The two memory updates produce `M1 = M0[0 := W(A)][32 := W(1)]`.
3. `M1[0..64] = W(OWNER) || W(1)`. The pinned rule in
   `hashed-locations.md:63` identifies its Keccak value with
   `#hashedLocation("Solidity", 1, OWNER .IntList)`. This uses the same hash
   operation on the same bytes; no collision or injectivity assumption is used.
4. Neither update touches bytes 64 through 95. Thus the free-memory pointer
   is 96. Let `B` be the original storage lookup at that hash location.
   The next update is `M2 = M1[96 := W(B)]`.
5. That update also preserves bytes 64 through 95. The outer return starts at
   96 and its width is `chop(chop(96 + 32) - 96) = 32`.
   Its value is therefore `W(B)`.
6. The uint256 precondition makes `W(B) = #buf(32, B)`. In the RV domain,
   storage contains the selected location mapped to `BAL`, with
   `0 <= BAL < 2^256`; the pinned lookup rule returns `BAL mod 2^256 = BAL`.
   The candidate output therefore equals RV's `#buf(32, BAL)`.

This is a mathematical reduction using the pinned byte and map operations,
not an added K rewrite or assumed claim. Concrete zero and maximum-word
witnesses separately exercise that reduction through the runtime.

## Domain and state comparison

| Difference | Semantic effect on the RV balance property |
|---|---|
| Symbolic 36-byte candidate calldata versus ABI notation | Every RV ABI address encoding has length 36, selector `0x70a08231`, and the same decoded owner. The candidate also accepts noncanonical high padding because the bytecode masks it. |
| Symbolic storage lookup versus explicit selected map entry | Every RV storage instance satisfies the candidate selected-word guard. Candidate also includes absent entries, whose lookup returns zero. |
| Candidate depth 0 and empty call stack | A syntactic configuration restriction. This path contains no CALL or CREATE and ends at bare `#halt`; none of its transition rules reads depth or call stack. The audit's universal reference-context probe explicitly quantifies both. |
| Byzantium versus Istanbul | All executed opcodes decode identically. The relevant fork difference is SLOAD gas price; neither successful value nor storage transition depends on that price. The probe executes Istanbul. |
| Disabled gas versus `#gas(_VGAS)` | RV uses positive-infinite gas, not arbitrary finite gas. Its metadata records cost while comparisons against finite costs always succeed (`gas.md:63-79`). Neither path reads GAS. The RV final gas is unconstrained. The probe enables gas with symbolic infinite-gas metadata. |
| Memory-use counter | Gas-enabled execution updates this counter; both specifications leave its final value existential. Actual memory operations and returned bytes agree. |
| Initial output and status | RETURN overwrites output, and `#end` overwrites status. The probe starts with arbitrary output and status. |
| Code address and stored account code | Candidate's embedded `program` drives execution. No code-address lookup, EXTCODE operation, or call occurs on this path; RV fixes these otherwise irrelevant cells. |
| Origin and other block/network cells | No opcode on this path reads them. Candidate omission frames them symbolically rather than imposing a narrower value domain. |
| Substate | No SSTORE, LOG, SELFDESTRUCT, or account creation occurs. Access lists are disabled in both forks; `#access` is a no-op. The reference permits changes to some substate cells that this path preserves. |
| Nonzero call value | Candidate adds a separate EVMC_REVERT/empty-output/storage-preservation claim. RV's balanceOf reference assumes zero. |

The audit reference-context probe retains the exact runtime and successful
postcondition, but quantifies RV's call depth and stack and uses Istanbul with
infinite gas. It is separate audit evidence; it does not edit or replace the
candidate. Its terminal result must be consulted together with this static
comparison. The unmodified RV specification itself is not replayed here.

## Pinned sources

All rule references are relative to
`kevm-pyk/src/kevm_pyk/kproj/evm-semantics/` in semantics revision
`4f4c3843076c`:

- `evm.md:307-344`: status assignment, halt, and next-opcode execution.
- `evm.md:1384-1394`: RETURN and REVERT set output without stack-frame popping.
- `evm.md:1523-1532`: SLOAD reads the selected account's storage.
- `evm.md:1609-1617`: depth checks belong to call entry, absent from this path.
- `evm.md:2699-2729`: gas, memory accounting, and infinite-gas deductions.
- `evm.md:2810-2825`: access-list work is conditional on the fork flag.
- `gas.md:47-79`: positive-infinite gas and its arithmetic/comparisons.
- `abi.md:141-147,351,471`: signature prefix and address-word encoding.
- `buf.md:60-66`, `evm-types.md:353-395`: byte-word representation.
- `evm-types.md:421-424`: map lookup modulo 2^256 and default zero.
- `hashed-locations.md:57-66`: Solidity mapping-location definition.
- `schedule.md:256-266,301-326,354-359`: fork flags and gas-price changes.

`semantics-excerpts.json` retains the exact inspected excerpts and source-file
hashes. `balanceOf-disassembly.txt` records the relevant runtime instructions.
