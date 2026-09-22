requires "edsl.md"
requires "lemmas/lemmas.k"
requires "helpers/hkg-bytecode.k"

module VERIFICATION-SUMMARIES
  imports HKG-BYTECODE
endmodule

module VERIFICATION
  imports VERIFICATION-SUMMARIES
  imports LEMMAS
endmodule
