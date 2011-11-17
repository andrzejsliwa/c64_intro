    ; a simple "hello world" program
    ; with a BASIC header
    ; written for 64tass compiler

    ; creates first a following BASIC
    ; line
    ;
    ; 	2010 sys 4096
    ;
    ; (so that the program will start
    ; with RUN command)
    ;
    ; $0800 to $9FFF is reserved for
    ; BASIC programs

    *=$0801
    ; .word:    Include 16bit unsigned
    ; word constants

    ; the following includes the address
    ; of label ss and the string 2010
    ; representing a BASIC line number
    .word ss,2010

    .null $9e,^start

    ; .null: Include constants and
    ;        strings, adds a null at
    ;        the end
    ;
    ; $9e represents the SYS command
    ;
    ; ^start is the address of start
    ; label as a decimal string
    ;
    ; .null adds null ($00) at the end
    ; as and end of BASIC line marker

ss
    .word 0 ; BASIC end marker

    ; actual program starts from $1000
    ; (SYS 4096)
    *= $1000

    ; write "hello world" message from
    ; end to start to the screen memory
    ; $0401 to $040b

start
    ldx message
    ; load the first byte from message
    ; to x-register
loop
    ; load starting from message address
    ; with the offset of x-register
    ; value
    lda message,x
    ; store to screen memory
    ; using the offset value from
    ; x-register
    sta $0400,x
    ; decrease the value in x-register
    dex
    ; continue to loop if dex didn't
    ;result to 0
    bne loop
    rts

message
    ; the first byte is the length of
    ; the string
    .byte $0b, 'hello world'
