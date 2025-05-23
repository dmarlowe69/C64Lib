

.cpu  '6502'
.enc  'none'

; ---- basic program with sys call ----

; [start address]

* = $0801
    ;           [line]
	.word  (+), 2022
    ;      [sys]                                     [rem]     [desc]
	.null  $9e, format(' %d ', program_entry_point), $3a, $8f, ' prg'
+	.word  0

program_entry_point	; assembly code starts here

	jmp main.start

;--------------------------------------------------------------- lib

.include "../../lib/libC64.asm"

;--------------------------------------------------------------- main

main	.proc


    c1  .null   "33"            ;    33
    c2  .null   "$ff"           ;   255  
    c3  .null   "%01010101"     ;    85
    c4  .null   "-45"           ;   -45
    
    s16 .sint   -32755 
 
    print_string_out    .proc
    
            load_address_zpWord0    conv.string_out
            jsr std.print_string

            lda #char.nl
            jsr c64.CHROUT
            
            rts
    .pend
    
    start	.proc

            ;   program

            ; --------------------------------------- str_ub0
            
            lda #03
            jsr conv.str_ub0
             
            jsr print_string_out
            
            ; --------------------------------------- str_ub
            
            lda #03
            jsr conv.str_ub
             
            jsr print_string_out
            
            ; --------------------------------------- str_b
            
            lda #-3
            jsr conv.str_b
             
            jsr print_string_out
            
            ; --------------------------------------- str_ubhex

            ;                     0D
            lda #13
            jsr conv.str_ubhex
             
            jsr print_string_out
            
            ; --------------------------------------- str_ubbin

            ;                     0D 00001101
            lda #13
            jsr conv.str_ubbin
             
            jsr print_string_out
            
            ; --------------------------------------- str_uwbin

            ;                     c001 1100000000000001
            lda <#$c001
            ldy >#$c001
            jsr conv.str_uwbin
             
            jsr print_string_out

            ; --------------------------------------- str_uwhex

            ;                     c001
            lda <#$c001
            ldy >#$c001
            jsr conv.str_uwhex
             
            jsr print_string_out
            
            ; --------------------------------------- str_uwhex

            ;                    (0ca6) 
            lda #<s16
            ldy #>s16
            jsr conv.str_uwhex
             
            jsr print_string_out
            
            ;                    (800D)
            lda s16
            ldy s16+1
            jsr conv.str_uwhex
             
            jsr print_string_out
            ; --------------------------------------- str_uwdec 

            ;   c001            ; 49153
            lda #$01
            ldy #$c0
            jsr conv.str_uwdec
             
            jsr print_string_out

            ; --------------------------------------- str_w 

            ;   c001
            ;                   -32755 
            
            lda s16
            ldy s16+1
            jsr conv.str_w
             
            jsr print_string_out

            ; --------------------------------------- any2uword ($ % unsigned number)
             
            lda #char.nl
            jsr c64.CHROUT  
            ;                   "33"            ;    33
            load_address_ay c1
            jsr conv.any2uword
            
            load_var_ay zpWord0
            jsr std.print_u16_dec

            ; --------------------------------------- any2uword ($ % unsigned number)
             
            lda #char.nl
            jsr c64.CHROUT  
            ;                   "$ff"           ;   255
            load_address_ay c2
            jsr conv.any2uword
            
            load_var_ay zpWord0
            jsr std.print_u16_dec

            ; --------------------------------------- any2uword ($ % unsigned number)
             
            lda #char.nl
            jsr c64.CHROUT  
            
            ;                   "%01010101"     ;    85
            load_address_ay c3
            jsr conv.any2uword
            
            load_var_ay zpWord0
            jsr std.print_u16_dec
            
            ; --------------------------------------- str2word ( .  .  signed number)
             
            lda #char.nl
            jsr c64.CHROUT  
            ;                   "-45"            ;   -45
            load_address_ay c4
            jsr conv.str2word
            
            load_var_ay zpWord0
            jsr std.print_s16_dec

            ;

            rts
            


    .pend

.pend

;;;
;;
;

