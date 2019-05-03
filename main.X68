*-----------------------------------------------------------
* Title      : Main class
* Written by : Thomas Hedrick
* Date       : 5/2/19
* Description: calls upon other classes
*-----------------------------------------------------------
         INCLUDE tests.x68      ;loads in tests
         INCLUDE moveDecoder.x68    ;loads in moveDecoder
START         ORG    $1000 
        
* Put program code here
        
STARTP      MOVE.W   TESTCASES,COUNTER
            MOVE.W  #$6000,MEMLOC       ;sets memory location of tests
            
T_LOOP      MOVE.W  MEMLOC,A2
            JMP     STARTMOVE           ;Starts moveDecoder

INC         JSR    CLEAR                
            MOVE.L D0,A7
            SUB    #1,COUNTER
            BNE    T_LOOP
            BRA    EXIT

CLEAR   CLR.L  D0           ;clears out D0-D7 and A0-D6. A7 is used to get back with rts can't reset here
        CLR.L  D2
        CLR.L  D3
        CLR.L  D4
        CLR.L  D5
        CLR.L  D6
        CLR.L  D7
        
        MOVE.L D0,A0
        MOVE.L D0,A1
        MOVE.L D0,A2
        MOVE.L D0,A3
        MOVE.L D0,A4
        MOVE.L D0,A5
        MOVE.L D0,A6
        RTS
        
EXIT     


* Put variables and constants here
COUNTER    DS.B     1
MEMLOC     DS.W     1
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
