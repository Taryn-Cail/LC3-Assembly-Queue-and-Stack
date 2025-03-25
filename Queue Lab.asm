;***********************************************************************
;* CS2253 - Lab 7
;*
;* @author - Taryn Cail
;* @version 1.0
;* @date - March 14th, 2025
;*
;* Purpose - To program a Queue that reads and writes 10 numbers
;***********************************************************************

; Start Program
        .ORIG x3000
        
        LD R2, N        ; Count of queue size
        AND R3, R3, #0  ; i variable
        
        LEA R1, X       ; Load the address of X into R1
LOOP1   LDR R0, R1, #0  
        JSR ENQUEUE
        
        ADD R1, R1, #1  ; Increment address in R1
        ADD R3, R3, #1  ; Increment i
        ADD R4, R3, R2  ; i - N
        BRn LOOP1       ; Loop while negative
        
        AND R3, R3, #0  ; i variable
        LEA R1, X       ; Load the address of X into R1
LOOP2   JSR DEQUEUE     
        STR R0, R1, #0  ; Store dequeued value into address at R1
        ADD R1, R1, #1  ; Increment address in R1
        ADD R3, R3, #1  ; Increment i
        ADD R4, R3, R2  
        BRn LOOP2
        
        TRAP x25

; Variables
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
;* enqueque Subroutine
;*
;* Purpose: enqueues a number into the end of the Queue
;* Input: A value from R0 
;* Output: None
;**************************************************************************

ENQUEUE ST R1, SAVER1
        ST R2, SAVER2
        
        ADD R1, R4, #1  ; Place tail +1 into R1
        LD R2, NEGQBASE ; Load -QBASE into R2
        ADD R1, R1, R2  ; (Tail + 1) - QBase into R2
        BRz WRAP        ; If (tail + 1) == QBASE wrap around
        BR CONTINUE     ; Otherwise continue

WRAP    LD R1, QLIMIT   ; Set tail to QLIMIT
CONTINUE NOT R2, R3     ; Compute - (head) into R2
        ADD R2, R2, #1
        ADD R2, R2, R1  ; (tail +1) - head
        BRz FULLQ       ; If (tail + 1) == head full queue
        
        STR R0, R4, #0  ; Store value into Queue
        ADD R4, R1, #0  ; Move tail to the new position from R1
        AND R5, R5, #0  ; Flag R5=0 for successful
        LD R1, SAVER1   ; Restore R1 and R2
        LD R2, SAVER2
        RET             ; Return to the program

FULLQ   ADD R5, R5, #1  ; Flag R5 = 1 to indicate fail, full queue
        LD R1, SAVER1   ; Restore R1 and R2
        LD R2, SAVER2
        RET             ; Return to the program

;*************************************************************************
;* dequeue Subroutine
;*
;* Purpose: dequeues a number from the front of the Queue
;* Input: None
;* Output: A value from the front of the queue returned to R0
;**************************************************************************

DEQUEUE ST R1, SAVER1
        NOT R1, R3      ; Compute -head INTO R1
        ADD R1, R1, #1
        ADD R1, R1, R4  ; Compute tail -head into R1
        BRnp YESDEQ     ; if head ==tail, queue is empty
        
        ADD R5, R5, #1  ; Flag R5 FOR FAIL
        LD R1, SAVER1   ; Restore R1
        RET             ; Return to program
        
YESDEQ  LDR R0, R3, #0  ; Load value into Head
        ADD R3, R3, #1  ; Increment head
        
        LD R1, NEGQBASE ; Load the negative base
        ADD R1, R3, R1  ; If head - qbase
        BRnp DONEQ      ; Does NOT equal 0 then done
        LD R3, QLIMIT  ; Otherwise reset the head to the limit
        
DONEQ   LD R1, SAVER1   ; Restore R1
        RET             ; Return to the program

        ADD R3, R3, #1  ; Increment the head
        
        ; Check for overflow
        
        STR R0, R3, #0  ; Place value into R0
        RET             ; Return to the program

;*************************************************************************
;* isEmpty Subroutine
;*
;* Purpose: Checks if the Queue is empty
;* Input: None
;* Output: A flag in R5, O for empty, 1 for not empty
;**************************************************************************

ISEMPTY ST R1, SAVER1
        NOT R1, R3      ; 2's complement head pointer INTO R1
        ADD R1, R1, #1  
        ADD R1, R1, R5  ; Tail - Head
        BRnp NOTEMPTY   ; If it results in anything but zero, not empty
        ADD R5, R5, #1  ; Add one to R5 for, FAIL ie empty
        LD R1, SAVER1  ; Restore R1
        RET             ; Return to program

NOTEMPTY AND R5, R5, #0  ; Set flag to 0, succesful ie empty
        LD R1, SAVER1   ; Restore R1
        RET             ; Return to program

        

; Variables for subroutine
SAVER1      .BLKW #1
SAVER2      .BLKW #1
QLIMIT      .FILL x5000
QBASE       .FILL x500A
NEGQLIMIT   .FILL x-500A
NEGQBASE    .FILL x-500A

            .END