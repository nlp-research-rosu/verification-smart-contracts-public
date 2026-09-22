"use strict";

const cases = [
  ["zero", 0n],
  ["owner-low-bit", 1n],
  ["stopped-one", 1n << 160n],
  ["stopped-255", 255n << 160n],
  ["owner-plus-stopped-seven", 123456789n + (7n << 160n)],
];

for (const [name, word] of cases) {
  const extractedByte = Number((word >> 160n) & 255n);
  const stoppedClear = extractedByte === 0;
  process.stdout.write(`${name}: byte=${extractedByte}, clear=${stoppedClear}\n`);
}
