requires "edsl.md"
requires "lemmas/lemmas.k"
requires "runtime.k"

module VERIFICATION-SUMMARIES
  imports DSTOKEN-RUNTIME
endmodule

module VERIFICATION
  imports VERIFICATION-SUMMARIES
  imports EDSL-SUMMARY
  imports LEMMAS
endmodule
