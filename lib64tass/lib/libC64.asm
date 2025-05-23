
;**********
;           C64
;**********

.cpu  '6502'
.enc  'none'

;--------------------------------------------------------------- include

.include "libMath.asm"
.include "libStack.asm"
.include "libSTDIO.asm"
.include "libConv.asm"
.include "libString.asm"
.include "libArray.asm"
.include "libGraph.asm"
.include "libBasic.asm"
.include "libFloat.asm"

;--------------------------------------------------------------- 

;******
;       global
;******

global  .proc

    hex_digits      .text '0123456789abcdef'

.pend

;**********
;           define
;**********

;---------------------------------------------------------------  bit and or

                ;76543210
                
bank3       =   %00000000
bank2       =   %00000001
bank1       =   %00000010
bank0       =   %00000011

bit_or_0    =   %00000000
bit_or_1    =   %00000010
bit_or_2    =   %00000100
bit_or_3    =   %00001000
bit_or_4    =   %00000000
bit_or_5    =   %00100000
bit_or_6    =   %01000000
bit_or_7    =   %10000000

bit_and_0    =  %11111111
bit_and_1    =  %11111101
bit_and_2    =  %11111011
bit_and_3    =  %11110111
bit_and_4    =  %11101111
bit_and_5    =  %11011111
bit_and_6    =  %10111111
bit_and_7    =  %01111111

;**********
;           zero page
;**********

;   -------------------------------------------- safe

zpa     = $02
zpx     = $2a
zpy     = $52

zpByte0     = $fb   ;   zpDWord0    zpWord0     zpByte0
zpByte1     = $fc   ;                           zpByte1
zpByte2     = $fd   ;               zpWord1     zpByte2
zpByte3     = $fe   ;                           zpByte3

zpByte4     = $03   ;   zpDWord1    zpWord2     zpByte4
zpByte5     = $04   ;                           zpByte5
zpByte6     = $05   ;               zpWord3     zpByte6
zpByte7     = $06   ;                           zpByte7

zpDWord0        = $fb
    zpWord0     = $fb
        zpWord0hi   = $fb
        zpWord0lo   = $fb+1
    zpWord1     = $fd
        zpWord1hi   = $fd
        zpWord1lo   = $fd+1

zpDWord1    = $03
    zpWord2     = $03       ;   $B1AA, execution address of routine converting floating point to integer.
        zpWord2hi   = $03
        zpWord2lo   = $03+1
    zpWord3     = $05       ;   $B391, execution address of routine converting integer to floating point.
        zpWord3hi   = $05
        zpWord3lo   = $05+1

;**********
;           page
;**********

page  .proc

    ;   zp
    
;   [   ]

    buffer0023_18   =   0023    ;   (18) byte   ;   *
    ;       *
    ;       $0017-$0018 23-24	Pointer to previous expression in string stack.
    ;       $0019-$0021 25-33	String stack, temporary area for processing string expressions (9 bytes, 3 entries).
    ;       $0022-$0025 34-37	Temporary area for various operations (4 bytes).
    ;       $0026-$0029 38-41	Auxiliary arithmetical register for division and multiplication (4 bytes).
    
;   [   ]

    buffer0075_02   =   0073    ;   ( 2) byte   ;   Temporary area for saving original pointer to current BASIC 
                                                ;   instruction during GET, INPUT and READ.
;   [   ]
                                            
    buffer0104_01   =   0104    ;   ( 1) byte   ;   Temporary area for various operations.
    buffer0146_01   =   0146    ;   ( 1) byte   ;   Unknown. (Timing constant during datasette input.)
    buffer0150_01   =   0150    ;   ( 1) byte   ;   Unknown. (End of tape indicator during datasette input/output.)
    buffer0151_01   =   0151    ;   ( 1) byte   ;   Temporary area for saving original value of Y register during input from RS232.
                                                ;   instruction during GET, INPUT and READ.
;   [   ]
      
    buffer0155_01   =   0155    ;   ( 1) byte   ;   Unknown. (Parity bit during datasette input/output.)
    buffer0156_01   =   0156    ;   ( 1) byte   ;   Unknown. (Byte ready indicator during datasette input/output.)
                                                ;   instruction during GET, INPUT and READ.
;   [   ]
      
    buffer0176_02   =   0176    ;   ( 2) byte   ;   Unknown.
                                                ;   instruction during GET, INPUT and READ.
;   [   ]
      
    buffer0191_01   =   0191    ;   ( 1) byte   ;   Unknown.
    buffer0645_01   =   0645    ;   ( 1) byte   ;   Unused  (Serial bus timeout.)
                                                ;   instruction during GET, INPUT and READ.
                                                
;   buffer0679_89   =   0679    ;   (89) byte   ;   Unused  (89 bytes).              (64+15)
                                                ;   instruction during GET, INPUT and READ.
;   [ V ]
                                              
    buffer0679_15   =   0679    ;   (15) byte   ;   Unused  (15 bytes).              (64+15)
                                                ;   instruction during GET, INPUT and READ.
                                                ;   (T) fac1-fac2 save/restore raster
;   [   ]
   
    buffer0694_74   =   0694    ;   (74) byte   ;   Unused  (89 bytes).              (64+15)
    
;   [   ]
      
    buffer0787_01   =   0787    ;   ( 1) byte   ;   Unused
    buffer0814_02   =   0814    ;   ( 2) byte   ;   Unused  Default: $FE66.              (2)
                                                ;   instruction during GET, INPUT and READ.
;   [   ]
      
    buffer0820_08   =   0820    ;   (48) byte   ;   Unused (8 bytes).                    (8)
                                                ;   instruction during GET, INPUT and READ.
;   [   ]
      
    buffer0828_192  =   0828    ;  (192) byte   ;   Datasette buffer (192 bytes).   (128+64)
                                                ;   instruction during GET, INPUT and READ.
;   [   ]
      
    buffer1020_04   =   1020    ;   ( 4) byte   ;   Unused (4 bytes).                    (4)
                                                ;   instruction during GET, INPUT and READ.
