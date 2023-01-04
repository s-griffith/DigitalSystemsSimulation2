// 32X32 Multiplier arithmetic unit template
module mult32x32_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic [63:0] product  // Miltiplication product
);
	logic [7:0] mux4ToMult;
	logic [15:0] mux2ToMult;
	logic [23:0] multToShifter;
	logic [63:0] shifterToAdder;
	always_comb begin 
		case (a_sel)
			{1'b0, 1'b0}: begin
				mux4ToMult = a[7:0];
			end
			{1'b0, 1'b1}: begin
				mux4ToMult = a[15:8];
			end
			{1'b1, 1'b0}: begin
				mux4ToMult = a[23:16];
			end
			{1'b1, 1'b1}: begin
				mux4ToMult = a[31:24];
			end
		endcase
		if (b_sel == 1'b0 begin
			mux2ToMult = b[15:0];
		end
		else begin
			mux2ToMult = a[31:16];
		end
		assign multToShifter = mux2ToMult * mux4ToMult;
		case (shift_sel)
			{1'b0,1'b0,1'b0}: begin
				shifterToAdder = {64{1'b0}};
				shifterToAdder[23:0] = multToShifter;
			end
			{1'b0,1'b0,1'b1}: begin
				shifterToAdder = {64{1'b0}};
				shifterToAdder[23:0] = multToShifter;
			end
			
endmodule
