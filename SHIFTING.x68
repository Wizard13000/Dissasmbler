*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
* Put program code here
    MOVE.W  #$A000,MOCKA --Testing address
    MOVE.L  #$E2F85000,(MOCKA)
    ;Check if a member of Arithmetic Shift
    MOVE.W  #$F000,D0
    AND.W   (MOCKA),D0
    CMP.W   #$E000,D0
    BEQ     SHIFT
    
SHIFT
    BRA     LA
BACKSHIFT1
    BRA     DIRC
BACKSHIFT2
    MOVE.W  #$C0,D0
    AND.W   (MOCKA),D0
    CMP.B   #$C0,D0
    BEQ     MEMORYSHIFT
    BRA     SIZE
BACKSHIFT3
    BRA     IR
SHIFTBACK4
    BRA     DEST
BACKSHIFT5
    ADD.W   #16,MOCKA
BACKSHIFT6
    SIMHALT
    
DEST
    LEA     REGMSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  (MOCKA),D1
    AND.W   #7,D1
    MOVE.B  #16,D2
    MOVE.B  #15,D0
    TRAP    #15
    LEA     CPAREN,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA     BACKSHIFT5
    
IR  MOVE.W  #$20,D3
    AND.W   (MOCKA),D3
    CMP.W   #$20,D3
    BEQ     REG
    BRA     IMM
IRBACK
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.W  (MOCKA),D1
    LSR.W   #8,D1
    LSR.W   #1,D1
    AND.W   #7,D1
    MOVE.B  #16,D2
    MOVE.B  #15,D0
    TRAP    #15
    CMP.B   #$20,D3
    BEQ     IMM2  
IRBACK2
    LEA     COMMA,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA     SHIFTBACK4
REG LEA     REGMSG,A1
    BRA     IRBACK

IMM LEA     IMMSG,A1
    BRA     IRBACK
IMM2
    LEA     CPAREN,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA     IRBACK2
    
SIZE
    MOVE.W  #$00C0,D0
    AND.W   (MOCKA),D0
    CMP.W   #$0080,D0
    BEQ     LONG
    MOVE.W  #$0040,D0
    AND.W   (MOCKA),D0
    CMP.W   #$0040,D0
    BEQ     WORD
    BRA     BYTE
SIZEBACK
    MOVE.B  #14,D0
    TRAP    #15
    BRA     BACKSHIFT3
    
BYTE
    LEA     BMSG,A1
    BRA     SIZEBACK

WORD
    LEA     WMSG,A1
    BRA     SIZEBACK
   
LONG
    LEA     LONGMSG,A1
    BRA     SIZEBACK
    
DIRC
    MOVE.W  #$0100,D0
    AND.W   (MOCKA),D0
    CMP.W   #$0100,D0
    BEQ     LEFT
    BNE     RIGHT
BACKD
    MOVE.B  #14,D0
    TRAP    #15
    BRA     BACKSHIFT2
    
LEFT
    LEA     LMSG,A1
    BRA     BACKD
RIGHT
    LEA     RMSG,A1
    BRA     BACKD
    
    
LA  MOVE.W  #8,D0
    AND.W   (MOCKA),D0
    CMP.B   #8,D0
    BEQ     LOGICAL
    BNE     ARITHMETIC
BACKLA
    MOVE.B  #14,D0
    TRAP    #15
    BRA     BACKSHIFT1
LOGICAL
    LEA     LOGICMESG,A1
    BRA     BACKLA
ARITHMETIC
    LEA     ARITHMESG,A1
    BRA     BACKLA

MEMORYSHIFT
    MOVE.B  #14,D0
    LEA     TAB,A1
    TRAP    #15
    MOVE.B  #$38,D0
    AND.W   (MOCKA),D0
    CMP.B   #$38,D0
    BEQ     ABSOLUTE
    MOVE.W  #$10,D0
    AND.W   (MOCKA),D0
    CMP.W   #$20,D0
    BEQ     PREDEC
BMS LEA     OPAREN,A1 --Open Paranthese
    MOVE.B  #14,D0
    TRAP    #15
    BRA     BMS  
    MOVE.B  #7,D1  --Number Calculations
    AND.W   (MOCKA),D1
    MOVE.B  #16,D2
    MOVE.B  #15,D0
    TRAP    #15
    LEA     CPAREN,A1 --Closing paranthese
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #8,D0
    AND.W   (MOCKA),D0
    CMP.B   #8,D0
    BEQ     PLUS
BMS2
    BRA     BACKSHIFT6
PLUS
    LEA     PPLUS,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA     BMS2
    

ABSOLUTE
    LEA     DOLLAR,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #1,D0
    AND.W   (MOCKA),D0
    CMP.B   #1,D0
    BEQ     AALONG
    BRA     AAWORD
BACKA
    MOVE.B  #15,D0
    MOVE.B  #16,D2
    TRAP    #15
    BRA     BACKSHIFT6
    
AALONG
    LEA     MOCKA,A0
    ADDA.W  #$10,A0
    MOVE.L  (A0),D1
    BRA     BACKA
    
AAWORD
    LEA     MOCKA,A0
    ADDA.W  #$10,A0
    MOVE.W  (A0),D1
    BRA     BACKA
    
PREDEC
    LEA     MINUS,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA     BMS

    
    SIMHALT             ; halt simulator

* Put variables and constants here
MOCKA   DS.W    2
LOGICMESG   DC.B    'LS',0
ARITHMESG   DC.B    'AS',0
LMSG        DC.B    'L',0
RMSG        DC.B    'R',0
BMSG        DC.B    '.B   ',0
WMSG        DC.B    '.W   ',0
LONGMSG     DC.B    '.L   ',0
REGMSG      DC.B    'D(',0
IMMSG       DC.B    '#$',0
CPAREN      DC.B    ')',0
COMMA       DC.B    ',',0
OPAREN      DC.B    '(',0
MINUS       DC.B    '-',0
PPLUS       DC.B    '+',0
DOLLAR      DC.B    '$',0
TAB         DC.B    '   ',0
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
