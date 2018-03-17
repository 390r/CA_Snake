module snake(segA, segB, segC, segD, segE, segF, segG, segDP);
output segA, segB, segC, segD, segE, segF, segG, segDP;

  reg [1:0] field [0:7] [0:7];		 //Game field
  reg [7:0] posx;					 //Current X position of head
  reg [7:0] posy;					 //Current Y position of head
  reg [1:0] bt0 = 1'b0;		   		 //Button
  reg [7:0] arr [0:7] [0:1];		 //Positions of all segments of snake
  reg [1:0] refresh;				 //Refresh trigger
  reg [2:0] lastDirection = 2'b01;  //Last direction of head of snake
  reg [2:0] turn1 = 2'b00;
  reg [1:0] stepForward = 1'b0;		 //Trigger for next frame move
  
  always @(refresh)
    begin
      integer i = 0;
      integer k = 0;
      $write("\n");
      
      for (k=0; k<=7; k = k+1) begin
        for (i=0; i<7; i = i+1) begin
          $write(field[k][i], " ");
        end
          $write("\n");
      end
      
    end
  
  always @(stepForward)
    begin
      case(lastDirection)
        2'b00: begin
          posy = posy - 1;
		  field[posy][posx] = 1'b0;
        end
		2'b01: begin
		  posx = posx + 1;
		  field[posy][posx] = 1'b0;
        end
        2'b10: begin
          posy = posy + 1;
		  field[posy][posx] = 1'b0;
        end
		2'b11: begin
		  posx = posx - 1;
		  field[posy][posx] = 1'b0;
        end
      default: lastDirection = 2'b01;
      endcase
    end
  
initial begin
  #1 refresh = 1'b1;
  #1 field[0][0] = 1'b0;
  posx = 1'd0;
  posy = 1'd0;
 
  #1 refresh = 1'b0;
  #1 stepForward = 1'b1;
  #1 refresh = 1'b1;
 
end


endmodule


