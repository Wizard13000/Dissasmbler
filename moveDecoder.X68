*-----------------------------------------------------------
* Title      :moveDecoder class
* Written by :Thomas Hedrick
* Date       :5/2/19
* Description:decodes the move and movea calls
*-----------------------------------------------------------
    
STARTMOVE   ORG    $2000               ; first instruction of program

* Put program code here
          
             
BEGIN    MOVE.W  (A2),D1
        
         AND    #$01C0,D1           
         CMP    #$0040,D1           ;determines if the move is MOVE or MOVEA
         BNE    NOT_A
         
         LEA    COMMAND,A1          ;prints move
         JSR    NEXT_VALUE
         MOVE.B #14,D0
         TRAP   #15
         BRA    SIZE_C
         
NOT_A   LEA    COMMAND,A1           ;prints movea
        MOVE.B #14,D0
        TRAP   #15

SIZE_C  MOVE    (A2),D0
        AND     #$3000,D0           ;determines the size of the move
        LSR.W   #8,D0
        LSR.W   #4,D0
        
         LEA    SIZE,A1
         SUB    #1,D0
         BEQ    SIZE_P
         
INC_SIZE JSR    NEXT_VALUE       
         SUB   #1,D0
         BNE   INC_SIZE
         
SIZE_P   MOVE.B #14,D0              ;prints out .B or .W or .L
         TRAP   #15
        
        LEA    SYNTAX,A1            ;prints out some spaces
        MOVE.B #14,D0
        TRAP   #15
        
        MOVE.W #$0038,MODESD        
        MOVE.W #3,MODESD+2
        MOVE.W #$0007,MODESD+4       ;load values for source check
        MOVE.W #0,MODESD+6

MODE_S  MOVE   (A2),D0
               
        AND    MODESD,D0            ;determines the mode for source and destination
        
        LEA    MODE,A1
         
        MOVE.B D0,D6                ;saves the mode so that it can be closed later ex: '('
        
        MOVE.W MODESD+2,D4
        LSR    D4,D6                ;shifts mode to array readable format
        SUB    #2,D6 
        
        LSR    D4,D0
        BEQ    MODE_SP        

MODE_L  JSR NEXT_VALUE
        SUB #1,D0
        BNE MODE_L        
        
        
        
MODE_SP MOVE.B #14,D0               ;prints out mode
        TRAP   #15       
        
        
        MOVE.W (A2),D0
        AND    MODESD+4,D0          ;determines what the source or destination register is
        
        MOVE.W MODESD+6,D4          
        CMP #0,D4
        BEQ  NO_SHIFT
        
SHIFT   LSR #1,D0     
        SUB #1,D4                   ;shifts destination register to array readable format
        BNE SHIFT
        
NO_SHIFT MOVE.W D0,D1               ;prints out the register
         MOVE.B #3,D0      
         TRAP   #15
        
        
        LEA    CLOSE_M,A1
        
        CMP    #0,D6
        BMI    DEST
        
        BEQ    MODE_C
        
        
        
        
MODE_L2 JSR NEXT_VALUE
        SUB #1,D6
        BNE MODE_L2   


MODE_C MOVE.B #14,D0               ;prints out the closing part of the mode ex:')'
       TRAP   #15 

DEST    CMP    #1,D5
        BEQ    RESET                ;checks if on source or dest loop
        ADD    #1,D5
        CLR    D6
        
        MOVE.W #$01C0,MODESD
        MOVE.W #6,MODESD+2          ;set values for dest loop
        MOVE.W #$0E00,MODESD+4
        MOVE.W #9,MODESD+6
        
        LEA    SYNTAX,A1   
        JSR    NEXT_VALUE           ;prints out ','
        MOVE.B #14,D0
        TRAP   #15
        BRA    MODE_S
         
        
RESET   LEA    NEWLINE,A1   ;finished the line off
        MOVE.B #14,D0
        TRAP   #15
        ADD    #2,MEMLOC
        BRA INC             ;heads back to main

NEXT_VALUE   TST.B (A1)+        ;grabs next value in an string array
             BNE   NEXT_VALUE 
             RTS
         
                
        
* Put variables and constants here

CR       EQU    $0D
LF       EQU    $0A  

MODESD  DS.W    4

SYNTAX  DC.B    '   ',0,',',0
NEWLINE DC.B    CR,LF,0
COMMAND DC.B    'MOVE',0,'MOVEA',0
SIZE    DC.B    '.B',0,'.L',0,'.W',0
MODE    DC.B    'D',0,'A',0,'(A',0,'(A',0,'-(A',0
CLOSE_M DC.B    ')',0,')+',0,')',0







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
