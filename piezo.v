// a = 21 = 440.40 Mhz
// f = 17 = 356.52 Mhz
// cH = 25 = 524.28 Mhz
// eH = 31 = 650.12 Mhz
// fH = 33 = 692.06 Mhz
// gS = 20 = 419.43 Mhz

module piezo(input clk, inpCall, input[1:0] soundCode, output speaker, lightl);

reg [20:0] counter;
reg [21:0] nextNote;
reg [6:0] tact = 0;
reg [8:0] clkdivider;
reg prevInp = 1'b0;
reg ended = 1'b0;

always @(posedge nextNote[21]) begin
	case (soundCode)
		0: begin
			case (tact)
			0: clkdivider = 7'd21;
			1: clkdivider = 7'd21;
			2: clkdivider = 7'd21;
			3: clkdivider = 7'd21;
			4: clkdivider = 7'd0;
			5: clkdivider = 7'd0;
			6: clkdivider = 7'd0;
			7: clkdivider = 7'd21;
			8: clkdivider = 7'd21;
			9: clkdivider = 7'd21;
			10: clkdivider = 7'd21;
			11: clkdivider = 7'd0;
			12: clkdivider = 7'd0;
			13: clkdivider = 7'd0;
			14: clkdivider = 7'd21;
			15: clkdivider = 7'd21;
			16: clkdivider = 7'd21;
			17: clkdivider = 7'd21;
			18: clkdivider = 7'd0;
			19: clkdivider = 7'd0;
			20: clkdivider = 7'd0;
			21: clkdivider = 7'd17;
			22: clkdivider = 7'd17;
			23: clkdivider = 7'd17;
			24: clkdivider = 7'd0;
			25: clkdivider = 7'd25;
			26: clkdivider = 7'd25;
			27: clkdivider = 7'd0;
			28: clkdivider = 7'd21;
			29: clkdivider = 7'd21;
			30: clkdivider = 7'd21;
			31: clkdivider = 7'd21;
			32: clkdivider = 7'd0;
			33: clkdivider = 7'd0;
			34: clkdivider = 7'd0;
			35: clkdivider = 7'd17;
			36: clkdivider = 7'd17;
			37: clkdivider = 7'd17;
			38: clkdivider = 7'd0;
			39: clkdivider = 7'd25;
			40: clkdivider = 7'd25;
			41: clkdivider = 7'd0;
			42: clkdivider = 7'd21;
			43: clkdivider = 7'd21;
			44: clkdivider = 7'd21;
			45: clkdivider = 7'd21;
			46: clkdivider = 7'd21;
			47: clkdivider = 7'd0;
			48: clkdivider = 7'd0;
			49: clkdivider = 7'd0;
			50: clkdivider = 7'd31;
			51: clkdivider = 7'd31;
			52: clkdivider = 7'd31;
			53: clkdivider = 7'd31;
			54: clkdivider = 7'd0;
			55: clkdivider = 7'd0;
			56: clkdivider = 7'd0;
			57: clkdivider = 7'd31;
			58: clkdivider = 7'd31;
			59: clkdivider = 7'd31;
			60: clkdivider = 7'd31;
			61: clkdivider = 7'd0;
			62: clkdivider = 7'd0;
			63: clkdivider = 7'd0;
			64: clkdivider = 7'd31;
			65: clkdivider = 7'd31;
			66: clkdivider = 7'd31;
			67: clkdivider = 7'd31;
			68: clkdivider = 7'd0;
			69: clkdivider = 7'd0;
			70: clkdivider = 7'd0;
			71: clkdivider = 7'd33;
			72: clkdivider = 7'd33;
			73: clkdivider = 7'd33;
			74: clkdivider = 7'd0;
			75: clkdivider = 7'd25;
			76: clkdivider = 7'd25;
			77: clkdivider = 7'd0;
			78: clkdivider = 7'd20;
			79: clkdivider = 7'd20;
			80: clkdivider = 7'd20;
			81: clkdivider = 7'd20;
			82: clkdivider = 7'd0;
			83: clkdivider = 7'd17;
			84: clkdivider = 7'd17;
			85: clkdivider = 7'd17;
			86: clkdivider = 7'd0;
			87: clkdivider = 7'd25;
			88: clkdivider = 7'd25;
			89: clkdivider = 7'd0;
			90: clkdivider = 7'd21;
			91: clkdivider = 7'd21;
			92: clkdivider = 7'd21;
			93: clkdivider = 7'd21;
			94: clkdivider = 7'd21;
			95: clkdivider = 7'd21;
			96: clkdivider = 7'd0;
			97: clkdivider = 7'd0;
			98: clkdivider = 7'd0;
			99: clkdivider = 7'd0;
			100: clkdivider = 7'd0;
			101: clkdivider = 7'd0;
			default: clkdivider = 7'd0;
	endcase
	end
	1: begin
		case (tact)
			0: clkdivider = 7'd17;
			1: clkdivider = 7'd17;
			default: clkdivider = 7'd0;
		endcase
	end
	2: begin
		case (tact)
			0: clkdivider = 7'd17;
			1: clkdivider = 7'd17;
			2: clkdivider = 7'd21;
			3: clkdivider = 7'd21;
			4: clkdivider = 7'd0;
			5: clkdivider = 7'd17;
			6: clkdivider = 7'd17;
			7: clkdivider = 7'd21;
			8: clkdivider = 7'd21;
			default: clkdivider = 7'd0;
		endcase		
	end
	endcase
end

always @(posedge clk) begin
	if (~ended || inpCall != prevInp) begin
		prevInp = inpCall;
		ended = 1'b0;
		nextNote = nextNote + 1;
		counter = counter + clkdivider;
	end
	if (nextNote == {21{1'b1}})
		tact = tact + 1;
	if (soundCode == 0 && tact > 101) begin
		tact = 0;
		ended = 1'b1;
	end
	if (soundCode == 1 && tact > 1) begin
		tact = 0;
		ended = 1'b1;
	end
	if (soundCode == 2 && tact > 8) begin
		tact = 0;
		ended = 1'b1;
	end

end

assign speaker = counter[20];

endmodule




