;***********************************************************
;*
;*	Name of file:kaiyuan_fan_and_andrew_collins_Lab6_challengecode.asm
;*
;*	This program provides the basic behavior that allows the TekBot to react to whisker input. 
; The TekBot has two forward facing buttons, or whiskers, a left and a right whisker. 
; By default the TekBot will be moving forward until one of the whiskers are triggered. 
; If the left whisker is hit, then the TekBot will backup and then turn right for a bit, 
;while a right whisker hit will backup and turn left.  After the either whisker routine completes,
; the TekBot resumes its forward motion. 
;The challenge Problem for this lab, introduces �memory� to the TEKBOT, 
;so depending on different situation the BOT will add additional reactions.  
;Additional reaction include: If BOT is stuck in corner, then reverse like normal 
;but then turn away 180 degrees. And if the same whisker is hit twice in a row reverse
; like normal but turn away for twice as long.
;The program uses the interrupt method. When a whisker is hit, an interrupt 
;signal is sent to the program. When an interrupt request comes in, the processor 
;has to stop what it is doing, save its current place in the program 
;(including storing any in-use or otherwise special variables), 
;and then it can service the interrupt.
;***********************************************************
;*
;*	 Author: Andrew Collins
;*	   Date: 11/1/17
;*
;***********************************************************

.include "m128def.inc"			; Include definition file

;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def	mpr = r16	; Multipurpose register 
.def	waitcnt = r17	; Wait Loop Counter
.def	ilcnt = r18		; Inner Loop Counter
.def	olcnt = r19		; Outer Loop Counter

.def	rcount = r20	; Hit right count
.def	lcount = r21	; Outer Loop Counter

.def	alternating_rcount = r22	; Hit right count
.def	alternating_lcount = r23	;  Hit right count


.equ	WTime = 100		; Time to wait in wait loop was 

.equ	WskrR = 0	; Right Whisker Input Bit
.equ	WskrL = 1	; Left Whisker Input Bit
.equ	EngEnR = 4	; Right Engine Enable Bit
.equ	EngEnL = 7	; Left Engine Enable Bit
.equ	EngDirR = 5		; Right Engine Direction Bit
.equ	EngDirL = 6		; Left Engine Direction Bit

.equ	MovFwd = (1<<EngDirR|1<<EngDirL)	; Move Forward Command
.equ	MovBck = $00	; Move Backward Command
.equ	TurnR = (1<<EngDirL)	; Turn Right Command
.equ	TurnL = (1<<EngDirR)	; Turn Left Command
.equ	Halt = (1<<EngEnR|1<<EngEnL)	; Halt Command

;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg							; Beginning of code segment

;***********************************************************
;*	Interrupt Vectors
;***********************************************************
.org	$0000					; Beginning of IVs
		rjmp 	INIT			; Reset interrupt
; Set up interrupt vectors for any interrupts being used
.org	$0002
		rcall  HitRight
		reti
.org	$0004
		rcall HitLeft
		reti
		

.org	$0046					; End of Interrupt Vectors

;***********************************************************
;*	Program Initialization
;***********************************************************
INIT:		; The initialization routine
		
		; Initialize Stack Pointer
		ldi		mpr, low(RAMEND)
		out		SPL, mpr		; Load SPL with low byte of RAMEND
		ldi		mpr, high(RAMEND)
		out		SPH, mpr		; Load SPH with high byte of RAMEND

		; Initialize Port B for output
		ldi		mpr, $FF		; Set Port B Data Direction Register
		out		DDRB, mpr		; for output
		ldi		mpr, $00		; Initialize Port B Data Register
		out		PORTB, mpr		; so all Port B outputs are low	

		; Initialize Port D for input
		ldi		mpr, $00		; Set Port D Data Direction Register
		out		DDRD, mpr		; for input
		ldi		mpr, $FF		; Initialize Port D Data Register
		out		PORTD, mpr		; so all Port D inputs are Tri-State

		; Initialize external interrupts
		ldi mpr, (1<<ISC01)|(0<<ISC00)|(1<<ISC11)|(0<<ISC10)
		sts EICRA, mpr ; Use sts, EICRA is in extended I/O space

		; Configure the External Interrupt Mask
		; Set the Interrupt Sense Control to falling edge 
			ldi mpr, (1<<INT0)|(1<<INT1)
			out EIMSK, mpr
			
			sei ; Turn on interrupts
		
