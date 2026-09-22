requires "edsl.md"
requires "lemmas/lemmas.k"
requires "dstoken-bin.k"

module VERIFICATION-SUMMARIES
  imports DSTOKEN-BIN
endmodule

module VERIFICATION
  imports VERIFICATION-SUMMARIES
  imports EDSL
  imports LEMMAS
endmodule
