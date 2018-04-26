module snake(input btL, btR, clk, sw1, speedSw, output seg1A, seg1B, seg1C, seg1D, seg1E, seg1F, seg1G, seg1DP,
                   seg2A, seg2B, seg2C, seg2D, seg2E, seg2F, seg2G, seg2DP,
                   seg3A, seg3B, seg3C, seg3D, seg3E, seg3F, seg3G, seg3DP,
                   seg4A, seg4B, seg4C, seg4D, seg4E, seg4F, seg4G, seg4DP,
                   seg5A, seg5B, seg5C, seg5D, seg5E, seg5F, seg5G, seg5DP,
                   seg6A, seg6B, seg6C, seg6D, seg6E, seg6F, seg6G, seg6DP, speaker);
// Game field representation
 //Game field itself - 2D array
 reg field [0:6] [0:20];

 // These registers are used to translate game field view to7-segments displays
 reg [0:7] showField1 = 8'b11111101; reg [0:7] showField2 = 8'b11110111; reg [0:7] showField3 = 8'b11011111; 
 reg [0:7] showField4 = 8'b11111011; reg [0:7] showField5 = 8'b11101111; reg [0:7] showField6 = 8'b10111111; 

// EVENT TRIGGERS:
 // Turn triggers
 reg turnleft = 1'b0;
 reg turnright = 1'b0;
 // Hold one of 4 values - direction on previous step
 reg [1:0] lastDirection = 2'b01;
 // Game over hundler
 reg gameOver = 1'b0;
 // CLK divider - can make gave twice faster
 reg [1:0]speed = 1'b1;
 reg applePicked = 1'b0;
 reg appleDot[5:0];
 reg [2:0] currentApple;
 reg [5:0] random;
 reg [2:0] randomHelper = 1'b1;
 // Triggers the Speaker module if it needed
 reg speakerCall = 1'b0;
 // Specify which sound Sound module must play
 reg [1:0] soundCode = 2'b01;

// NextStep triggers
 reg drawFrame = 1'b0;
 // Transtates 2D array to six 7-segment displays
 reg refresh = 1'b0;
 // Restart the game
 reg reset = 1'b1;

// N parameter sets the wisth of CLK divider register. wider - slower.
parameter N = 25;
reg [N-1:0] slow_clk = 0;

// Snake representation
 // This array holds the position of each segment of the snake (x and y coordinates)
 integer snakePos[0:10][0:1];
 // Pointers - see "snake representation" in documentation
 integer headPointer = 1;
 integer tailPointer = 0;
 // System variables
 integer prevX;
 integer prevY;
 integer lastX;
 integer lastY;

// Initialization of Piezo module, now it can be triggered using speakerCall register
 piezo beep(clk, speakerCall, soundCode, speaker);

// Assigning our cells in 7-segment displays to Game filed cells
 assign {seg1A, seg1B, seg1C, seg1D, seg1E, seg1F, seg1G, seg1DP} = showField1;
 assign {seg2A, seg2B, seg2C, seg2D, seg2E, seg2F, seg2G, seg2DP} = showField2;
 assign {seg3A, seg3B, seg3C, seg3D, seg3E, seg3F, seg3G, seg3DP} = showField3;
 assign {seg4A, seg4B, seg4C, seg4D, seg4E, seg4F, seg4G, seg4DP} = showField4;
 assign {seg5A, seg5B, seg5C, seg5D, seg5E, seg5F, seg5G, seg5DP} = showField5;
 assign {seg6A, seg6B, seg6C, seg6D, seg6E, seg6F, seg6G, seg6DP} = showField6;

 // Simple CLK divider
 always @ (posedge clk) begin
	slow_clk <= slow_clk + speed;
	random = random + slow_clk[20];
 end
 
 // Make next frape on every CLK divider overflow
 always @ (posedge slow_clk[N-1])
   drawFrame = ~drawFrame;

 // Refresh frame - rebuild/refresh image drawn on 7-segment display
 // Now it first erases all information from displays and then redraws new information
 // But it can be easily redesigned and it will do this refresh operation just in two steps,
 always @ (refresh) begin
 integer i = 0;
 integer j = 0;
 if (gameOver) begin
  for (i = 0; i<7; i = i+1)
    for (j = 0; j<21; j = j+1)
     field[i][j] = 1'b0;
 end else begin
  for (i = 0; i<7; i = i+1)
   for (j = 0; j<21; j = j+1)
    field[i][j] = 1'b1;

  if (headPointer>tailPointer)begin
   for (i=0; i<=10; i= i+1)
    if (i<=headPointer & i>=tailPointer)
     field[snakePos[i][0]][snakePos[i][1]] = 1'b0;
  end else begin
   for (i=0; i<=10; i= i+1)
    if (i>=tailPointer)
     field[snakePos[i][0]][snakePos[i][1]] = 1'b0;
     
   for (i=0; i<=10; i= i+1)
    if (i<=headPointer)
     field[snakePos[i][0]][snakePos[i][1]] = 1'b0;
  end
 end
 showField1 = {field[1][ 2], field[2][ 3], field[4][ 3], field[5] [2], field[4][ 1], field[2][ 1], field[3][ 2], appleDot[0]};
 showField2 = {field[1][ 5], field[2][ 6], field[4][ 6], field[5] [5], field[4][ 4], field[2][ 4], field[3][ 5], appleDot[1]};
 showField3 = {field[1][ 8], field[2][ 9], field[4][ 9], field[5] [8], field[4][ 7], field[2][ 7], field[3][ 8], appleDot[2]};
 showField4 = {field[1][11], field[2][12], field[4][12], field[5][11], field[4][10], field[2][10], field[3][11], appleDot[3]};
 showField5 = {field[1][14], field[2][15], field[4][15], field[5][14], field[4][13], field[2][13], field[3][14], appleDot[4]};
 showField6 = {field[1][17], field[2][18], field[4][18], field[5][17], field[4][16], field[2][16], field[3][17], appleDot[5]};
 end
   
