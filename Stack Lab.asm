;***********************************************************************
;* CS2253 - Lab 6
;*
;* @author - Taryn Cail
;* @version 1.0
;* @date - March 14th, 2025
;*
;* Purpose - To program a stack that reverses an array of 10 numbers
;***********************************************************************

; Start program
        .ORIG x3000

        LD R6, STACKBASE ; Initialize stack

        LD R2, N
        AND R3, R3, #0  ; i variable
        
        LEA R1, X      ; Load the address of X into R1
LOOP1   LDR R0, R1, #0
        JSR PUSH
        
        ADD R1, R1, #1  ; Increment address in R1
        ADD R3, R3, #1  ; Increment i
        ADD R4, R3, R2
        BRn LOOP1
        
        AND R3, R3, #0  ; i variable
        LEA R1, X       ; Load the address of X into R1
LOOP2   JSR POP
        STR R0, R1, #0
        ADD R1, R1, #1  ; Increment address in R1
        ADD R3, R3, #1  ; Increment i
        ADD R4, R3, R2
        BRn LOOP2

        TRAP x25        ; End the program

; Variables in Array
N       .FILL #-10
X       .FILL #1
        .FILL #2
        .FILL #3
        .FILL #4
        .FILL #5
        .FILL #6
        .FILL #7
        .FILL #8
        .FILL #9
        .FILL #10

;*************************************************************************
;* Push Subroutine
;*
;* Purpose: Pushes a value onto a stack
;* Input: A value from R0 onto the stack
;* Output: None
;* Uses R0 and R1 in the method, flags R5 as 1 if the push fails, and 0
;* if it is successful.
;**************************************************************************
PUSH    ST R1, SAVER1       ; Save R1
        LD  R1, NEGSL       ; Load STACKLIMIT into R1
        ADD R1, R6, R1      ; If R6 - STACKLIMIT 
        BRzp    YESPUSH     ; If there is space push the variable
        AND R5, R5, #0
        ADD R5, R5, #1      ; If not set R5 == 1 the flag
        LD R1, SAVER1       ; Restore variables
        RET                 ; Return to Program

YESPUSH ADD R6, R6, #-1     ; Move "top" (R6) - 1
        STR R0, R6, #0      ; Place number into address stored in R6 + 0
        AND R5, R5, #0      ; Set R5 == 0, flag for successful push
        LD  R1, SAVER1      ; Restore variables
        RET                 ; Return to Program


;*************************************************************************
;* Pop Subroutine
;*
;* Purpose: Pops a value from the stack and return it
;* Input: None
;* Output: Value from stack in R0
;* Uses R0 and R1 in the method, flags R5 as 1 if the pop fails, and 0
;* if it is successful.
;**************************************************************************
POP     ST R1, SAVER1       ; Save R1
        LD R1, NEGSB        ; Load STACKBASE into R1
        ADD R1, R6, R1      ; If R6 - STACKBASE
        BRp     YESPOP      ; If there are items in the stack then pop
        AND R5, R5, #0
        ADD R5, R5, #1      ; If not set R5 == 1 the flag
        LD R1, SAVER1       ; Restore variables
        RET                 ; Return to Program
        
YESPOP  LDR R0, R6, #0      ; Place the popped value into R0
        ADD, R6, R6, #1     ; Move the pointer "down"
        AND, R5, R5, #0     ; Set R5 == 0, flag for successful pop
        LD R1, SAVER1       ; Restore variables
        RET                 ; Return to the program


;*************************************************************************
;* Peek Subroutine
;*
;* Purpose: Peeks at the top value of the stack and puts a copy of it in R0
;* Input: None
;* Output: Value from stack in R0
;* Uses R0 and R1 in the method, flags R5 as 1 if the pop fails, and 0
;* if it is successful.
;**************************************************************************
PEEK    ST R1, SAVER1       ; Save variables
        LD R1, NEGSB        ; Load STACKBASE into R1
        ADD R1, R6, R1      ; If R6 - STACKBASE
        BRp     YESPEEK     ; If there are items in the stack then peek
        AND R5, R5, #0
        ADD R5, R5, #1      ; If not set R5 == 1 the flag
        LD R1, SAVER1       ; Restore variables
        RET                 ; Return to Program
        
YESPEEK LDR R0, R6, #0      ; Place the peeked value into R0
        AND R5, R5, #0      ; Set R5 == 0, flag for succcessful peek
        LD R1, SAVER1       ; Restore variables
        RET                 ; Return to program

;*************************************************************************
;* isEmpty Subroutine
;*
;* Purpose: Checks if the Stack isEmpty
;* Input: None
;* Output: Fags R5 as 1 if the stack is empty fails, and 0 if it is not.
;**************************************************************************
ISEMPTY ST R1, SAVER1       ; Save R1
        LD R1, NEGSB        ; Checking if it's empty
        ADD R1, R6, R1      ; If R6 - STACKBASE
        BRz SEMPTY          ; If there are items in the stack
        AND R5, R5, #0      ; Set flag to fail (ie not empty)
        ADD R5, R5, #1      
        LD R1, SAVER1       ; Restore variables
        RET                 ; Return to program
        
SEMPTY  AND R5, R5, #0      ; Set flag to success (ie empty)
        LD R1, SAVER1       ; Restore variables
        RET                 ; Return to program
        
        
; Variables for Subroutines
SAVER1      .BLKW   #1
STACKLIMIT  .FILL   x4000
STACKBASE   .FILL   x400A
NEGSL       .FILL   xC000
NEGSB       .FILL   xBFF6

; Larger Stack Bases
; STACKBASE   .BLKW   x4FFF
; NEGSB       .BLKW   xB001

.END
