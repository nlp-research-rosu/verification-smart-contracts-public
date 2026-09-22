requires "edsl.md"

module AUDIT-MUTATED-BYTECODE
  imports EDSL

  // Fresh A1 probe: replace the actual program term with a one-byte STOP body.
  syntax Bytes ::= "AUDIT_MUTATED_RUNTIME" [function]
  rule AUDIT_MUTATED_RUNTIME => #parseByteStack("0x00")
endmodule
