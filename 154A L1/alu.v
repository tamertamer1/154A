module alu(input [31:0] a, b,	input [2:0] f,
	output [31:0] result,
	output zero,
	output overflow,
	output carry,
	output negative);

	wire [31:0] adder;
	wire [31:0] and_res;
	wire [31:0] or_res;
	wire [31:0] slt_res;
	wire car;
	reg [31:0] b_wire;
	always @(*) begin
		case (f)
			3'b000:  b_wire = b;
			3'b001:  b_wire = ~b+f[0];
			3'b101:  b_wire = ~b+f[0];
			default: b_wire = b;
		endcase
	end
	assign {car,adder} = a + (b_wire);
	assign and_res = a & b;
	assign or_res = a | b;

	assign negative = result[31];
	assign zero = (~result[0] & ~result[1] & ~result[2] & ~result[3] & ~result[4] & ~result[5] & ~result[6] & ~result[7] &
   		~result[8] & ~result[9] & ~result[10] & ~result[11] & ~result[12] & ~result[13] & ~result[14] & ~result[15] &
   		~result[16] & ~result[17] & ~result[18] & ~result[19] & ~result[20] & ~result[21] & ~result[22] & ~result[23] &
   		~result[24] & ~result[25] & ~result[26] & ~result[27] & ~result[28] & ~result[29] & ~result[30] & ~result[31]);
	assign carry = (car& ~f[1]);
	assign overflow = ((~f[1]) & (adder[31] ^ a[31]) & ~(a[31] ^ b[31] ^ f[0]));
	assign slt_res = (overflow ^ adder[31]);
	assign result = (f == 3'b000) ? adder:
                 	(f == 3'b001) ? adder:
                 	(f == 3'b010) ? and_res:
                 	(f == 3'b011) ? or_res :
                 	(f == 3'b101) ? slt_res : 32'b0;
endmodule



