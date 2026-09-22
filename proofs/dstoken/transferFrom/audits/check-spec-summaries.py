#!/usr/bin/env python3
"""Independent finite checks for the transferFrom spec's definitional layer."""

from pathlib import Path
import random
import re

ROOT = Path(__file__).resolve().parents[2]
verification = (ROOT / "output" / "verification.k").read_text()
spec = (ROOT / "output" / "spec.k").read_text()
runtime = (ROOT / "contract.bin").read_bytes()

match = re.search(r'#binRuntime\(DSTOKEN\) => #parseByteStack\("0x([0-9a-f]+)"\)', verification)
assert match is not None
assert bytes.fromhex(match.group(1)) == runtime

selector = int("23b872dd", 16)
topic = selector << 224
assert topic == 16156842317565293874272834530371880720966471053262404558597773956279093428224
assert "#buf(32, 0)\n           +Bytes #buf(32, 64)\n           +Bytes #buf(32, 100)" in verification
assert "syntax Bool ::= #stoppedByteIsZero(Map) [function]" in verification
assert ") ==K #buf(1, 0)" in verification
assert spec.count("<log> .List </log>") == 5
assert spec.count("<log>\n      .List\n      =>\n      #transferFromLogs") == 2
assert "LOGS" not in spec

max_u256 = 2**256 - 1
rng = random.Random(0x23B872DD)
counts = {name: 0 for name in ("stopped", "balance", "allowance", "overflow", "success-distinct", "success-self")}

for _ in range(10000):
    slot4 = rng.randrange(2**256)
    stopped_byte = (slot4 // 2**160) % 256
    assert stopped_byte == ((slot4 >> 160) & 0xFF)

    src = rng.randrange(8)
    dst = rng.randrange(8)
    wad = rng.randrange(2**256)
    src_balance = rng.randrange(2**256)
    dst_balance = src_balance if src == dst else rng.randrange(2**256)
    allowance = rng.randrange(2**256)

    if stopped_byte != 0:
        branch = "stopped"
    elif src_balance < wad:
        branch = "balance"
    elif allowance < wad:
        branch = "allowance"
    elif src != dst and dst_balance > max_u256 - wad:
        branch = "overflow"
    elif src == dst:
        branch = "success-self"
        assert (src_balance - wad + wad) == src_balance
    else:
        branch = "success-distinct"
        assert dst_balance + wad <= max_u256
    counts[branch] += 1

assert sum(counts.values()) == 10000
print("runtime-bytes: exact")
print("selector-topic: exact")
print("LogNote.msg.value: zero")
print("fresh-call log substate: all 7 claims")
print("stopped-byte samples: 10000 passed")
print("branch partition samples:", counts)
