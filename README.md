# Anteckningar 2023-01-30
Demonstration av timerkrets Timer 0 i assembler samt implementering av stack för emulerad CPU.

Filen "timer0_demo.asm" utgör en demonstration av Timer 0 i assembler för toggling av en lysdiod 
ansluten till pin 8 (PORTB0) var 100:e ms. Timern ställs in så att timergenererat avbrott sker 
var 16.384:e ms, därmed togglas lysdioden ungefär var sjätte avbrott.

Samtliga .c- och .h-filer utgör den emulerade CPU som konstrueras under kursens gång.
I detta fall har filer "stack.h" samt "stack.c" lagts till för implementering av en 
1 kB stack. Nästa gång ska instruktioner CALL, RET, PUSH samt POP implementeras, 
där stacken används för att skriva och läsa återhoppsadresser samt lokala variabler.
Programminnet ska även skrivas om för att testa stackimplementeringen.




