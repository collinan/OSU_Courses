;***********************************************************
;*
;*File Name: kaiyuan_fan_and_andrew_collins_Lab8_RX_sourcecode.asm
;*Course: ECE 375
;This is the RECEIVE file for Lab 8 of ECE 375
;*This program is used to receive signals from the remote, and 
;*control the bot. When the bot receives a freeze code (0b11111000) from 
;*the remote, it will immediately transmit a stand alone “freeze signal”
;* 0b01010101, to the other bots, when this signal is received the bot 
;*freezes for 5 seconds, not responding to any command from the remote, 
;*after this is should resume its tasks. After being frozen three times 
;*the robot requires a reset. In addition to the previous tasks the 
;*bot also performs the BumpBot routine using inturrupts from lab 1. 
;***********************************************************
;*
;*	 Author: Andrew Collins
;*	   Date: 11/29/2017
;*
;***********************************************************

.include "m128def.inc"			; Include definition file

;***********************************************************
;*	Internal Register Definitions and Constants
;***********************************************************
.def	mpr = r16				; Multi-Purpose Register
.def temp = r20
.def temp1= r22
.def temp2=r23
.def	waitcnt = r17				; Wait Loop Counter
.def	ilcnt = r18				; Inner Loop Counter
.def	olcnt = r19				; Outer Loop Counter
.def	freeze_count = r21

.equ	WTime = 100			; Time to wait in wait loop was 
.equ	BackTime = 100		; Time to wait in wait loop for moving back

.equ	WskrR = 0				; Right Whisker Input Bit
.equ	WskrL = 1				; Left Whisker Input Bit
.equ	EngEnR = 4				; Right Engine Enable Bit
.equ	EngEnL = 7				; Left Engine Enable Bit
.equ	EngDirR = 5				; Right Engine Direction Bit
.equ	EngDirL = 6				; Left Engine Direction Bit

