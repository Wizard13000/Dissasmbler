*-----------------------------------------------------------
* Program    :Hello World
* Written by :Iris Favoreal
* Date       :4/10/19
* Description:Sample Program 1 for 422 Lab 1
*-----------------------------------------------------------
CR      EQU    $0D
LF      EQU    $0A

START   ORG    $1000

INIT    LEA    WELCOME, A1
        MOVE.B #14,D0
        TRAP   #15

LOOP    LEA    START_ADDY, A1
        MOVE.B #14,D0
        TRAP   #15

        MOVE.B #4,D0
        TRAP   #15
        CMP.L  #0,D1
        BEQ    DONE
        
        LEA    END_ADDY, A1
        MOVE.B #14,D0
        TRAP   #15
        
        MOVE.B #4,D0
        TRAP   #15
        CMP.L  #0,D1
        BEQ    DONE
        
        ; purpose:
        ; placeholder for input validation
        ;CMP.B  #20,D1
        ;BLT    INVALID
        ;CMP.B  #25,D1
        ;BGT    INVALID
        BRA    EXEC

EXEC    LEA    GO, A1
        MOVE.B #14,D0
        TRAP   #15
        BRA    DONE

INVALID LEA    INV,A1
        MOVE.B #14,D0
        TRAP   #15
        BRA    LOOP
        
        ; purpose:
        ; branch for exiting program when done
DONE    LEA    GOODBYE, A1
        MOVE.B #14,D0
        TRAP   #15
        MOVE.B #9,D0
        TRAP   #15
        
        
WELCOME     DC.B   'Welcome.',CR,LF,0
GOODBYE     DC.B   'Program exiting. Goodbye.',CR,LF,0
START_ADDY  DC.B   'Enter starting hex address or 0 to exit: ',0
END_ADDY    DC.B   'Enter ending hex address or 0 to exit: ',0
GO          DC.B   'This is where program execution begins.',CR,LF,0
INV         DC.B   'Placeholder warning',CR,LF,0
            END     START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
