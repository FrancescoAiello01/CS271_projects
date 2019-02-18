// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed.
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

(LOOP)
  //Keyboard value
  @KBD
  D=M

  //Black if greater than 0
  @BLACK
  D;JGT

  //White otherwise
  @WHITE
  0;JMP

//Set screen to black and draw
(BLACK)
  @R0
  M=-1
  @DRAW
  0;JMP

//Or set screen to white and draw
(WHITE)
  @R0
  M=0
  @DRAW
  0;JMP

//Sets screen to R0 and loops
(DRAW)
  @8191
  D=A
  @R1 //counter
  M=D

    (DRAWLOOP)
    @R1
    D=M
    @currentpos
    M=D
    @SCREEN
    D=A
    @currentpos
    M=M+D

    //Draw
    @R0
    D=M
    @currentpos
    A=M
    M=D

    //Reduce count
    @R1
    D=M-1
    M=D

    //Loop if counter >= 0
    @DRAWLOOP
    D;JGE

  //Loop back to start
  @LOOP
  0;JMP
