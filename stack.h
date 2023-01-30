/********************************************************************************
* stack.h: Contains function declarations and macro definition for 
*          implementation of 1 kB stack (1024 x 1 byte = 1024 byte).
********************************************************************************/
#ifndef STACK_H_
#define STACK_H_

/* Include directives: */
#include "cpu.h"

/* Macro definitions: */
#define STACK_ADDRESS_WIDTH 1024 /* 1024 unique addresses on the stack. */
#define STACK_DATA_WIDTH    8    /* 8 bit storage capacity per address. */

/********************************************************************************
* stack_reset: Clears content on the entire stack and sets the stack pointer
*              to the top of the stack.
********************************************************************************/
void stack_reset(void);

/********************************************************************************
* stack_push: Pushes 8 bit value to the stack, unless the stack is full.
*             Success code 0 is returned after successful push, otherwise
*             error code 1 is returned if the stack is already full.
* 
*             - value: 8 bit value to push to the stack.
********************************************************************************/
int stack_push(const uint8_t value);

/********************************************************************************
* stack_pop: Returns 8 bit value popped from the stack. If the stack is empty, 
*            the value 0x00 is returned.
********************************************************************************/
uint8_t stack_pop(void);

/********************************************************************************
* stack_pointer: Returns the 16 bit address of the stack pointer.
********************************************************************************/
uint16_t stack_pointer(void);

/********************************************************************************
* stack_last_added_value: Returns the last added value to the stack. If the
*                         stack is empty, the value 0x00 is returned.
********************************************************************************/
uint8_t stack_last_added_value(void);

#endif /* STACK_H_ */