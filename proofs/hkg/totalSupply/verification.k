requires "edsl.md"

// The claims need no mathematical summary: the requested selector never
// enters a function body. This module is kept separate as required by KIT.
module VERIFICATION-SUMMARIES
  imports EDSL
endmodule

module VERIFICATION
  imports VERIFICATION-SUMMARIES
endmodule
