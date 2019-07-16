;***********************************************************
;*
;*	File name: ece375_L4.asm,
;*
;*	Display string to LCD pf mega128
;*
;*	This is the skeleton file for Lab 4 of ECE 375
;*
;***********************************************************
;*
;*	 Author: Andrew Collins
;*	   Date: 10/17/2017
;*
;***********************************************************

.include "m128def.inc"			; Include definition file

;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def	mpr = r16				; Multipurpose register is
								; required for LCD Driver

;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg							; Beginning of code segment

;***********************************************************
;*	Interrupt Vectors
;***********************************************************
.org	$0000					; Beginning of IVs
		rjmp INIT				; Reset interrupt

.org	$0046					; End of Interrupt Vectors

;***********************************************************
;*	Program Initialization
;***********************************************************
INIT:							; The initialization routine
		; Initialize Stack Pointer
		LDI		R16, low(RAMEND)
		OUT		SPL, R16
		LDI		R16, high(RAMEND)
		OUT		SPH, R16
		; Initialize LCD Display
		rcall	LCDInit ;Initialize the LCD
		
		; Move strings from Program Memory to Data Memory

		ldi ZH, high(STRING_BEG<<1) ;init Z point to the proMem
		ldi ZL, low(STRING_BEG<<1)
		ldi YH, high(STRING_END<<1) ;init Y point to the end address of string
		ldi YL, low(STRING_END<<1)
		ldi XL,$00; init dataMem address
		ldi XH,$01
; Move strings from Program Memory to Data Memory
	LOOP:
		lpm mpr,Z+ 
		st  X+,mpr
		cp  YL,ZL
		brne  Loop

		ldi ZH, high(STRING2_BEG<<1) ;init Z point to the proMem
		ldi ZL, low(STRING2_BEG<<1)
		ldi YH, high(STRING2_END<<1) ;init Y point to the end address of string2
		ldi YL, low(STRING2_END<<1)
		ldi XL,$10; init dataMem address for string2
		ldi XH,$01
; Move strings from Program Memory to Data Memory
	LOOP2:
		lpm mpr,Z+ 
		st  X+,mpr
		cp  YL,ZL
		brne  Loop2

		; NOTE that there is no RET or RJMP from INIT, this
		; is because the next instruction executed is the
		; first instruction of the main program

;***********************************************************
;*	Main Program
;***********************************************************
MAIN:							; The Main program
		; Display the strings on the LCD Display

		rcall LCDWrite

		rjmp	MAIN			; jump back to main and create an infinite
								; while loop.  Generally, every main program is an
								; infinite while loop, never let the main program
								; just run off

;***********************************************************
;*	Functions and Subroutines
;***********************************************************

;-----------------------------------------------------------
; Func: Template function header
; Desc: Cut and paste this and fill in the info at the 
;		beginning of your functions
;-----------------------------------------------------------
FUNC:							; Begin a function with a label
		; Save variables by pushing them to the stack

		; Execute the function here
		
		; Restore variables by popping them from the stack,
		; in reverse order

		ret						; End a function with RET

;***********************************************************
;*	Stored Program Data
;***********************************************************

;-----------------------------------------------------------
; An example of storing a string. Note the labels before and
; after the .DB directive; these can help to access the data
;-----------------------------------------------------------
STRING_BEG:
.DB		"Kaiyuan Andrew"		; Declaring data in ProgMem
STRING_END:

STRING2_BEG:
.DB		"Hello World!"
STRING2_END:
;***********************************************************
;*	Additional Program Includes
;***********************************************************
.include "LCDDriver.asm"		; Include the LCD Driver
