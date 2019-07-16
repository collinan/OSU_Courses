;***********************************************************
;*
;*File Name:kaiyuan_fan_and_andrew_collins_Lab8_TX_sourcecode.asm
;*Course: ECE 375
;*This is the TRANSMIT file for Lab 8 of ECE 375
;*This program allowed us to control the bot remotely. The remote 
;*allowed for 6 signals to be transmitted: move forward, move backward,
;*turn right, turn left, halt and freeze. At the same time the signal 
;*is transmitted the equivalent code is displayed via the LEDs.
;*	
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
.def	mpr = r16	
.def temp =r20
.def	waitcnt = r17	; Wait Loop Counter
.def	ilcnt = r18		; Inner Loop Counter
.def	olcnt = r19		; Outer Loop Counter

.equ	WTime = 100		; Time to wait in wait loop was 
.equ	MovR = 0		; Move right Input Bit
.equ	MovL = 1		; Move left Input Bit
;.equ	MovF = 2		; Move Forward Input Bit
;.equ	MovB = 3		; Move Back Input Bit

.equ	EngEnR = 4		; Right Engine Enable Bit
.equ	EngEnL = 7		; Left Engine Enable Bit
.equ	EngDirR = 5		; Right Engine Direction Bit
.equ	EngDirL = 6		; Left Engine Direction Bit
; Use these action codes between the remote and robot
; MSB = 1 thus:
; control signals are shifted right by one and ORed with 0b10000000 = $80
.equ	MovFwd =  ($80|1<<(EngDirR-1)|1<<(EngDirL-1))	;0b10110000 Move Forward Action Code
.equ	MovBck =  ($80|$00)								;0b10000000 Move Backward Action Code
.equ	TurnR =   ($80|1<<(EngDirL-1))					;0b10100000 Turn Right Action Code
.equ	TurnL =   ($80|1<<(EngDirR-1))					;0b10010000 Turn Left Action Code
.equ	Halt =    ($80|1<<(EngEnR-1)|1<<(EngEnL-1))		;0b11001000 Halt Action Code
.equ	RobotID = $3A
;***********************************************************
;*	Start of Code Segment
;***********************************************************
.cseg				; Beginning of code segment

;***********************************************************
;*	Interrupt Vectors
;***********************************************************
.org	$0000			; Beginning of IVs
		rjmp 	INIT	; Reset interrupt
.org	$0046			; End of Interrupt Vectors

;***********************************************************
;*	Program Initialization
;***********************************************************
INIT:
	;Stack Pointer (VERY IMPORTANT!!!!)
	ldi		mpr, low(RAMEND)
	out		SPL, mpr	; Load SPL with low byte of RAMEND
	ldi		mpr, high(RAMEND)
	out		SPH, mpr	; Load SPH with high byte of RAMEND

	;I/O Ports
	; Initialize Port B for output
		ldi		mpr, $FF	; Set Port B Data Direction Register
		out		DDRB, mpr	; for output
		ldi		mpr, $00	; Initialize Port B Data Register
		out		PORTB, mpr	; so all Port B outputs are low	

	; Initialize Port D for input
		ldi		mpr, $00	; Set Port D Data Direction Register
		out		DDRD, mpr	; for input
		ldi		mpr, $FF	; Initialize Port D Data Register
		out		PORTD, mpr	; so all Port D inputs are Tri-State

	; Initialize Port D for output
		ldi		mpr, (1<<PD3);Port E pin 1(TXD1) for output
		out		DDRD, mpr		

	;USART1
		;Set baudrate at 2400bps
		ldi mpr, high (416) ;Load high byte of 0x0340
		sts UBRR1H, mpr		;
		ldi mpr, low(416)	;Load low byte of 0x0340
		sts UBRR1L, mpr	

		;Enable transmitter
		ldi mpr, (1<<TXEN1) ;
		sts UCSR1B, mpr		;enable transmitter

		;Set frame format: 8 data bits, 2 stop bits
		ldi mpr,(0<<UMSEL1 | 1<<USBS1 | 1<<UCSZ11 | 1<<UCSZ10)
		sts UCSR1C, mpr	

		sei

