;********************************************************************************
; timer0_demo.asm: Blinkar en lysdiod ansluten till pin 8 (PORTB0) var 100:e ms 
;                  via timerkrets Timer 0, som sätts till att generera ett 
;                  avbrott var 16.384:e ms (prescaler 1024) i Normal Mode 
;                  (100m / 16.384m = 6.1, vilket avrundas till 6).
;********************************************************************************

; Makrodefinitioner:
.EQU LED1 = PORTB0          ; Lysdiod 1 ansluten till pin 8 (PORTB0).
.EQU TIMER0_MAX_COUNT = 6   ; Uppräkning 100 ms fördröjning.
.EQU RESET_vect      = 0x00 ; Reset-vektor, programmets startpunkt.
.EQU TIMER0_OVF_vect = 0x20 ; Avbrottsvektor för Timer0 i Normal Mode.

;********************************************************************************
; .DSEG: Dataminnet, här lagras statiska variabler. Vi allokerar variablerna
;        i början av SRAM-minnet. Variabler deklareras via följande syntax:
;        variabelnamn: .datatyp antal_bytes
;********************************************************************************
.DSEG
.ORG SRAM_START
counter0: .byte 1 ; static uint8_t counter0 = 0;

;********************************************************************************
; .CSEG: Programminnet, här lagras maskinkoden.
;********************************************************************************
.CSEG

;********************************************************************************
; RESET_vect: Programmets startpunkt. Programhopp sker till subrutinen main
;             för att starta programmet.
;********************************************************************************
.ORG RESET_vect
   RJMP main

;********************************************************************************
; TIMER0_OVF_vect: Avbrottsvektor för Timer 0 i Normal Mode, som hoppas till
;                  var 16.384:e ms. Programhopp sker till motsvarande 
;                  avbrottsrutin ISR_TIMER0_OVF för att hantera avbrottet.
;********************************************************************************
.ORG TIMER0_OVF_vect
   RJMP ISR_TIMER0_OVF

;********************************************************************************
; ISR_TIMER0_OVF: Avbrottsrutin för Timer 0 i Normal Mode, som anropas var 
;                 16.384:e ms när Timer 0 blir överfull (overflow). Var sjätte 
;                 avbrott (var 100:e ms) togglas lysdiod 1. 
;********************************************************************************
ISR_TIMER0_OVF:
   LDS R24, counter0          ; Hämtar värdet från counter0 i dataminnet.
   INC R24                    ; Inkrementerar räknaren.
   CPI R24, TIMER0_MAX_COUNT  ; Jämför räknaren och 6.
   BRLO ISR_TIMER0_OVF_end    ; Om räknaren är mindre än 6, hoppar vi till slutet av avbrottsrutinen.
   OUT PINB, R16              ; Annars togglas lysdioden.
   CLR R24                    ; Nollställer räknaren inför nästa uppräkning.
ISR_TIMER0_OVF_end:
   STS counter0, R24          ; Skriver tillbaka det nya värdet.
   RETI                       ; Återställer allt som det var innan avbrottet.

;********************************************************************************
; main: Initierar systemet vid start. Programmet hålls sedan igång så länge
;       matningsspänning tillförs.
;********************************************************************************
main:

;********************************************************************************
; setup: Sätter lysdiodens pin till utport samt aktiverar Timer 0 i Normal Mode
;        så att timergenererat avbrott sker var 16.384:e ms (när Timer 0 räknar
;        till 256 och blir överfull). Eftersom R16 innehåller (1 << LED1),
;        vilket motsvarar 0000 0001, så används detta värde för att ettställa
;        biten TOIE0 i TIMSK0, då denna också är bit 0. Alltså, vi vill skriva
;        (1 << TOIE0) = 0000 0001 till TIMSK0, vilket redan ligger i R16.
;
;        Annars hade vi kunnat läsa in TOIE0 i R18:
;        LDI R18, (1 << TOIE0)
;        STS TIMSK0, R18
;
;        Notering: STS = Store To Dataspace  => skrivning till dataminnet.
;                  LDS = Load From Dataspace => läser från dataminnet.
;********************************************************************************
setup: 
   LDI R16, (1 << LED1) 
   OUT DDRB, R16
   SEI
   LDI R17, (1 << CS02) | (1 << CS00)
   OUT TCCR0B, R17
   STS TIMSK0, R16 ; (1 << TOIE0)

;********************************************************************************
; main_loop: Håller igång programmet så länge matningsspänning tillförs.
;********************************************************************************
main_loop:
   RJMP main_loop