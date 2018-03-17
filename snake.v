module snake(segA, segB, segC, segD, segE, segF, segG, segDP);
output segA, segB, segC, segD, segE, segF, segG, segDP;

  reg field [0:6] [0:20];		 //Game field
  reg [7:0] posx;					 //Current X position of head
  reg [7:0] posy;					 //Current Y position of head
  reg [1:0] bt0 = 1'b0;		   		 //Button
  reg [7:0] arr [0:7] [0:1];		 //Positions of all segments of snake
  reg refresh = 1'b1;				 //Refresh trigger
  reg [1:0] lastDirection = 2'b01;   //Last direction of head of snake
  reg [2:0] turn = 2'b00;
  reg stepForward;		 //Trigger for next frame move
  reg checkError = 1'b0;			//Trigger for checking is game is over
  
  always @(turn)  // Simulates push on "turn" buttons
    begin
		if (turn == 2'b01) begin
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
              field[posy][posx] = 1'b0;
            end
            2'b10:begin
              posx = posx - 8'd1;
              posy = posy + 8'd1;
              field[posy][posx] = 1'b0;
            end
            2'b00:begin
              posx = posx + 8'd1;
              posy = posy - 8'd1;
              field[posy][posx] = 1'b0;
            end
            2'b11:begin
              posx = posx - 8'd1;
              posy = posy - 8'd1;
              field[posy][posx] = 1'b0;
            end
          endcase
          lastDirection = lastDirection + 2'b01;
        end
      
      else if (turn == 2'b10) begin
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
              field[posy][posx] = 1'b0;
            end
            2'b10:begin
              posx = posx + 8'd1;
              posy = posy + 8'd1;
              field[posy][posx] = 1'b0;
              
            end
            2'b00:begin
              posx = posx - 8'd1;
              posy = posy - 8'd1;
              field[posy][posx] = 1'b0;
            end
            2'b11:begin
              posx = posx - 8'd1;
              posy = posy + 8'd1;
              field[posy][posx] = 1'b0;
            end
          endcase
        lastDirection = lastDirection - 2'b01;
      end
	 end
  
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
      
    end
  
  always @(checkError)
    begin
      
    end
  
  always @(stepForward)  // Draw next frame - will be executed every X seconds (by CLK)
    begin
      case(lastDirection)
        2'b00: begin
          posy = posy + 8'd2;
          field[posy][posx] = 1'd0;  
        end
        2'b01: begin
		  posx = posx + 8'd3;
          field[posy][posx] = 1'd0;  
        end
        2'b10: begin
		  posy = posy + 8'd2;
          field[posy][posx] = 1'd0;  
        end
		2'b11: begin
		  posx = posx - 8'd3;
          field[posy][posx] = 1'd0;  
        end
      default: lastDirection = 2'b01;
      endcase
    end
  
  initial begin  // Main Snake logic (Now it is here just for debug)
  #1 field[1][2] = 1'b0;
  #1 posx = 8'd2;
  #1 posy = 8'd1;
  #1 refresh = ~refresh;
    
  #1 turn = 1'b1;
  #1 turn = 1'b0;
  #1 refresh = ~refresh;
    
  #1 turn = 1'b1;
  #1 turn = 1'b0;
  #1 refresh = ~refresh;
    
  #1 turn = 2'b10;
  #1 turn = 1'b0;
  #1 refresh = ~refresh;
    
  #1 turn = 2'b10;
  #1 turn = 1'b0;
  #1 refresh = ~refresh;
    
  #1 turn = 2'b10;
  #1 turn = 1'b0;
  #1 refresh = ~refresh;
    
  #1 turn = 2'b01;
  #1 turn = 1'b0;
  #1 refresh = ~refresh;

end


endmodule          


