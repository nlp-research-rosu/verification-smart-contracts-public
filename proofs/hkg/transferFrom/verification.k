requires "hkg-bin-runtime.k"
requires "lemmas/lemmas.k"

module VERIFICATION-SUMMARIES
  imports HKG-BIN-RUNTIME
endmodule

module VERIFICATION
  imports VERIFICATION-SUMMARIES
  imports LEMMAS
endmodule
