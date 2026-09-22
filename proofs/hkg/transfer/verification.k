requires "edsl.md"
requires "lemmas/lemmas.k"

module VERIFICATION-SUMMARIES
  imports EDSL
endmodule

module VERIFICATION
  imports VERIFICATION-SUMMARIES
  imports LEMMAS
endmodule