.equ	BotAddress = $3A;(Enter your robot's address here (8 bits))

;/////////////////////////////////////////////////////////////
;These macros are the values to make the TekBot Move.
;/////////////////////////////////////////////////////////////
.equ	MovFwd =  (1<<EngDirR|1<<EngDirL)	;0b01100000 Move Forward Action Code
.equ	MovBck =  $00						;0b00000000 Move Backward Action Code
.equ	TurnR =   (1<<EngDirL)				;0b01000000 Turn Right Action Code
.equ	TurnL =   (1<<EngDirR)				;0b00100000 Turn Left Action Code
.equ	Halt =    (1<<EngEnR|1<<EngEnL)		;0b10010000 Halt Action Code

;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg							; Beginning of code segment

;***********************************************************
;*	Interrupt Vectors
;***********************************************************
.org	$0000			; Beginning of IVs
		rjmp 	INIT	; Reset interrupt

;Interrupt vectors for:
;- Right whisker
.org	$0002
		rcall  HitRight
		reti
;- Left whisker
.org	$0004
		rcall HitLeft
		reti
;- USART receive
.org	$003C
	rcall Receive
	reti

.org	$0046		; End of Interrupt Vectors

;***********************************************************
;*	Program Initialization
;***********************************************************
;-----------------------------------------------------------
; Func:	INIT
; Desc:	One time configuration of registers need to run program
;-----------------------------------------------------------
INIT:
	;Stack Pointer (VERY IMPORTANT!!!!)
	ldi		mpr, low(RAMEND)
	out		SPL, mpr		; Load SPL with low byte of RAMEND
	ldi		mpr, high(RAMEND)
	out		SPH, mpr		; Load SPH with high byte of RAMEND

	;I/O Ports
	; Initialize Port B for output
		ldi		mpr, $FF		; Set Port B Data Direction Register
		out		DDRB, mpr		; for output
		ldi		mpr, $00		; Initialize Port B Data Register
		out		PORTB, mpr		; so all Port B outputs are low	

	; Initialize Port D for input
		ldi		mpr, (1<<PD3)	;Port D pin 3(TXD1) for output
		out		DDRD, mpr
		ldi		mpr, $FF	; Initialize Port D Data Register
		out		PORTD, mpr	; so all Port D inputs are Tri-State

	;USART1
		;Set baudrate at 2400bps
		ldi mpr, high (416) ;Load high byte of 0x0340
		sts UBRR1H, mpr		;
		ldi mpr, low(416)	;Load low byte of 0x0340
		sts UBRR1L, mpr

		;Enable receiver and enable receive interrupts
		ldi mpr, (1<<TXEN1 | 1<<RXEN1 | 1<<RXCIE1) ;
		sts UCSR1B, mpr		;enable transmitter

		;Set frame format: 8 data bits, 2 stop bits
		ldi mpr,(0<<UMSEL1 | 1<<USBS1 | 1<<UCSZ11 | 1<<UCSZ10)
		sts UCSR1C, mpr

	;External Interrupts
		
		;Set the External Interrupt Mask
		ldi mpr, (1<<INT0)|(1<<INT1)
		out EIMSK, mpr
		;Set the Interrupt Sense Control to falling edge detection
		ldi mpr, (1<<ISC01)|(0<<ISC00)|(1<<ISC11)|(0<<ISC10)
		sts EICRA, mpr ; Use sts, EICRA is in extended I/O space
		sei
;***********************************************************
;*	Main Program
;***********************************************************
;-----------------------------------------------------------
; Func:MAIN
; Desc:	
;Forever looped main routine, when interrupts occurs program jumps 
;out of main.
;-----------------------------------------------------------
MAIN:
		rjmp	MAIN

;***********************************************************
;*	Functions and Subroutines
;***********************************************************
;-----------------------------------------------------------
; Func:Receive
; Desc:	When USART1 recieves data.
;The receive routine will first check the receiving code with freeze 
;signal 0b010101010. If it’s matching, branch to the halting routine 
;perform the freezing behavior. Otherwise jump to the Receive1 routine.
;-----------------------------------------------------------
Receive:
		 
		lds	mpr,UDR1
		cpi	mpr,0b01010101
		breq Halting
		rcall Receive1
		ret

;-----------------------------------------------------------
; Func:Halting
; Desc:	
;The halting routine check the count of freeze time first. 
; If counter reaches three times, jump to the frozen routine.
;Otherwise, perform the halting behavior not responding to 
;whiskers, and not responding to commands or other freeze
; signals for five seconds. Also, increment the freeze_couter by one.
;-----------------------------------------------------------
Halting:
		cpi	freeze_count,$03
		breq	Frozen
		ldi		waitcnt, WTime	; Wait for 5 second

		ldi mpr, (0<<TXEN1 | 0<<RXEN1 | 0<<RXCIE1) ;
		sts UCSR1B, mpr	
		rcall	Wait			; Call wait function
		rcall	Wait
		rcall	Wait
		rcall	Wait
		rcall	Wait
		ldi mpr, (1<<INTF0)|(1<<INTF1)
		out EIFR, mpr ;clear interrupt flag register
		ldi mpr, (1<<TXEN1 | 1<<RXEN1 | 1<<RXCIE1) ;
		sts UCSR1B, mpr	
		inc freeze_count
		ret
;-----------------------------------------------------------
; Func:Frozen
; Desc:	The frozen routine is a forever loop routine  performs the 
;frozen behavior.
;-----------------------------------------------------------
Frozen:
		ldi mpr, (0<<TXEN1 | 0<<RXEN1 | 0<<RXCIE1) ;
		sts UCSR1B, mpr	
		clr freeze_count
		rjmp Frozen

;-----------------------------------------------------------
; Func:Receive1
; Desc:	The receive1 routine will first check the
; receiving code with robot address which is $2A. 
;f it’s matching, branch to Continue routine. Otherwise
;, do no action.
;-----------------------------------------------------------
Receive1:
		cpi	mpr,$3A ;check robotaddress
		breq Continue
		ret
;-----------------------------------------------------------
; Func:Continue
; Desc:	The continue routine will first
; rotate left of  receiving code and then output to the port B.
;It will compare the receiving code with send freeze action code 0b11110000
;(after rotating left). If it’s matching, branch to Send_Freeze routine.
;-----------------------------------------------------------
Continue:
 
		lds mpr,UDR1
		
		cpi	mpr,0b11111000
		breq Send_Freeze
		lsl mpr
	
		cpi mpr,0b10100000
		brne OUT_p
		ret

OUT_P:
		out PORTB,mpr
		ret
;-----------------------------------------------------------
; Func:Send_Freeze
; Desc:	The Send_Freeze routine will first check if the UDR1
; is empty and then store freeze signal 0b010101010 to UDR1. 
;This transmit the freeze signals to other robots.
;-----------------------------------------------------------
Send_Freeze:
		
		ldi mpr,0b01010101;freeze signal
		sts UDR1, mpr
		rcall USART_Transmit
		
		ret
;-----------------------------------------------------------
; Func:USART_Transmit
; Desc:	The USART_Transmit routine is called whenever a freeze signal/code is 
;remotely being sent from bot to other bots via USART 1.
;-----------------------------------------------------------
USART_Transmit:
	lds temp, UCSR1A;
	sbrs temp, UDRE1 ;loop unitl UDR1 is empty
	rjmp USART_Transmit

	ret
;***********************************************************
;*	Stored Program Data
;***********************************************************

;***********************************************************
;*	Additional Program Includes
;***********************************************************


;----------------------------------------------------------------
; Sub:	HitLeft
; Desc:	Handles functionality of the TekBot when the left whisker
;		is triggered.
;----------------------------------------------------------------
HitLeft:
		push	mpr			; Save mpr register
		push	waitcnt			; Save wait register
		in		mpr, SREG	; Save program state
		push	mpr			;

		; Move Backwards for a second, line 193 changed to 2 seconds
		ldi		mpr, MovBck	; Load Move Backward command
		out		PORTB, mpr	; Send command to port
		;ldi		waitcnt, WTime	; Wait for 1 second
		ldi		waitcnt, BackTime	; Wait for 2 second
		rcall	Wait			; Call wait function

		; Turn right for a second
		ldi		mpr, TurnR	; Load Turn Left Command
		out		PORTB, mpr	; Send command to port
		ldi		waitcnt, WTime	; Wait for 1 second
		rcall	Wait			; Call wait function

		; Move Forward again	
		ldi		mpr, MovFwd	; Load Move Forward command
		out		PORTB, mpr	; Send command to port

		pop		mpr		; Restore program state
		out		SREG, mpr	;
		pop		waitcnt		; Restore wait register
		pop		mpr		; Restore mpr
		ret				; Return from subroutine
;----------------------------------------------------------------
; Sub:	HitRight
; Desc:	Handles functionality of the TekBot when the right whisker
;		is triggered.
;----------------------------------------------------------------
HitRight:
		push	mpr			; Save mpr register
		push	waitcnt			; Save wait register
		in		mpr, SREG	; Save program state
		push	mpr			;

		; Move Backwards for a second, line 193 changed to 2 seconds
		ldi		mpr, MovBck	; Load Move Backward command
		out		PORTB, mpr	; Send command to port
		;ldi		waitcnt, WTime	; Wait for 1 second
		ldi		waitcnt, BackTime	; Wait for 2 second
		rcall	Wait			; Call wait function

		; Turn left for a second
		ldi		mpr, TurnL	; Load Turn Left Command
		out		PORTB, mpr	; Send command to port
		ldi		waitcnt, WTime	; Wait for 1 second
		rcall	Wait			; Call wait function

		; Move Forward again	
		ldi		mpr, MovFwd	; Load Move Forward command
		out		PORTB, mpr	; Send command to port

		pop		mpr		; Restore program state
		out		SREG, mpr	;
		pop		waitcnt		; Restore wait register
		pop		mpr		; Restore mpr
		ret				; Return from subroutine
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