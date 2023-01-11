// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic a_msb_is_0,       // Indicates MSB of operand A is 0
    input logic b_msw_is_0,       // Indicates MSW of operand B is 0
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

typedef enum { Idle, FirstByte1b, SecondByte1b, ThirdByte1b, FourthByte1b, FirstByte2b, SecondByte2b, ThirdByte2b, FourthByte2b } sm_type;
	sm_type current_state;
	sm_type next_state;
	always_ff @(posedge clk, posedge reset) begin
		if (reset == 1'b1) begin
			current_state <= Idle; //Might need to add Idle's output here, or make an if inside Idle that deals with receiving (1, 1)
		end
		else begin
			current_state <= next_state;
		end
	end
	always_comb begin
		next_state = current_state;
		busy = 1'b0;
		a_sel = 2'd0;
		b_sel = 1'b0;
		shift_sel = 3'd0;
		upd_prod = 1'b1;
		clr_prod = 1'b0;
		case (current_state)
			Idle: begin
				if (start == 1'b1) begin
					next_state = FirstByte1b;
					clr_prod = 1'b1;
				end
				else begin
					upd_prod = 0;
				end
			end
			FirstByte1b: begin
				next_state = SecondByte1b;
				busy = 1'b1;
			end
			SecondByte1b: begin
				next_state = ThirdByte1b;
				busy = 1'b1;
				a_sel= 2'd1;
				shift_sel = 3'd1;
			end
			ThirdByte1b: begin
				if (a_msb_is_0 == 1 && b_msw_is_0 == 1) begin
					next_state = Idle;
				end
				else if (a_msb_is_0 == 1) begin
					next_state = FirstByte2b;
				end
				else begin
					next_state = FourthByte1b;
				end
				busy = 1'b1;
				a_sel = 2'd2;
				shift_sel = 3'd2;
			end
			FourthByte1b: begin
				if (b_msw_is_0 == 1) begin
					next_state = Idle;
				end
				else begin
					next_state = FirstByte2b;
				end
				busy = 1'b1;
				a_sel = 2'd3;
				shift_sel = 3'd3;
			end
			FirstByte2b: begin
				next_state = SecondByte2b;
				busy = 1'b1;
				b_sel = 1'd1;
				shift_sel = 3'd2;
			end
			SecondByte2b: begin
				next_state = ThirdByte2b;
				busy = 1'b1;
				a_sel = 2'd1;
				b_sel = 1'b1;
				shift_sel = 3'd3;
			end
			ThirdByte2b: begin
				if (a_msb_is_0 == 1) begin
					next_state = Idle;
				end
				else begin
					next_state = FourthByte2b;
				end
				busy = 1'b1;
				a_sel = 2'd2;
				b_sel = 1'b1;
				shift_sel = 3'd4;
			end
			FourthByte2b: begin
				next_state = Idle;
				a_sel = 2'd3;
				b_sel = 1'b1;
				shift_sel = 3'd5;
				busy = 1'b1;
			end
		endcase
	end
endmodule