// Main game logic. This block decides how to do next step, depending on sevetal parameters and states.
 always @ (posedge drawFrame) begin
 integer i=0;
  
  // If Reset Game Switch is triggered - hold all registers in the initial state.
  if (sw1 == 1'b0) begin
 snakePos[0][0] = 1;
 snakePos[0][1] = 2;
 
 snakePos[1][0] = 1;
 snakePos[1][1] = 5;
 
 snakePos[2][0] = 1;

 snakePos[2][1] = 8;
 
 for (i = 0; i<6; i = i+1)
  appleDot[i] = 1'b1;
  
 currentApple = 2;
 appleDot[currentApple] = 1'b0;

 
 headPointer = 2;
 tailPointer = 0;
 lastDirection = 2'b01;
 gameOver = 1'b0;
 refresh = ~refresh;
  end 
  // If GameOver register was triggered - play Imperial march (soundcode 0) and just refresh the frame: everything else will be done by Refresh block.
  else if (gameOver == 1'b1) begin
   refresh = ~refresh;
   soundCode = 0;
  end
  else begin
 prevY = snakePos[headPointer][0];
 prevX = snakePos[headPointer][1];
 lastY = snakePos[headPointer][0];
 lastX = snakePos[headPointer][1];
 
 if (headPointer == 10) headPointer = 0;
 else headPointer = headPointer + 1;
 
 if (tailPointer == 10) tailPointer = 0;
 else tailPointer = tailPointer + 1;
    
 if (turnright == 1'b1) begin
      if (prevX%3 == 0 && lastDirection == 2'b00)
        prevX = prevX + 1'd1;
      else if(prevX%3 == 1 && lastDirection == 2'b10)
        prevX = prevX - 1'd1;
      case(lastDirection)
        2'b01:begin
          prevX = prevX + 1'd1;
          prevY = prevY + 1'd1;
        end
        2'b10:begin
          prevX = prevX - 1'd1;
          prevY = prevY + 1'd1;
        end
        2'b00:begin
          prevX = prevX + 1'd1;
          prevY = prevY - 1'd1;
        end
        2'b11:begin
          prevX = prevX - 1'd1;
          prevY = prevY - 1'd1;
        end
      endcase
      lastDirection = lastDirection + 2'b01;
 end else
 if (turnleft == 1'b1) begin
      if (prevX%3 == 0 && lastDirection == 2'b10) begin
            prevX = prevX + 1'd1;
        end 
        else if (prevX%3 == 1 && lastDirection == 2'b00) begin
          prevX = prevX - 1'd1;
        end
        
        case(lastDirection)
            2'b01:begin
      prevX = prevX + 1'd1;
              prevY = prevY - 1'd1;
            end
            2'b10:begin
              prevX = prevX + 1'd1;
              prevY = prevY + 1'd1;
              
            end
            2'b00:begin
              prevX = prevX - 1'd1;
              prevY = prevY - 1'd1;
            end
            2'b11:begin
              prevX = prevX - 1'd1;
              prevY = prevY + 1'd1;
            end
          endcase
    
    if (field[prevY][prevX] == 1'b0) begin
  gameOver = 1'b1;
  soundCode = 0;
  end

    lastDirection = lastDirection - 2'b01;
 end else 
 begin
      case (lastDirection)
        2'b01: prevX = prevX + 2'd3;
        2'b11: prevX = prevX - 2'd3;
        2'b00: prevY = prevY - 2'd2;
        2'b10: prevY = prevY + 2'd2;
   endcase
 end
 if (lastY == 5)
  if ((lastX == 3*(currentApple+1)-1 && prevX == 3*(currentApple+1)+2) || (prevX == 3*(currentApple+1)-1 && lastX == 3*(currentApple+1)+2)) begin
   applePicked = 1'b1;
   soundCode = 2'b10;
   tailPointer = tailPointer - 1;
  end
  
 if (lastY == 4 && lastDirection == 2'b10)
  if ((lastX == 3*(currentApple+1)+1 && prevX == 3*(currentApple+1)-1) || (lastX == 3*(currentApple+1) && prevX == 3*(currentApple+1)+2)) begin
   applePicked = 1'b1;
   soundCode = 2'b10;
   tailPointer = tailPointer - 1;
  end
  
// If an apple was picked - play sound with soundcode 1 and increase the length of the snake
 if (applePicked == 1'b1) begin
  for (i = 0; i<6; i = i+1)
	appleDot[i] = 1'b1;
  currentApple = (currentApple - 2) % 4;
  appleDot[currentApple] = 1'b0;
  applePicked = 1'b0;
 end
  soundCode = 1'b1;
  speakerCall = ~speakerCall;
  
  if (field[prevY][prevX] == 1'b0) begin
   gameOver = 1'b1;
   soundCode = 0;
  end
  
    snakePos[headPointer][0] = prevY;
    snakePos[headPointer][1] = prevX;
    refresh = ~refresh;
  end
  
 end

 always @ (btL)
 turnleft = ~btL;

 always @ (btR)
 turnright = ~btR;
 
 always @ (speedSw) begin
 if (speedSw == 1'b1)speed = 2'b10;
 else
  speed = 1'b1;
 end


initial begin
 
 integer i = 0;
 integer j = 0;
 
   
 for (i = 0; i<7; i = i+1)
  for (j = 0; j<21; j = j+1)
   field[i][j] = 1'b1;
   
 for (i = 0; i<6; i = i+1)
  appleDot[i] = 1'b1;
  
 
  
 
end

endmodule