*-----------------------------------------------------------
* Title      : test case simulator
* Written by : Thomas Hedrick
* Date       : 5/2/19
* Description: contains a list of test cases that stores at memory location $6000
*-----------------------------------------------------------
STARTTEST    ORG    $6000

    MOVE.B  D1,D2
    MOVE.W  D1,D2
    MOVE.L  D1,D2
    MOVEA.W A0,A1
    MOVEA.L A0,A1
          
    MOVE.W A0,D1 
    MOVE.W (A0),D1
    MOVE.W (A0)+,D1
    MOVE.W -(A0),D1

    BRA STARTP

TESTCASES    DC.W    9  ;how many test cases there a
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