;***********************************************************
;*	Main Program
;***********************************************************
MAIN:							; The Main program
		;Move Bot forward
		ldi mpr, MovFwd
		out PORTB, mpr

		rjmp	MAIN			; Create an infinite loop 
		

;***********************************************************
;*	Functions and Subroutines
;***********************************************************
;----------------------------------------------------------------
; Sub:	HitRight
; Desc:	Handles functionality of the TekBot when the right whisker
;is triggered. Move BOT back for one second, then makes calls to
; Back_R( right whisker is hit twice in a row) or
;One_eighty_left(when alternating hits 5 times in a row),or
; else turn left for one sec
;----------------------------------------------------------------
HitRight:
		
		push	mpr			; Save mpr register
		push	waitcnt			; Save wait register
		in		mpr, SREG	; copy program state
		push	mpr		; save program state

		clr		lcount ;reset count
		ldi		mpr,$01
		add		rcount,mpr ;increment count
		ldi		mpr,$02
		cp		rcount,mpr ;check is right wisker was hit 2 times in a row
		breq	Back_R	;if right wisker was hit two times go to Back_R


		ldi		mpr,$01
		add		alternating_rcount,mpr ;increment count

		; Move Backwards for a second
		ldi		mpr, MovBck	; Load Move Backward command
		out		PORTB, mpr	; Send command to port
		ldi		waitcnt, WTime	; Wait for 1 second
		rcall	Wait			; Call wait function

		; Turn left for a second                                           
		ldi		mpr, TurnL	; Load Turn Left Command
		out		PORTB, mpr	; Send command to port
		ldi		waitcnt, WTime	; Wait for 1 second
		rcall	Wait			; Call wait function

		;check to see if BOT in corner
		ldi		mpr,$05
		cp		alternating_lcount,mpr
		breq	One_eighty_left
		
		pop		mpr		; 
		out		SREG, mpr	;Restore program state
		pop		waitcnt		; Restore wait register
		pop		mpr		; Restore mpr
		
		ldi mpr, (1<<INTF0)|(1<<INTF1)
		out EIFR, mpr ;clear interrupt flag register				

		ret

;----------------------------------------------------------------
; Sub:	One_eighty_left
; Description:	When TEKBOT hits alternating whiskers 5 times, reverse like normal,
;but then turn 180 degrees. This function does the turn 180 degrees, assuming 
;turning the left motor on for 5 seconds turns the TEKBOT 180 degrees.
;----------------------------------------------------------------
One_eighty_left:

		cp		alternating_rcount,alternating_lcount
		brne	Return1

		;turn for (one from HitRight) 1+4 seconds
		rcall	Wait
		rcall	Wait
		rcall	Wait
		rcall	Wait

		clr		alternating_rcount ;reset count
		clr		alternating_lcount ;reset count
		clr     lcount ;reset count
		clr		rcount ;reset count

		ldi mpr, (1<<INTF0)|(1<<INTF1)
		out EIFR, mpr ;clear interrupt flag register

		ret
;----------------------------------------------------------------
; Sub:	Return1
; Description:	Called from One_eighty_left, if right alternating count 
;and left alternating count not equal to 5 
;----------------------------------------------------------------			
Return1:
		ldi mpr, (1<<INTF0)|(1<<INTF1)
		out EIFR, mpr ;clear interrupt flag register				

		rjmp MAIN

