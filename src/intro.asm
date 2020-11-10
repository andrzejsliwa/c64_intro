; define all constants
clear  = $e544
chrout = $ffd2


; a simple "hello world" program
; with a BASIC header
; creates first a following BASIC
; line
;
;       2010 sys 4096
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
	.word ss, 2010
; $9e represents the SYS command
	.byte $9e
; .null adds null ($00) at the end
; as and end of BASIC line marker
	.null " 4096"
ss
	.word 0 ; BASIC end marker

; actual program starts from $1000
; (SYS 4096)

	*= $1000

start   jsr clear
		ldx #0

print   lda msg, x
		cmp #0
		beq end
		jsr chrout
		inx
		jmp print
end     rts

msg     .null "hello world !!!"
