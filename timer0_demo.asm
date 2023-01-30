;********************************************************************************
; timer0_demo.asm: Blinkar en lysdiod ansluten till pin 8 (PORTB0) var 100:e ms 
;                  via timerkrets Timer 0, som s�tts till att generera ett 
;                  avbrott var 16.384:e ms (prescaler 1024) i Normal Mode 
;                  (100m / 16.384m = 6.1, vilket avrundas till 6).
;********************************************************************************

; Makrodefinitioner:
.EQU LED1 = PORTB0          ; Lysdiod 1 ansluten till pin 8 (PORTB0).
.EQU TIMER0_MAX_COUNT = 6   ; Uppr�kning 100 ms f�rdr�jning.
.EQU RESET_vect      = 0x00 ; Reset-vektor, programmets startpunkt.
.EQU TIMER0_OVF_vect = 0x20 ; Avbrottsvektor f�r Timer0 i Normal Mode.

;********************************************************************************
; .DSEG: Dataminnet, h�r lagras statiska variabler. Vi allokerar variablerna
;        i b�rjan av SRAM-minnet. Variabler deklareras via f�ljande syntax:
;        variabelnamn: .datatyp antal_bytes
;********************************************************************************
.DSEG
.ORG SRAM_START
counter0: .byte 1 ; static uint8_t counter0 = 0;

;********************************************************************************
; .CSEG: Programminnet, h�r lagras maskinkoden.
;********************************************************************************
.CSEG

;********************************************************************************
; RESET_vect: Programmets startpunkt. Programhopp sker till subrutinen main
;             f�r att starta programmet.
;********************************************************************************
.ORG RESET_vect
   RJMP main

;********************************************************************************
; TIMER0_OVF_vect: Avbrottsvektor f�r Timer 0 i Normal Mode, som hoppas till
;                  var 16.384:e ms. Programhopp sker till motsvarande 
;                  avbrottsrutin ISR_TIMER0_OVF f�r att hantera avbrottet.
;********************************************************************************
.ORG TIMER0_OVF_vect
   RJMP ISR_TIMER0_OVF

;********************************************************************************
; ISR_TIMER0_OVF: Avbrottsrutin f�r Timer 0 i Normal Mode, som anropas var 
;                 16.384:e ms n�r Timer 0 blir �verfull (overflow). Var sj�tte 
;                 avbrott (var 100:e ms) togglas lysdiod 1. 
;********************************************************************************
ISR_TIMER0_OVF:
   LDS R24, counter0          ; H�mtar v�rdet fr�n counter0 i dataminnet.
   INC R24                    ; Inkrementerar r�knaren.
   CPI R24, TIMER0_MAX_COUNT  ; J�mf�r r�knaren och 6.
   BRLO ISR_TIMER0_OVF_end    ; Om r�knaren �r mindre �n 6, hoppar vi till slutet av avbrottsrutinen.
   OUT PINB, R16              ; Annars togglas lysdioden.
   CLR R24                    ; Nollst�ller r�knaren inf�r n�sta uppr�kning.
ISR_TIMER0_OVF_end:
   STS counter0, R24          ; Skriver tillbaka det nya v�rdet.
   RETI                       ; �terst�ller allt som det var innan avbrottet.

;********************************************************************************
; main: Initierar systemet vid start. Programmet h�lls sedan ig�ng s� l�nge
;       matningssp�nning tillf�rs.
;********************************************************************************
main:

;********************************************************************************
; setup: S�tter lysdiodens pin till utport samt aktiverar Timer 0 i Normal Mode
;        s� att timergenererat avbrott sker var 16.384:e ms (n�r Timer 0 r�knar
;        till 256 och blir �verfull). Eftersom R16 inneh�ller (1 << LED1),
;        vilket motsvarar 0000 0001, s� anv�nds detta v�rde f�r att ettst�lla
;        biten TOIE0 i TIMSK0, d� denna ocks� �r bit 0. Allts�, vi vill skriva
;        (1 << TOIE0) = 0000 0001 till TIMSK0, vilket redan ligger i R16.
;
;        Annars hade vi kunnat l�sa in TOIE0 i R18:
;        LDI R18, (1 << TOIE0)
;        STS TIMSK0, R18
;
;        Notering: STS = Store To Dataspace  => skrivning till dataminnet.
;                  LDS = Load From Dataspace => l�ser fr�n dataminnet.
;********************************************************************************
setup: 
   LDI R16, (1 << LED1) 
   OUT DDRB, R16
   SEI
   LDI R17, (1 << CS02) | (1 << CS00)
   OUT TCCR0B, R17
   STS TIMSK0, R16 ; (1 << TOIE0)

;********************************************************************************
; main_loop: H�ller ig�ng programmet s� l�nge matningssp�nning tillf�rs.
;********************************************************************************
main_loop:
   RJMP main_loop