;----------------------------------------------------------------
; Sub:	Back_R
; Description:	When TEKBOT right whisker is hit twice in a row, 
;reverse like normal(one second) then, TEKBOT will turn away twice 
;as long as normal
;----------------------------------------------------------------
Back_R:
		push	mpr			; Save mpr register
		push	waitcnt			; Save wait register
		in		mpr, SREG	; Save program state
		push	mpr			;

		clr     lcount ;reset count
		clr		rcount ;reset count
		clr		alternating_rcount ;reset count
		clr		alternating_lcount ;reset count

				; Move Backwards for a second
		ldi		mpr, MovBck	; Load Move Backward command
		out		PORTB, mpr	; Send command to port
		ldi		waitcnt, WTime	; Wait for 1 second
		rcall	Wait			; Call wait function

		; Turn right for 2 second
		ldi		mpr, TurnL	; Load Turn Left Command
		out		PORTB, mpr	; Send command to port
		ldi		waitcnt, WTime	; Wait for 1 second
		rcall	Wait	; Call wait function
		rcall	Wait	; Call wait function
			
		pop		mpr	; Restore program state
		out		SREG, mpr	;Restore status reg
		pop		waitcnt	; Restore wait register
		pop		mpr	; Restore mpr

		ldi mpr, (1<<INTF0)|(1<<INTF1)
		out EIFR, mpr	;clear interrupt flag register
			
		ret

;******************************************************************************

;----------------------------------------------------------------
; Sub:	HitLeft
; Desc:	Handles functionality of the TekBot when the left whisker
;is triggered. Move BOT back for one second, then makes calls to
; Back_L( left wisker is hit twice in a row) or
;One_eighty_left(when alternating hits 5 times in a row),or
; else turn right for one sec
;----------------------------------------------------------------
HitLeft:
		push	mpr			; Save mpr register
		push	waitcnt			; Save wait register
		in		mpr, SREG	; copy program state
		push	mpr			;Save program state

		clr		rcount ;reset count
		ldi		mpr,$01
		add		lcount,mpr ;increment count
		ldi		mpr,$02
		cp		lcount, mpr ;check is left wisker was hit 2 times in a row
		breq	Back_L ;if left wisker was hit two times go to Back_L

		ldi		mpr,$01
		add		alternating_lcount,mpr ;increment count

		; Move Backwards for a second
		ldi		mpr, MovBck	; Load Move Backward command
		out		PORTB, mpr	; Send command to port
		ldi		waitcnt, WTime	; Wait for 1 second
		rcall	Wait			; Call wait function

		; Turn right for a second
		ldi		mpr, TurnR	; Load Turn Left Command
		out		PORTB, mpr	; Send command to port
		ldi		waitcnt, WTime	; Wait for 1 second
		rcall	Wait			; Call wait function

		;check to see if BOT in corner
		ldi		mpr,$05
		cp		alternating_rcount,mpr
		breq	One_eighty_right

		pop		mpr		; Restore program state
		out		SREG, mpr	;Restore status reg
		pop		waitcnt		; Restore wait register
		pop		mpr		; Restore mpr
		
		ldi mpr, (1<<INTF0)|(1<<INTF1)
		out EIFR, mpr ;clear interrupt flag register				

		ret

;----------------------------------------------------------------
; Sub:	One_eighty_left
; Description:	When TEKBOT hits alternating whiskers 5 times, reverse like normal,
;but then turn 180 degrees. This function does the turn 180 degrees, assuming 
;turning the right motor on for 5 seconds turns the TEKBOT 180 degrees.
;----------------------------------------------------------------
One_eighty_right:
		
		
		cp		alternating_rcount,alternating_lcount
		brne	Return2 ;if right bump and left bump count not 5

		;turn for (one from HitLeft) 1+4 seconds
		rcall	Wait
		rcall	Wait
		rcall	Wait
		rcall	Wait

		clr		alternating_rcount ;reset count
		clr		alternating_lcount ;reset count
		clr     lcount ;reset count
		clr		rcount ;reset count

		ldi mpr, (1<<INTF0)|(1<<INTF1)
		out EIFR, mpr	;clear interrupt flag register

		ret

