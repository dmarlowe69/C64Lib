

.cpu  '6502'
.enc  'none'

; ---- basic program with sys call ----

; [start address]

* = $0801
    ;           [line]
    .word  (+), 2022
    ;      [sys]                                     [rem]     [desc]
    .null  $9e, format(' %d ', program_entry_point), $3a, $8f, ' prg'
+   .word  0

;--------------------------------------------------------------- program_entry_point

program_entry_point

    jmp program

;--------------------------------------------------------------- lib

.include "../../lib/libC64.asm"

;--------------------------------------------------------------- sub

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

main	.proc

    save_sp .byte 0
    
    start	.proc

            ;   program
 
            ;--------------------------------------------------------------- clear
 
            jsr c64.CLEARSCR

            ;---------------------------------------------------------------
            
            lda stack.pointer
            sta save_sp

            jsr stack.debug

            lda #char.nl
            jsr c64.CHROUT
            
            ;-----------------------------------------------------   stack.idiv_uw
 
            lda #13
            jsr stack.push_byte
            lda #14
            jsr stack.push_byte
            
            jsr stack.equal_b
            
            jsr stack.pop_byte
            jsr std.print_u8_dec

            lda #char.nl
            jsr c64.CHROUT
            
            ;-------------------------------------------------
 
            .load_imm_ay #13
            jsr stack.push_word
            .load_imm_ay #14
            jsr stack.push_word
            
            jsr stack.equal_w
            
            jsr stack.pop_word
            jsr std.print_u16_dec

            lda #char.nl
            jsr c64.CHROUT
            
            ;-------------------------------------------------
 
            lda #-13
            jsr stack.push_byte
            lda #14
            jsr stack.push_byte
            
            jsr stack.less_b
            
            jsr stack.pop_byte
            jsr std.print_u8_dec

            lda #char.nl
            jsr c64.CHROUT
            
            ;-------------------------------------------------
 
            .load_imm_ay #-13
            jsr stack.push_word
            .load_imm_ay #14
            jsr stack.push_word
            
            jsr stack.less_w
            
            jsr stack.pop_word
            jsr std.print_u8_dec

            lda #char.nl
            jsr c64.CHROUT
            
            ;-------------------------------------------------
 
            .load_imm_ay #0
            jsr stack.push_word
            
            jsr stack.equalzero_w
            
            jsr stack.pop_word
            jsr std.print_u8_dec

            lda #char.nl
            jsr c64.CHROUT
            
            ;-------------------------------------------------
            
            jsr stack.debug  
            
            lda save_sp
            sta stack.pointer
            tax

            rts
            
    .pend

.pend

;;;
;;
;

