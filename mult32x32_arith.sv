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
	always_ff @(posedge clk, posedge reset) begin //Product Register
		if (reset == 1'b1) begin
			product <= 64'b0;
		end
		else begin 
			if (clr_prod == 1'b1) begin 
				product <= 64'b0;
			end
			else if (upd_prod == 1'b1) begin
				product <= product + shifterToAdder; //64-bit Adder
			end
		end
	end
	always_comb begin //mux4->1
		case (a_sel)
			2'd0: begin
				mux4ToMult = a[7:0];
			end
			2'd1: begin
				mux4ToMult = a[15:8];
			end
			2'd2: begin
				mux4ToMult = a[23:16];
			end
			2'd3: begin
				mux4ToMult = a[31:24];
			end
		endcase
	end
	always_comb begin //mux2->1
		if (b_sel == 1'b0) begin
			mux2ToMult = b[15:0];
		end
		else begin
			mux2ToMult = b[31:16];
		end
	end
	assign multToShifter = mux2ToMult * mux4ToMult; //16X8 Multiplier
	always_comb begin //mux8->1 + shifter
		case (shift_sel)
			3'd0: shifterToAdder = multToShifter << 0;
			3'd1: shifterToAdder = multToShifter << 8;
			3'd2: shifterToAdder = multToShifter << 16;
			3'd3: shifterToAdder = multToShifter << 24;
			3'd4: shifterToAdder = multToShifter << 32;
			3'd5: shifterToAdder = multToShifter << 40;
			default: shifterToAdder = 64'd0;
		endcase
	end
endmodule