;   [ V ]
      
    buffer2024_15   =   2024    ;   (15) byte   ;   Unused (15 bytes).  **              (15)     TAKE
    ;                   2040    ;   sprite 0 - 7
    ;                   2047

    ;       **
    ;       screen  :    1024   -   2023
    ;                    $0400   -  $07E7
    ;       buffer  :    2024   -   2039    (15)   buffer
    
    ;               :    2040   -   2047    (8)    sprite
    ;       program :    2049   -   ->
    
.pend
    
;**********
;           buffer
;**********

buffer .proc 

    status .proc
    
        sp           =   page.buffer2024_15+ 0
        
        zpa          =   page.buffer2024_15+ 1
        zpx          =   page.buffer2024_15+ 2
        zpy          =   page.buffer2024_15+ 3

        zpWord0      =   page.buffer2024_15+ 4
        zpWord1      =   page.buffer2024_15+ 6
        zpWord2      =   page.buffer2024_15+ 8
        zpWord3      =   page.buffer2024_15+10

        reg_a        =   page.buffer2024_15+12
        reg_x        =   page.buffer2024_15+13
        reg_y        =   page.buffer2024_15+14
        flag         =   page.buffer2024_15+15
        
        fac1_fac2    =   page.buffer0679_15+ 0
        
    .pend

.pend
    

;**********
;           sys
;**********

