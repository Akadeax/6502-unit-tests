# 6502 (NES) Unit Tests
Unit testing is a near-necessary feature for medium-to-large-sized programs. There is no unified solution for this in 6502 assembly; this project attempts to offer one.

## Setup
add an additional source file to contain your tests (in this example, `tests.s`). In the same directory, insert the file `test_framework.s`.

Start your programs reset procedure with disabling interrupts and then `.include "tests.s"`, i.e.:
```x86asm
.proc reset
    lda #0
    sta PPU_CONTROL ; disable NMI; your PPUCTRL register address might use a different name
    sei ; mask interrupts

	.include "tests.s"
	... ; rest of your reset procedure
```
The above assumes `ca65`; if you use a different assembler, use the approriate syntax.

## Writing Tests

Once this is set up, you can start writing tests in `tests.s`:
```x86asm
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

; calling a function
jsr calculate_my_values
pla
a_eq_literal #5 ; if calculate_my_values pushed 5 on the stack as output, suceeds
```
If you need further and more complex examples of usage, see [Nespad](https://github.com/Akadeax/nespad), a NES text editor that uses this framework.

## Debugging Failed Tests
When a test fails, the program enters an infinite loop, effectively halting execution. If your program does not run in your emulator, this means a test has failed.

Using your emulator's memory inspector, view memory address `$0`. This contains the index of the test that has failed.

If your `tests.s` has 6 calls to `*_eq_literal` macros and memory address `$0` contains the value `2`, that means your second test has failed.

# License
This is public domain, [Unlicense](https://unlicense.org/) specifically. Do whatever you want with it.
