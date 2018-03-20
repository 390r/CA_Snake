module snake(input clk, bt0, bt1,output seg1A, seg1B, seg1C, seg1D, seg1E, seg1F, seg1G, seg1DP, 
													 seg2A, seg2B, seg2C, seg2D, seg2E, seg2F, seg2G, seg2DP,
													 seg3A, seg3B, seg3C, seg3D, seg3E, seg3F, seg3G, seg3DP,
													 seg4A, seg4B, seg4C, seg4D, seg4E, seg4F, seg4G, seg4DP,
													 seg5A, seg5B, seg5C, seg5D, seg5E, seg5F, seg5G, seg5DP,
													 seg6A, seg6B, seg6C, seg6D, seg6E, seg6F, seg6G, seg6DP);

  reg field [0:6] [0:20];   //Game field
  reg [0:7] showField1 = 8'b11111111;	reg [0:7] showField2 = 8'b11111111;	reg [0:7] showField3 = 8'b11111111;
  reg [0:7] showField4 = 8'b11111111;	reg [0:7] showField5 = 8'b11111111;	reg [0:7] showField6 = 8'b11111111;
  reg [7:0] posx;      //Current X position of head
  reg [7:0] posy;      //Current Y position of head
  reg [7:0] arr [0:7] [0:1];   //Positions of all segments of snake
  reg refresh = 1'b1;     //Refresh trigger
  reg [1:0] lastDirection = 2'b10;   //Last direction of head of snake
  reg turnleft = 1'b0;
  reg turnright = 1'b0;
  reg prevRight;
  reg reset;
  reg stepForward;   //Trigger for next frame move
  reg gameOver = 1'b0;   //Trigger for checking is game is over
  reg temp = 1'b0;
  
  parameter N = 25;
  reg [N-1:0] slow_clk = 0;
  reg [7:0] countsec = 0;

  always @ (posedge clk)
  slow_clk <= slow_clk + 1'b1;

  always @ (posedge slow_clk[N-1])
    temp <= ~temp;
  
 always @(refresh)  // Prints field - 7 segments simulation (for debug)
    begin
      integer i = 0;
      integer k = 0;
      $write("\n");
      
      for (k=1; k<=5; k = k+1) begin
        for (i=1; i<19; i = i+1) begin
          if ((i-1)%3 == 0)
            $write("| ");
          $write(field[k][i], " ");
        end
          $write("\n");
      end
   showField1 = {field[1][2], field[2][3], field[4][3], field[5][2], field[4][1], field[2][1], field[3][2], 1'b1};
	showField2 = {field[1][5], field[2][6], field[4][6], field[5][5], field[4][4], field[2][4], field[3][5], 1'b1};
	showField3 = {field[1][8], field[2][9], field[4][9], field[5][8], field[4][7], field[2][7], field[3][8], 1'b1};
	showField4 = {field[1][11], field[2][12], field[4][12], field[5][11], field[4][10], field[2][10], field[3][11], 1'b1};
	showField5 = {field[1][14], field[2][15], field[4][15], field[5][14], field[4][13], field[2][13], field[3][14], 1'b1};
	showField6 = {field[1][17], field[2][18], field[4][18], field[5][17], field[4][16], field[2][16], field[3][17], 1'b1};
      
    end
  
  always @(posedge temp)  // Draw next frame - will be executed every X seconds (by CLK)
    begin
	 if (turnright) begin
          if (posx%3 == 0 && lastDirection == 2'b00) begin
            posx = posx + 8'd1;
          end 
          else if (posx%3 == 1 && lastDirection == 2'b10) begin
            posx = posx - 8'd1;
          end
          case(lastDirection)
            2'b01:begin
              posx = posx + 8'd1;
              posy = posy + 8'd1;
            end
            2'b10:begin
              posx = posx - 8'd1;
              posy = posy + 8'd1;
            end
            2'b00:begin
              posx = posx + 8'd1;
              posy = posy - 8'd1;
            end
            2'b11:begin
              posx = posx - 8'd1;
              posy = posy - 8'd1;
              
            end
          endcase
			 
			 if (field[posy][posx] == 1'b0)
				gameOver = 1'b1;
			 field[posy][posx] = 1'b0;
			 
			 lastDirection = lastDirection + 2'b01;
			 
		  end else if (turnleft) begin
		  if (posx%3 == 0 && lastDirection == 2'b10) begin
            posx = posx + 8'd1;
        end 
        else if (posx%3 == 1 && lastDirection == 2'b00) begin
          posx = posx - 8'd1;
        end
        
        case(lastDirection)
            2'b01:begin
              posx = posx + 8'd1;
              posy = posy - 8'd1;
            end
            2'b10:begin
              posx = posx + 8'd1;
              posy = posy + 8'd1;
              
            end
            2'b00:begin
              posx = posx - 8'd1;
              posy = posy - 8'd1;
            end
            2'b11:begin
              posx = posx - 8'd1;
              posy = posy + 8'd1;
            end
          endcase
			 
			 if (field[posy][posx] == 1'b0)
				gameOver = 1'b1;
				
			 field[posy][posx] = 1'b0;
			 lastDirection = lastDirection - 2'b01;
      end
      else begin
		case(lastDirection)
        2'b00: begin
          posy = posy - 8'd2;
        end
        2'b01: begin
          posx = posx + 8'd3;
        end
        2'b10: begin
          posy = posy + 8'd2;  
        end
        2'b11: begin
          posx = posx - 8'd3;  
        end
      default: lastDirection = 2'b01;
      endcase
		
		if (field[posy][posx] == 1'b0)
			gameOver = 1'b1;
			
		field[posy][posx] = 1'd0;  
		
		end
		
	if (gameOver == 1'b1) begin
	integer i = 0;
	integer j = 0;
	
	for (i = 0; i<7; i = i+1)
		for (j = 0; j<21; j = j+1)
			field[i][j] = 1'b0;
	end else
      #1 refresh = ~refresh;
		
    
      
    end
	 
  always @(bt0)
  begin
		turnright = ~bt0;
		$restart;
  end
  
  always @(bt1)
  begin
		turnleft = ~bt1;
  end

  
  assign {seg1A, seg1B, seg1C, seg1D, seg1E, seg1F, seg1G, seg1DP} = showField1;
  assign {seg2A, seg2B, seg2C, seg2D, seg2E, seg2F, seg2G, seg2DP} = showField2;
  assign {seg3A, seg3B, seg3C, seg3D, seg3E, seg3F, seg3G, seg3DP} = showField3;
  assign {seg4A, seg4B, seg4C, seg4D, seg4E, seg4F, seg4G, seg4DP} = showField4;
  assign {seg5A, seg5B, seg5C, seg5D, seg5E, seg5F, seg5G, seg5DP} = showField5;
  assign {seg6A, seg6B, seg6C, seg6D, seg6E, seg6F, seg6G, seg6DP} = showField6;


  initial begin  // Main Snake logic (Now it is here just for debug)
    
  
  integer i = 0;
  integer j = 0;
  
  for (i = 0; i<7; i = i+1)
      for (j = 0; j<21; j = j+1)
      field[i][j] = 1'b1;

    posy = 8'd0;
	 posx = 8'd3;

end


endmodule