sys .proc

    ;   -------------------------------------------------------
    ;
    ;   ffe1	jmp ($0328)	(istop)		Test-Stop Vector [f6ed]
    ;
    ;   -------------------------------------------------------
    
    istop    .proc

        txa
        pha
        jsr  c64.STOP
        beq  +
        pla
        tax
        lda  #0
        rts
    +       
        pla
        tax
        lda  #1
        
        rts
    
    .pend
    
    ;   -------------------------------------------------------
    ;
    ;   ffde	jmp $f6dd	rdtim		Read Real-Time Clock
    ;
    ;   -------------------------------------------------------
    
    RDTIM16    .proc

        stx  zpx
        jsr  c64.RDTIM
        pha
        txa
        tay
        pla
        ldx  zpx
        rts
        
    .pend
    
    ;   -------------------------------------------------------
    ;
    ;   fffc   ; Execution address of cold reset. 
    ;
    ;   -------------------------------------------------------
    
    reset_system    .proc   
     
                sei
                lda  #14
                sta  $01                ; bank the kernal in
                jmp  (c64.RESET_VEC)
                
    .pend
    
    ;   -------------------------------------------------------
    ;
    ;  wait raster sync ( Screen control register #1. Bits: )
    ;
    ;   -------------------------------------------------------
    
    wait_vsync    .proc
     
    -           bit  c64.SCROLY
                bpl  -
    -           bit  c64.SCROLY
                bmi  -
                rts
    .pend

    ;   ------------------------------------------------------- 
    ;
    ;   save/restore status zp,reg,flag
    ;
    ;   ------------------------------------------------------- 
    
    status  .proc
    
        save  .proc
    
            sta buffer.status.reg_a 
            stx buffer.status.reg_x
            sty buffer.status.reg_y
            php
            pla
            sta buffer.status.flag

            lda stack.pointer
            sta buffer.status.sp
            
            lda zpa
            sta buffer.status.zpa

            lda zpx
            sta buffer.status.zpx

            lda zpy
            sta buffer.status.zpy

            lda zpWord0
            sta buffer.status.zpWord0
            lda zpWord0+1
            sta buffer.status.zpWord0+1
            
            lda zpWord1
            sta buffer.status.zpWord1
            lda zpWord1+1
            sta buffer.status.zpWord1+1

            lda zpWord2
            sta buffer.status.zpWord2
            lda zpWord2+1
            sta buffer.status.zpWord2+1
 
            lda zpWord3
            sta buffer.status.zpWord3
            lda zpWord3+1
            sta buffer.status.zpWord3+1
    
            rts
           
        .pend
        
        restore  .proc
    
            lda buffer.status.sp
            sta stack.pointer

            lda buffer.status.zpa
            sta zpa

            lda buffer.status.zpx
            sta zpx

            lda buffer.status.zpy
            sta zpy

            lda buffer.status.zpWord0
            sta zpWord0
            lda buffer.status.zpWord0+1
            sta zpWord0+1

            lda buffer.status.zpWord1
            sta zpWord1
            lda buffer.status.zpWord1+1
            sta zpWord1+1

            lda buffer.status.zpWord2
            sta zpWord2
            lda buffer.status.zpWord2+1
            sta zpWord2+1 

            lda buffer.status.zpWord3
            sta zpWord3
            lda buffer.status.zpWord3+1
            sta zpWord3+1

            lda buffer.status.reg_a 
            ldx buffer.status.reg_x
            ldy buffer.status.reg_y
            lda buffer.status.flag
            pha
            plp 

            rts
            
        .pend

        save_fac1_fac2    .proc
            ldy #0
        loop
            lda $0061,y
            sta buffer.status.fac1_fac2,y ;  sta $02A7,y
            iny
            cpy #15
            bne loop
            rts
        .pend
        
        restore_fac1_fac2    .proc
            lda #<$0061
            sta zpWord0
            ldy #0
        loop
            lda buffer.status.fac1_fac2,y ;  lda $02A7,y
            sta $0061,y
            iny
            cpy #15
            bne loop
            rts
        .pend
        
    .pend

.pend

;**********
;           color
;**********

color .proc

        black          =       0               ;       0000
        white          =       1               ;       0001
        red            =       2               ;       0010
        cyan           =       3               ;       0011
        violet         =       4               ;       0100
        green          =       5               ;       0101
        blue           =       6               ;       0110
        yellow         =       7               ;       0111

        orange         =       8               ;       1000
        brown          =       9               ;       1001
        light_red      =       10              ;       1010
        dark_grey      =       11              ;       1011
        grey           =       12              ;       1100
        light_green    =       13              ;       1101
        light_blue     =       14              ;       1110
        light_grey     =       15              ;       1111

        default_border      =   254
        default_background  =   246
        default_foreground  =   254
    
.pend

;******
;       char
;******

char .proc

        ;   $CHROUT

        home            =   19
        nl              =   13
        clear_screen    =   147    ;   restore original color
        
        ; $0400
        
        space           =   ' '
        dollar          =   '$'
        a               =   1
        b               =   2

.pend

;******
;       c64
;******

c64 .proc

        ;---------------------------------------------------------------  c64
            
        EXTCOL      = $d020     ;   53280

        BGCOL0      = $d021     ;
        BGCOL1      = $d022     ;
        BGCOL2      = $d023     ;
        BGCOL4      = $d024     ;

        COLOR       = $0286     ;

        SCRPTR      = 648       ;

        NMI_VEC     = $fffa
        RESET_VEC   = $fffc     ; Execution address of cold reset.
        IRQ_VEC     = $fffe
        
        OUT_U16     = $BDCD     ;   ax
        SCREEN_XY   = $fff0     ;   C=1 read cursor pos(xy)   C=0 set cursor pos(xy) 
        SCREEN_WH   = $ffed     ;   
        SCREEN_CLEAR= $e544     ;
        SCREEN_HOME = $e566     ;

        STROUT      = $ab1e
        CLEARSCR    = $e544
        HOMECRSR    = $e566
        IRQDFRT     = $ea31     ;
        IRQDFEND    = $ea81
        CINT        = $ff81     ;
        IOINIT      = $ff84     ;
        RAMTAS      = $ff87
        RESTOR      = $ff8a
        VECTOR      = $ff8d
        SETMSG      = $ff90
        SECOND      = $ff93
        TKSA        = $ff96
        MEMTOP      = $ff99
        MEMBOT      = $ff9c
        SCNKEY      = $ff9f
        SETTMO      = $ffa2
        ACPTR       = $ffa5
        CIOUT       = $ffa8
        UNTLK       = $ffab
        UNLSN       = $ffae
        LISTEN      = $ffb1
        TALK        = $ffb4
        READST      = $ffb7
        SETLFS      = $ffba
        SETNAM      = $ffbd
        OPEN        = $ffc0
        CLOSE       = $ffc3
        CHKIN       = $ffc6
        CHKOUT      = $ffc9
        CLRCHN      = $ffcc
        CHRIN       = $ffcf     ;
        CHROUT      = $ffd2     ;   a
        LOAD        = $ffd5
        SAVE        = $ffd8
        SETTIM      = $ffdb
        RDTIM       = $ffde     ;   read trhe software clock
        STOP        = $ffe1     ;   check the stop key
        GETIN       = $ffe4
        CLALL       = $ffe7
        UDTIM       = $ffea
        SCREEN      = $ffed
        PLOT        = $fff0
        IOBASE      = $fff3
        
        TIME_HI     = $a0
        TIME_MID    = $a1
        TIME_LO     = $a2
        STATUS      = $90
        STKEY       = $91
        SFDX        = $cb
        HIBASE      = $0288
        CINV        = $0314     ;
        CBINV       = $0316
        NMINV       = $0318
     
        SPRPTR0     = $07f8
        SPRPTR1     = $07f9
        SPRPTR2     = $07fa
        SPRPTR3     = $07fb
        SPRPTR4     = $07fc
        SPRPTR5     = $07fd
        SPRPTR6     = $07fe
        SPRPTR7     = $07ff
            
        SPRPTR      = $07f8
        
        SP0X        = $d000
        SP0Y        = $d001
        SP1X        = $d002
        SP1Y        = $d003
        SP2X        = $d004
        SP2Y        = $d005
        SP3X        = $d006
        SP3Y        = $d007
        SP4X        = $d008
        SP4Y        = $d009
        SP5X        = $d00a
        SP5Y        = $d00b
        SP6X        = $d00c
        SP6Y        = $d00d
        SP7X        = $d00e
        SP7Y        = $d00f

        SPXY        = $d000
        SPXYW       = $d000
        MSIGX       = $d010
        
        SCROLY      = $d011     ;
        
        RASTER      = $d012
        LPENX       = $d013
        LPENY       = $d014
        SPENA       = $d015
        SCROLX      = $d016
        YXPAND      = $d017
        VMCSB       = $d018
        VICIRQ      = $d019
        IREQMASK    = $d01a
        SPBGPR      = $d01b
        SPMC        = $d01c
        XXPAND      = $d01d
        SPSPCL      = $d01e
        SPBGCL      = $d01f

        SPMC0       = $d025
        SPMC1       = $d026
        
        SP0COL      = $d027
        SP1COL      = $d028
        SP2COL      = $d029
        SP3COL      = $d02a
        SP4COL      = $d02b
        SP5COL      = $d02c
        SP6COL      = $d02d
        SP7COL      = $d02e
        SPCOL       = $d027
            
        CIA1PRA     = $dc00
        CIA1PRB     = $dc01
        CIA1DDRA    = $dc02
        CIA1DDRB    = $dc03
        CIA1TAL     = $dc04
        CIA1TAH     = $dc05
        CIA1TBL     = $dc06
        CIA1TBH     = $dc07
        CIA1TOD10   = $dc08
        CIA1TODSEC  = $dc09
        CIA1TODMMIN = $dc0a
        CIA1TODHR   = $dc0b
        CIA1SDR     = $dc0c
        CIA1ICR     = $dc0d
        CIA1CRA     = $dc0e
        CIA1CRB     = $dc0f
        CIA2PRA     = $dd00
        CIA2PRB     = $dd01
        CIA2DDRA    = $dd02
        CIA2DDRB    = $dd03
        CIA2TAL     = $dd04
        CIA2TAH     = $dd05
        CIA2TBL     = $dd06
        CIA2TBH     = $dd07
        CIA2TOD10   = $dd08
        CIA2TODSEC  = $dd09
        CIA2TODMIN  = $dd0a
        CIA2TODHR   = $dd0b
        CIA2SDR     = $dd0c
        CIA2ICR     = $dd0d
        CIA2CRA     = $dd0e
        CIA2CRB     = $dd0f
        FREQLO1     = $d400
        FREQHI1     = $d401
        FREQ1       = $d400
        PWLO1       = $d402
        PWHI1       = $d403
        PW1         = $d402
        CR1         = $d404
        AD1         = $d405
        SR1         = $d406
        FREQLO2     = $d407
        FREQHI2     = $d408
        FREQ2       = $d407
        PWLO2       = $d409
        PWHI2       = $d40a
        PW2         = $d409
        CR2         = $d40b
        AD2         = $d40c
        SR2         = $d40d
        FREQLO3     = $d40e
        FREQHI3     = $d40f
        FREQ3       = $d40e
        PWLO3       = $d410
        PWHI3       = $d411
        PW3         = $d410
        CR3         = $d412
        AD3         = $d413
        SR3         = $d414
        FCLO        = $d415
        FCHI        = $d416
        FC          = $d415
        RESFILT     = $d417
        MVOL        = $d418
        POTX        = $d419
        POTY        = $d41a
        OSC3        = $d41b
        ENV3        = $d41c
        
        ;---------------------------------------------------------------  address
        
        .weak
            screen_addr     =   $0400
        .endweak
        
            color_addr      =   $d800
        
        .weak
           ;bitmap_addr     =   $e000
            bitmap_addr     =   $2000
            bitmap_size     =   320*200/8
        .endweak
        
        ;---------------------------------------------------------------  constant
        
        screen_max_width            =   $28    ;   40
        screen_max_height           =   $19    ;   25

        ;---------------------------------------------------------------  register
        
        screen_control_register_1   =   53265
        screen_control_register_2   =   53270

        ;---------------------------------------------------------------  
        
        ;******
        ;       system
        ;******

        timerA  .proc
            stop .proc
                lda	#$fe        ;   1111:11[10]
                and	$dc0e       ;
                sta	$dc0e
                rts
            .pend
            start .proc
                lda	#$01        ;   0000:0001
                ora	$dc0e
                sta	$dc0e
                rts
            .pend
        .pend

        ;   address 0001    bits 76543[210]
        
        mem .proc
        
            default .proc
                lda #%00000111
                and $01
                sta $01
                rts
            .pend
            
            to_rom_AE .proc     ;   kernal rom enable

                jsr default
                lda	#$02        ;   0000:00[10] %x10:  RAM visible at $A000-$BFFF; 
                ora	$01         ;                      KERNAL ROM visible at $E000-$FFFF.
                sta $01
                
                jsr c64.timerA.start
                
                rts
            .pend
            
            to_ram_AE .proc     ;   kernal rom disable
            
                jsr c64.timerA.stop
            
                jsr default
                lda	#$fd        ;   1111:11[01]	%x01: RAM visible at $A000-$BFFF,
                and	$01         ;                                and $E000-$FFFF.
                sta $01
                
                rts
            .pend
            
        .pend

        ;******
        ;       memory setup
        ;******
        
        ; .................................................... setPortA_RW
        ;
        ; Port A data direction register..
        ; default 63 0011:1111
        ;          3 0000:0011
        
        setPortA_RW .proc
            lda 56578   ;   $DD02
            ora #3
            sta 56578   ;   set read and write
            rts
        .pend

        ; .................................................... set bank number
        ;   
        ;   input   :   a   number bank default (11)
        ;
        ;   %00, 0: Bank #3, $C000-$FFFF, 49152 -   65535.
        ;   %01, 1: Bank #2, $8000-$BFFF, 32768 -   49151.
        ;   %10, 2: Bank #1, $4000-$7FFF, 16384 -   32767.
        ;   %11, 3: Bank #0, $0000-$3FFF,     0 -   16383.  
        ;
        
        bank3   =   %00000000
        bank2   =   %00000001
        bank1   =   %00000010
        bank0   =   %00000011

        bank_addr3 = 49152      ;   per il calcolo della locazione 648 ( screen pointer ) 
        bank_addr2 = 32768
        bank_addr1 = 16384
        bank_addr0 =     0
        
        set_bank .proc
            sta zpa
            lda 56576       ;   $DD00
            and #252
            ora zpa
            sta 56576
            rts
        .pend

        ; .................................................... set bitmap offset
        ;   
        ;   input   :   a   number bank default (11)
        ;
        ;   %0xx, 0: $0000-$1FFF,    0  - 8191.
        ;   %1xx, 4: $2000-$3FFF, 8192  -16383. 
        
                      ;76543210
                      ;87654321 il 4 bit
        bitmap0   =   %00000000     ;   $0000
        bitmap1   =   %00000100     ;   $2000

        bitmap_addr0   =  $0000      ;   per il calcolo della locazione 648 ( screen pointer ) 
        bitmap_addr1   =  $2000
        
        setBitmapOffset .proc
            sta zpa
            lda 53272       ;   $D018
            and #%11111011
            ora zpa
            sta 53272
            rts
        .pend

        ; ....................................................  set screen offset
        ;   
        ;   input   :   a   number bank default (11)
        ;

        screen0  = %00000000   ;     0: $0000-$03FF,     0- 1023.
        screen1  = %00010000   ;     1: $0400-$07FF,  1024- 2047.
        screen2  = %00100000   ;     2: $0800-$0BFF,  2048- 3071.
        screen3  = %00110000   ;     3: $0C00-$0FFF,  3072- 4095.
        screen4  = %01000000   ;     4: $1000-$13FF,  4096- 5119.
        screen5  = %01010000   ;     5: $1400-$17FF,  5120- 6143.
        screen6  = %01100000   ;     6: $1800-$1BFF,  6144- 7167.
        screen7  = %01110000   ;     7: $1C00-$1FFF,  7168- 8191.
        screen8  = %10000000   ;     8: $2000-$23FF,  8192- 9215.
        screen9  = %10010000   ;     9: $2400-$27FF,  9216-10239.
        screen10 = %10100000   ;    10: $2800-$2BFF, 10240-11263.
        screen11 = %10110000   ;    11: $2C00-$2FFF, 11264-12287.
        screen12 = %11000000   ;    12: $3000-$33FF, 12288-13311.
        screen13 = %11010000   ;    13: $3400-$37FF, 13312-14335.
        screen14 = %11100000   ;    14: $3800-$3BFF, 14336-15359.
        screen15 = %11110000   ;    15: $3C00-$3FFF, 15360-16383.

        screen_addr0  =     0  ;   per il calcolo della locazione 648 ( screen pointer )  
        screen_addr1  =  1024 
        screen_addr2  =  2048 
        screen_addr3  =  3072 
        screen_addr4  =  4096 
        screen_addr5  =  5120 
        screen_addr6  =  6144 
        screen_addr7  =  7168 
        screen_addr8  =  8192 
        screen_addr9  =  9216 
        screen_addr10 = 10240  
        screen_addr11 = 11264 
        screen_addr12 = 12288 
        screen_addr13 = 13312 
        screen_addr14 = 14336 
        screen_addr15 = 15360 
        
        setScreenOffset .proc
            sta zpa
            lda 53272       ;   $D018
            and #%00001111
            ora zpa
            sta 53272
            rts
        .pend
    
        ;******
        ;       sub
        ;******

        ; ........................................... set mode
        
        set_text_mode_on 
        set_text_mode_standard_on
        set_bitmap_mode_off
            lda 53265
            and #%11011111  ;   bit5
            sta 53265
            
            jsr txt.set_border_color
            jsr txt.set_background_color
            
            rts

        ; ........................................... set bitmap mode ON 
        ; ........................................... set text mode OFF 
        
        set_text_mode_off 
        set_text_mode_standard_off
        set_bitmap_mode_on
            lda 53265
            ora #%00100000
            sta 53265

            ;jsr txt.set_border_color
            ;jsr txt.set_background_color
            
            rts 

        ; ........................................... set text extended background mode ON 
        
        set_text_mode_extended_on
            lda 53265
            ora #%01000000  ; bit 6
            sta 53265

            lda screen.border_color
            sta $d020
            
            lda screen.background_color_0
            sta $d021
            lda screen.background_color_1
            sta $d022
            lda screen.background_color_2
            sta $d023
            lda screen.background_color_3
            sta $d024

            lda screen.foreground_color
            jsr txt.clear_screen_colors
            
            rts

        ; ........................................... set text extended background mode OFF 
        
        set_text_mode_extended_off
            lda 53265
            and #%10111111
            sta 53265

            rts

        ; ........................................... set bitmap mode MC ON 
        
        set_text_mode_multicolor_on
        set_bitmap_mode_multicolor_on
            lda 53270
            ora #%00010000  ;ora #16
            sta 53270

            ;lda screen.border_color
            ;sta $d020
            lda screen.background_color_0
            sta $d021
            lda screen.background_color_1
            sta $d022
            lda screen.background_color_2
            sta $d023
            lda screen.background_color_3
            sta $d024
            
            rts 

        ; ........................................... set bitmap mode MC OFF 
        
        set_text_mode_multicolor_off        
        set_bitmap_mode_multicolor_off
            lda 53270
            and #%11101111  ;and #239
            sta 53270
            
            rts 

        ; ........................................... set bitmap mode 320x200 on / off 
        
        set_bitmap_mode_320x200_on  .proc
            jsr set_bitmap_mode_on
            jsr set_bitmap_mode_multicolor_off
            jsr set_text_mode_extended_off
            rts
        .pend

        set_bitmap_mode_320x200_off  .proc
            jsr set_bitmap_mode_off
            jsr set_bitmap_mode_multicolor_off
            rts
        .pend

        ; ........................................... set bitmap mode 160x200 on / off 
        
        set_bitmap_mode_160x200_on  .proc
            jsr set_bitmap_mode_on
            jsr set_bitmap_mode_multicolor_on
            jsr set_text_mode_extended_off
            rts
        .pend
        
        set_bitmap_mode_160x200_off  .proc
            jsr set_bitmap_mode_off
            jsr set_bitmap_mode_multicolor_off
            rts
        .pend

        ; ........................................... set screen bitmap offset 

        set_screen_0c00_bitmap_2000_addr    .proc
                            ;	7654:3210	(53272)
            lda #%00110011	;	0011:1000
            sta	$d018	    ;	%100u,  4: $2000-$3FFF, 8192-16383.	pointer to bitmap memory
                            ;	%0011,  3: $0C00-$0FFF, 3072-4095.	Pointer to screen memory
            rts
        .pend
                            
        set_screen_0400_bitmap_2000_addr    .proc
                            ;	7654:3210	(53272)
            ;lda #%00010101  ;	0001:1000
            lda #%00011000  ;	0001:1000
            sta	$d018	    ;	%100u,  4: $2000-$3FFF, 8192-16383.	pointer to bitmap memory
                            ;	%0001,  3: $0400-$0FFF, 1024-2048.	Pointer to screen memory
            rts
        .pend
                            
        ; ........................................... check mode 
        
        check_text_mode_standard    .proc

            lda c64.screen_control_register_1
            test_bit_5
            bne   check_text_mode_standard_1
            clc
            rts
            check_text_mode_standard_1
            sec
            rts
            
        .pend
        
        check_text_mode_extended    .proc

            lda c64.screen_control_register_1
            test_bit_6
            bne   check_text_mode_extended_1 
            sec
            rts
        check_text_mode_extended_1
            clc
            rts
            
        .pend
        
        check_bitmap_mode         .proc

            lda c64.screen_control_register_1
            test_bit_5
            bne   check_bitmap_mode_1 
            clc
            rts
        check_bitmap_mode_1
            sec
            rts
            
        .pend

        check_multi_color         .proc

            lda c64.screen_control_register_2
            test_bit_4
            bne   + 
            clc
            rts
        +
            sec
            rts
            
        .pend

        check_bitmap_mode_320x200   .proc
        
            jsr check_bitmap_mode
            if_false    no
            jsr check_multi_color
            if_true     no
        si
            sec
            rts
        no 
            clc
            rts
            
        .pend

        check_bitmap_mode_160x200   .proc
        
            jsr check_bitmap_mode
            if_false    no
            jsr check_multi_color
            if_false    no
        si
            sec
            rts
        no 
            clc
            rts
            
        .pend

        ; ...........................................c64.start
        ;
        ;   input   :   
        ;               zpWord0     from
        ;               zpWord1     to
        ;               xy          value
        
        start   .proc

            cld
            
            tsx
            txa
            sta stack.old
            
            ldx  #255                   ; init stack ptr
            stx  stack.pointer
            
            clv
            clc
    
            jsr  c64.init_system

            ;--------------
            
            jsr  main.start
            
            ;--------------

            jsr  c64.deinit_system 
            
            lda stack.old
            tax
            txs
            
            rts
            
        .pend

        init_system    .proc

            sei
            cld

            jsr  c64.IOINIT
            jsr  c64.RESTOR
            jsr  c64.CINT
            
            lda  #color.black
            sta  c64.EXTCOL
            sta  screen.border_color
            
            lda  #color.green
            sta  c64.COLOR
            sta  screen.foreground_color
            
            lda  #color.black
            sta  c64.BGCOL0
            sta  screen.background_color

            clc
            clv
            cli
            
            rts
                
        .pend

        deinit_system    .proc

                rts
        .pend

        enable_runstop_and_charsetswitch    .proc

            lda  #0
            sta  657    ; enable charset switching
            
            lda  #237
            sta  808    ; enable run/stop key
            
            rts
            
        .pend
        
        disable_runstop_and_charsetswitch    .proc

            lda  #$80
            sta  657    ; disable charset switching
            lda  #239
            sta  808    ; disable run/stop key
            
            rts
        .pend
    
        ; ........................................... peek_word
        ;
        ;   input   :   ay  ->  y   =   peek ( a0:a1,y+0 ) , y
        ;                       a   =   peek ( a0:a1,y+1 ) , a
        ;  (a,y) := (word)*(zpWord0)
        
        peekw  .proc
            ; -- read the word value on the address in AY
            sta  zpWord0
            sty  zpWord0+1
            ldy  #0
            lda  (zpWord0),y
            pha
            iny
            lda  (zpWord0),y
            tay
            pla
            rts
        .pend

        ; ........................................... poke_word
        ;
        ;   input   :   ay  ->  zpWord+1    =   poke ( a0:a1,y+0 ) , y
        ;                       zpWord+0    =   poke ( a0:a1,y+1 ) , a
        ;   *(zpWord0) := (a:y)

        pokew   .proc
            ; -- store the word value in AY in the address in zpWord0
            sty  zpx
            ldy  #0
            sta  (zpWord0),y
            iny
            lda  zpx
            sta  (zpWord0),y
            rts
        .pend
        
    
    ;.................................................  copy_charset
    ;   
    ;   iAN CooG
    ;   
    ;   16 mar 2011, 23:33:38
    ;   
    ; copy charset from chargen to the RAM at the same address
    ; else load your favourite charset here
    ;
    
    ;-------------------------
    .weak
    charset = $d000
    .endweak
    ;-------------------------

    copy_charset    .proc

            sei
            
            ldx #$08
            lda #$33 ; see the chargen at $d000
            sta $01
            
            lda #>charset
            sta $fc
            ldy #$00
            sty $fb
        lp1
            lda ($fb),y
            inc $01
            sta ($fb),y
            dec $01
            iny
            bne lp1
            inc $fc
            dex
            bne lp1
            
            lda #$37 ; ROM active
            sta $01
            
            cli
            
            rts
            
    .pend
    
.pend

;******
;       macro
;******

;--------------------------------------------------------------- test flag

test_bit_0   .macro
    and #%00000001
.endm
test_bit_1   .macro
    and #%00000010
.endm
test_bit_2   .macro
    and #%00000100
.endm
test_bit_3   .macro
    and #%00001000
.endm
test_bit_4   .macro
    and #%00010000
.endm
test_bit_5   .macro
    and #%00100000
.endm
test_bit_6   .macro
    and #%01000000
.endm
test_bit_7   .macro
    and #%10000000
.endm

 ;   non settato     =   0
if_bit_0 .macro
        beq \1
.endm

 ;  settato         =   1
if_bit_1 .macro
        bne \1
.endm
   

; ---------------------------------------------------------------   ay
;
;   ay      lohi
;
;   a   <   lo
;   y   >   hi
;

load_imm_ay	.macro
    lda <\1
    ldy >\1
.endm

load_var_ay	.macro
    lda \1 
    ldy \1+1
.endm

load_address_ay	.macro
    lda #<\1
    ldy #>\1
.endm

switch_ay .macro
    sta zpa
    sty zpy
    lda zpy
    ldy zpa
.endm

; ---------------------------------------------------------------   xy

load_imm_xy .macro
    ldx <\1
    ldy >\1
.endm

load_var_xy .macro
    ldx \1 
    ldy \1+1
.endm

load_address_xy	.macro
    ldx #<\1
    ldy #>\1
.endm
load_address_fac	.macro
    ldx #<\1
    ldy #>\1
.endm

; ---------------------------------------------------------------

load_address_zpWord0	.macro
    lda #<\1
    sta zpWord0
    ldy #>\1
    sty zpWord0+1
.endm

load_imm_zpWord0    .macro
    lda <\1
    sta zpWord0
    ldy >\1
    sty zpWord0+1
.endm

store_imm_zpWord0	.macro
    lda <\1
    sta zpWord0
    ldy >\1
    sty zpWord0+1
.endm

load_address_zpWord1	.macro
	lda #<\1
    sta zpWord1
	ldy #>\1
    sty zpWord1+1
.endm

store_imm_zpWord1	.macro
    lda <\1
    sta zpWord1
    ldy >\1
    sty zpWord1+1
.endm

load_address_zpWord2	.macro
	lda #<\1
    sta zpWord2
	ldy #>\1
    sty zpWord2+1
.endm

; ---------------------------------------------------------------

load_zpByte0	.macro

	lda \1
	sta zpByte0

.endm

load_zpWord0	.macro

	lda \1
	sta zpWord0
	lda \1+1
	sta zpWord0+1
	
.endm

; ---------------------------------------------------------------

load_zpByte1	.macro

	lda \1
	sta zpByte1

.endm

load_zpWord1	.macro

	lda \1
	sta zpWord1
	lda \1+1
	sta zpWord1+1
	
.endm

load_imm_zpWord1	.macro

	lda <\1
    sta zpWord1
	ldy >\1
    sty zpWord1+1
    
.endm

; --------------------------------------------------------------- if then

then	.macro
	bcs \1
.endm

else	.macro
	bcc \1
.endm

;--------------------------------------------------------------- string compare

if_string_lt .macro
    cmp #$ff
    beq \1
.endm

if_string_eq .macro
    cmp #$00
    beq \1
.endm

if_string_gt .macro
    cmp #$01
    beq \1
.endm

if_fac1_lt_fac2 .macro
    cmp #$ff
    beq \1
.endm

if_fac1_eq_fac2 .macro
    cmp #$00
    beq \1
.endm

if_fac1_gt_fac2 .macro
    cmp #$01
    beq \1
.endm

;--------------------------------------------------------------- macro graph

copy_u16    .macro
    lda \2
    sta \1
    lda \2+1
    sta \1+1
.endm

graph_imm_x  .macro
    lda <\1
    sta zpWord0
    ldy >\1
    sty zpWord0+1
.endm

graph_var_x  .macro
    lda \1
    sta zpWord0
    ldy \1+1
    sty zpWord0+1
.endm

graph_imm_y  .macro
    lda \1
    sta zpy
.endm

graph_var_y  .macro
    lda \1
    sta zpy
.endm


;--------------------------------------------------------------- macro

u8_type  .macro
    \1    .byte    \2
.endm

s8_type   .macro
    \1    .char    \2
.endm

u16_type   .macro
    \1    .word    \2
.endm

s16_type   .macro
    \1    .sint    \2
.endm

cstring_type   .macro
    \1    .null    \2
.endm

pstring_type   .macro
    \1    .null    \2 , \3
.endm

;******
;       mem
;******

mem .proc

    ; ........................................... mem.copy
    ;
    ;   input   :
    ;               source address  ->  zpWord0
    ;               dest   address  ->  zpWord1
    ;               ay              ->  size
    ;   output  :
    ;               //
    
   copy    .proc
     
                cpy  #0
                bne  _longcopy

                ; copy <= 255 bytes
                tay
                bne  _copyshort
                rts     ; nothing to copy

    _copyshort
                ; decrease source and target pointers so we can simply index by Y
                lda  zpWord0
                bne  +
                dec  zpWord0+1
    +           dec  zpWord0
                lda  zpWord1
                bne  +
                dec  zpWord1+1
    +           dec  zpWord1

    -           lda  (zpWord0),y
                sta  (zpWord1),y
                dey
                bne  -
                rts

    _longcopy
                sta  zpy        ; lsb(count) = remainder in last page
                tya
                tax                         ; x = num pages (1+)
                ldy  #0
    -           lda  (zpWord0),y
                sta  (zpWord1),y
                iny
                bne  -
                inc  zpWord0+1
                inc  zpWord1+1
                dex
                bne  -
                ldy  zpy
                bne  _copyshort
                rts
    .pend

    ; ........................................... mem.set
    ;
    ;   input   :   
    ;               zpWord0     begin
    ;               xy          length
    ;               a           value

    set_byte          .proc
    
            ; -- fill memory from (zpWord0), length XY, with value in A.
            
            stx  zpy
            sty  zpx
            ldy  #0
            ldx  zpx
            beq  _lastpage
    _fullpage    
            sta  (zpWord0),y
            iny
            bne  _fullpage
            inc  zpWord0+1          ; next page
            dex
            bne  _fullpage
    _lastpage    
            ldy  zpy
            beq  +
    -             
            dey
            sta  (zpWord0),y
            bne  -
    +               
            rts

    .pend
    
    ; ........................................... mem.set_word
    ;
    ;   input   :   
    ;               zpWord0     begin
    ;               zpWord1     length
    ;               ay          value

    set_word        .proc

        ; --    fill memory from (zpWord0) 
        ;       number of words in zpWord1, 
        ;       with word value in AY.
        
            sta  _mod1+1                    ; self-modify
            sty  _mod1b+1                   ; self-modify
            sta  _mod2+1                    ; self-modify
            sty  _mod2b+1                   ; self-modify
            ldx  zpWord0
            stx  zpWord2
            ldx  zpWord0+1
            inx
            stx  zpx                ; second page

            ldy  #0
            ldx  zpWord1+1
            beq  _lastpage
    _fullpage
    _mod1           
            lda  #0                 ; self-modified
            sta  (zpWord0),y        ; first page
            sta  (zpWord2),y        ; second page
            iny
    _mod1b        lda  #0                         ; self-modified
            sta  (zpWord0),y        ; first page
            sta  (zpWord2),y        ; second page
            iny
            bne  _fullpage
            inc  zpWord0+1          ; next page pair
            inc  zpWord0+1          ; next page pair
            inc  zpWord2+1          ; next page pair
            inc  zpWord2+1          ; next page pair
            dex
            bne  _fullpage
    _lastpage    
            ldx  zpWord1
            beq  _done

            ldy  #0
    -
    _mod2           
            lda  #0                         ; self-modified
            sta  (zpWord0), y
            inc  zpWord0
            bne  _mod2b
            inc  zpWord0+1
    _mod2b          
            lda  #0                         ; self-modified
            sta  (zpWord0), y
            inc  zpWord0
            bne  +
            inc  zpWord0+1
    +               
            dex
            bne  -
    _done        
            rts
            
    .pend

    ; ........................................... mem.copy_npage_from_to
    ;
    ;   input   :   
    ;               zpWord0     from
    ;               zpWord1     to
    ;               xy          length

    copy_npage_from_to    .proc
    
        ; -- copy memory from (zpWord0) to (zpWord1) of length X/Y (16-bit, X=lo, Y=hi)

            source  = zpWord0
            dest    = zpWord1
            length  = zpWord2   ; (and SCRATCH_ZPREG)

            stx  length
            sty  length+1

            ldx  length             ; move low byte of length into X
            bne  +                  ; jump to start if X > 0
            dec  length             ; subtract 1 from length
    +        
            ldy  #0                 ; set Y to 0
    -        
            lda  (source),y         ; set A to whatever (source) points to offset by Y
            sta  (dest),y           ; move A to location pointed to by (dest) offset by Y
            iny                     ; increment Y
            bne  +                  ; if Y<>0 then (rolled over) then still moving bytes
            inc  source+1           ; increment hi byte of source
            inc  dest+1             ; increment hi byte of dest
    +        
            dex                     ; decrement X (lo byte counter)
            bne  -                  ; if X<>0 then move another byte
            dec  length             ; we've moved 255 bytes, dec length
            bpl  -                  ; if length is still positive go back and move more
            rts                     ; done
            
    .pend
    
    ; -- in-place 8-bit ror of byte at memory location in AY
    
    ror2_ub    .proc
            sta  zpWord0
            sty  zpWord0+1
            ldy  #0
            lda  (zpWord0),y
            lsr  a
            bcc  +
            ora  #$80
    +        
            sta  (zpWord0),y
            rts
    .pend
    
    ; -- in-place 8-bit rol of byte at memory location in AY

    rol2_ub    .proc
            sta  zpWord0
            sty  zpWord0+1
            ldy  #0
            lda  (zpWord0),y
            cmp  #$80
            rol  a
            sta  (zpWord0),y
            rts
    .pend

    
.pend

    ;................................................. macro compare
    
    ;                                             unsigned 8 cmp
    
    u8_cmp_lt   .macro      ;   <
        bcc \1
    .endm
    
    u8_cmp_le   .macro      ;   <=
        beq \1
        bcc \1
    .endm
    
    u8_cmp_gt   .macro      ;   >
      .block
        beq +
        bcs \1
      +
     .endblock
    .endm
    
    u8_cmp_ge   .macro      ;   >=
        bcs \1
    .endm

    u8_cmp_eq   .macro      ;   ?=
        beq \1
    .endm

    u8_cmp_ne   .macro      ;   !=
        bne \1
    .endm

    ;                                             signed 8 cmp
    
    s8_cmp_lt   .macro      ;   <
        bmi \1
    .endm

    s8_cmp_le   .macro      ;   <=
        beq \1
        bmi \1
    .endm

    s8_cmp_gt   .macro      ;   >
      .block
        beq +
        bpl \1
      +
     .endblock
    .endm

    s8_cmp_ge   .macro      ;   >=
        bpl   \1
    .endm
    
    s8_cmp_eq   .macro      ;   ?=
        beq \1
    .endm

    s8_cmp_ne   .macro      ;   !=
        bne \1
    .endm
    
;******
;       irq
;******

    irq .proc

        begin   .proc

            jsr sys.status.save

            rts
            
        .pend
        
        end   .proc

            jsr sys.status.restore
            
            rts

        .pend
        
        ; .........................................    set_rasterirq

        ;   zpWord0     :   raster pos
        ;   ay          :   callback
        ;   c           :   use kernal
            
        set_raster   .proc

            sta  _modified+1            ;   ay
            sty  _modified+2
            
            ;   lda  #0                 ;   c
            ;   adc  #0
            ;   sta  set_irq._use_kernal
            
            lda  zpWord0                ;   zpWord0
            ldy  zpWord0+1
            sei
            
            jsr  _setup_raster_irq
            
            lda  #<_raster_irq_handler
            sta  c64.CINV               ;   $0314
            lda  #>_raster_irq_handler
            sta  c64.CINV+1
            
            cli
            rts

        _setup_raster_irq
        
            pha
            lda  #%01111111
            sta  c64.CIA1ICR    ; "switch off" interrupts signals from cia-1
            sta  c64.CIA2ICR    ; "switch off" interrupts signals from cia-2
            and  c64.SCROLY
            sta  c64.SCROLY     ; clear most significant bit of raster position
            lda  c64.CIA1ICR    ; ack previous irq
            lda  c64.CIA2ICR    ; ack previous irq
            pla
            sta  c64.RASTER     ; set the raster line number where interrupt should occur
            cpy  #0
            beq  +
            lda  c64.SCROLY
            ora  #%10000000
            sta  c64.SCROLY     ; set most significant bit of raster position
        +   
            lda  #%00000001
            sta  c64.IREQMASK   ; enable raster interrupt signals from vic
            rts
            
        _raster_irq_handler

            jsr  begin

            _modified
            jsr  $ffff          ; modified          callback

            jsr  end

            lda  #$ff
            sta  c64.VICIRQ     ; $D019 acknowledge raster irq

            jmp  c64.IRQDFRT    ; $EA31 continue with kernal irq routine

        .pend

        ; .........................................    restore

        restore .proc

            sei
            lda  #<c64.IRQDFRT
            sta  c64.CINV
            lda  #>c64.IRQDFRT
            sta  c64.CINV+1
            lda  #0
            sta  c64.IREQMASK   ; disable raster irq
            lda  #%10000001
            sta  c64.CIA1ICR    ; restore CIA1 irq
            cli
            
            rts
            
        .pend
    
    .pend

;;;
;;
;