;***********************************************************
;*	Main Program
;***********************************************************
;----------------------------------------------------------------
; Sub:	MAIN
; Desc:	The Main routine executes a simple polling loop that checks 
;for user input.  Depending on the input we jump to the specific 
;subroutine:MoveForward, MoveBackward, TurnRight, TurnLeft, MoveHalt 
;and Send_Freeze. 
;----------------------------------------------------------------
MAIN:
		sbis	PIND, 0
		rcall	MoveRight
		sbis	PIND, 1
		rcall	MoveLeft

		sbis	PIND, 4
		rcall	MoveForward

		sbis	PIND, 5
		rcall	MoveBack

		sbis	PIND, 6
		rcall	MoveHalt

		sbis	PIND, 7
		rcall	Send_Freeze
		rjmp	MAIN



;***********************************************************
;*	Functions and Subroutines
;***********************************************************
;----------------------------------------------------------------
; Sub:	MoveRight
; Desc:	The MoveRight routine will first transmit the robot ID, 
;then transmits the code 0b10100000 via USART 1, to the bot. 
;Both the transmission are done by making a call to the USART_Transmit
; routine.
;----------------------------------------------------------------
MoveRight:		
		ldi mpr, RobotID
		sts UDR1, mpr
		rcall USART_Transmit

		ldi mpr, TurnR
		out PORTB,mpr
		sts UDR1, mpr
		
		rcall USART_Transmit

		ret
;----------------------------------------------------------------
; Sub:	MoveLeft:
; Desc:	The MoveLeft routine will first transmit the robot ID, then
; transmits the code 0b10010000 via USART 1, to the bot. Both the 
;transmission are done by making a call to the USART_Transmit routine.
;----------------------------------------------------------------
MoveLeft:		
		ldi mpr, RobotID
		sts UDR1, mpr
		rcall USART_Transmit
		ldi mpr, TurnL	
		out PORTB,mpr	
		sts UDR1, mpr
		rcall USART_Transmit
		ret
;----------------------------------------------------------------
; Sub:	MoveForward
; Desc:	The MoveForward routine will first transmit the robot ID, then transmits 
;the code 0b10110000 via USART 1, to the bot. Both the transmission are done by 
;making a call to the USART_Transmit routine.
;----------------------------------------------------------------
MoveForward:
		ldi mpr, RobotID
		sts UDR1, mpr
		rcall USART_Transmit
		ldi mpr, MovFwd
		out PORTB, mpr
			
		sts UDR1, mpr
		rcall USART_Transmit
		ret
;----------------------------------------------------------------
; Sub:	MoveBack
; Desc:	The MoveBack routine will first transmit the robot ID, then transmits 
;the code 0b10000000 via USART 1, to the bot. Both the transmission are done by 
;making a call to the USART_Transmit routine.
;----------------------------------------------------------------
MoveBack:
		ldi mpr, RobotID
		sts UDR1, mpr
		rcall USART_Transmit
		ldi mpr, MovBCk
			
		out PORTB, mpr
		sts UDR1, mpr
		rcall USART_Transmit
		ret
;----------------------------------------------------------------
; Sub:	MoveHalt
; Desc:	The MoveHalt routine will first transmit the robot ID, then transmits 
;the code 0b11001000 via USART 1, to the bot. Both the transmission are done by
; making a call to the USART_Transmit routine.
;----------------------------------------------------------------
MoveHalt:
		ldi mpr, RobotID
		sts UDR1, mpr
		rcall USART_Transmit
		ldi mpr, Halt
		out PORTB, mpr
		sts UDR1, mpr
		rcall USART_Transmit
		ret
;----------------------------------------------------------------
; Sub:	Send_Freeze
; Desc:	The Send_Freeze routine will first transmit the robot ID, then transmits
; the code 0b11111000 via USART 1, to the bot. Both the transmission are done by 
;making a call to the USART_Transmit routine.
;----------------------------------------------------------------
Send_Freeze:
		ldi mpr, RobotID
		sts UDR1, mpr
		rcall USART_Transmit
		ldi mpr, 0b11111000	
		out PORTB,mpr	
		sts UDR1, mpr
		rcall USART_Transmit
		ret
;----------------------------------------------------------------
; Sub:	USART_Transmit
; Desc:	The USART_Transmit routine is called whenever a signal/code is remotely
; being sent from transmitter via USART 1.
;----------------------------------------------------------------
USART_Transmit:
	lds temp, UCSR1A;
	sbrs temp, UDRE1 ;loop unitl UDR1 is empty
	rjmp USART_Transmit
	;sts UDR1, mpr
	ret

;***********************************************************
;*	Stored Program Data
;***********************************************************

;***********************************************************
;*	Additional Program Includes
;***********************************************************
