// 32X32 Multiplier test template
module mult32x32_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

mult32x32 multUnit (
	.clk(clk),
	.reset(reset),
	.a(a),
	.b(b),
	.busy(busy),
	.product(product),
	.start(start)
);
	initial begin
		clk = 1'b0;
		@(posedge clk);
		reset = 1'b1;
		start = 1'b0;
		repeat (4) begin
			@(posedge clk);
		end
		reset = 1'b0;
		a = 64'd207223066;
		b = 64'd341312304;
		@(posedge clk);
		start = 1'b1;
		@(posedge clk);
		start = 1'b0;
		@(negedge busy);
	end
	always begin
		#10
		clk = ~clk;
	end
endmodule
