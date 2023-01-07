// 32X32 Multiplier FSM
module mult32x32_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

	typedef enum { A, B, C, D, E, F, G, H, I } sm_type;
	sm_type current_state;
	sm_type next_state;
	alway_ff @(posedge clk, posedge reset) begin
		if (reset == 1'b1) begin
			current_state <= A; //Might need to add A's output here, or make an if inside A that deals with receiving (1, 1)
		end
		else begin
			current_state <= next_state;
		end
	always_comb begin
		next_state = current_state;
		busy = 1'b0;
		a_sel = 2'd0;
		b_sel = 1'b0;
		shift_sel = 3'd0;
		upd_prod = 1'b0;
		clr_prod = 1'b0;
		case (current_state)
			A: begin
				if (start == 1'b1) begin
					next_state = B;
					busy = 1'b1;
					upd_prod = 1'b1;
					clr_prod = 1'b1;
				end
			end
			B: begin
				next_state = C;
				busy = 1'b1;
				a_sel = 2'd1;
				shift_sel = 3'd1;
				upd_prod = 1'b1;
			end
			C: begin
				next_state = D;
				busy = 1'b1;
				a_sel = 2'd2;
				shift_sel = 3'd2;
				upd_prod = 1'b1;
			end
			D: begin
				next_state = E;
				busy = 1'b1;
				a_sel = 2'd3;
				shift_sel = 3'd3;
				upd_prod = 1'b1;
			end
			E: begin
				next_state = F;
				busy = 1'b1;
				a_sel = 2'd0;
				b_sel = 1'b1;
				shift_sel = 3'd2;
				upd_prod = 1'b1;
			end
			F: begin
				next_state = G;
				busy = 1'b1;
				a_sel = 2'd1;
				b_sel = 1'b1;
				shift_sel = 3'd3;
				upd_prod = 1'b1;
			end
			G: begin
				next_state = H;
				busy = 1'b1;
				a_sel = 2'd2;
				b_sel = 1'b1;
				shift_sel = 3'd4;
				upd_prod = 1'b1;
			end
			H: begin
				next_state = I;
				busy = 1'b1;
				a_sel = 2'd3;
				b_sel = 1'b1;
				shift_sel = 3'd5;
				upd_prod = 1'b1;
			end
			I: begin
				next_state = A;
				upd_prod = 1'b1;
			end
		endcase
	end
endmodule
