; include all the test macros from the file inserted earlier; required
.include "test_framework.s"

; == EXAMPLE TESTS ==
; The macro checks if the a register has the literal value 1
lda #1
a_eq_literal 1 ; succeeds

clc
adc #1
a_eq_literal 2 ; succeeds

; There is test macros for checking if an address has a certain literal value
lda #25
sta $15
val_eq_literal $15, #25 ; succeeds

; Another one for 16 bit values
lda $C0
sta my_lo_addr
lda $A5
sta my_hi_addr
val16_eq_literal my_lo_addr, my_hi_addr, $A5C0 ; succeeds