;----------------------------------------------------------------
; Sub:	Return2
; Description:	Called from One_eighty_right, if right alternating count 
;and left alternating count not equal to 5 
;----------------------------------------------------------------	
Return2:
		ldi mpr, (1<<INTF0)|(1<<INTF1)
		out EIFR, mpr ;clear interrupt flag register				

		rjmp MAIN

;----------------------------------------------------------------
; Sub:	Back_L
; Description:When TEKBOT left whisker is hit twice in a row, 
;reverse like normal(one second) then, TEKBOT will turn away twice 
;as long as normal
;----------------------------------------------------------------
Back_L:
		push	mpr			; Save mpr register
		push	waitcnt			; Save wait register
		in		mpr, SREG	; Save program state
		push	mpr			;

		clr     lcount ;reset count
		clr		rcount ;reset count
		clr		alternating_rcount ;reset count
		clr		alternating_lcount ;reset count

		
				; Move Backwards for a second
		ldi		mpr, MovBck	; Load Move Backward command
		out		PORTB, mpr	; Send command to port
		ldi		waitcnt, WTime	; Wait for 1 second
		rcall	Wait			; Call wait function

		; Turn right for 2 second
		ldi		mpr, TurnR	; Load Turn right Command
		out		PORTB, mpr	; Send command to port
		ldi		waitcnt, WTime	; Wait for 1 second
		rcall	Wait			; Call wait function
		rcall	Wait			; Call wait function

			
		pop		mpr		; Restore program state
		out		SREG, mpr	;
		pop		waitcnt		; Restore wait register
		pop		mpr		; Restore mpr
		
		ldi mpr, (1<<INTF0)|(1<<INTF1)
		out EIFR, mpr ;clear interrupt flag register

	ret 

;----------------------------------------------------------------
; Sub:	Wait
; Desc:	A wait loop that is 16 + 159975*waitcnt cycles or roughly 
;		waitcnt*10ms.  Just initialize wait for the specific amount 
;		of time in 10ms intervals. Here is the general eqaution
;		for the number of clock cycles in the wait loop:
;			((3 * ilcnt + 3) * olcnt + 3) * waitcnt + 13 + call
;----------------------------------------------------------------
Wait:
		push	waitcnt			; Save wait register
		push	ilcnt			; Save ilcnt register
		push	olcnt			; Save olcnt register

Loop:	ldi		olcnt, 224		; load olcnt register
OLoop:	ldi		ilcnt, 237		; load ilcnt register
ILoop:	dec		ilcnt			; decrement ilcnt
		brne	ILoop			; Continue Inner Loop
		dec		olcnt		; decrement olcnt
		brne	OLoop			; Continue Outer Loop
		dec		waitcnt		; Decrement wait 
		brne	Loop			; Continue Wait loop	

		pop		olcnt		; Restore olcnt register
		pop		ilcnt		; Restore ilcnt register
		pop		waitcnt		; Restore wait register
		ret				; Return from subroutine
;-----------------------------------------------------------
;	You will probably want several functions, one to handle the 
;	left whisker interrupt, one to handle the right whisker 
;	interrupt, and maybe a wait function
;------------------------------------------------------------

;-----------------------------------------------------------
; Func: Template function header
; Desc: Cut and paste this and fill in the info at the 
;		beginning of your functions
;-----------------------------------------------------------
FUNC:	; Begin a function with a label

		; Save variable by pushing them to the stack

		; Execute the function here
		
		; Restore variable by popping them from the stack in reverse order

		ret						; End a function with RET

;***********************************************************
;*	Stored Program Data
;***********************************************************

; Enter any stored data you might need here

;***********************************************************
;*	Additional Program Includes
;***********************************************************
; There are no additional file includes for this program
