requires "edsl.md"

module VERIFICATION-SUMMARIES
  imports EDSL
  // No candidate-defined function is needed. The success claim relates its
  // existential final-memory variables directly in an `ensures` clause.
endmodule

module VERIFICATION
  imports VERIFICATION-SUMMARIES
  imports EDSL
endmodule
