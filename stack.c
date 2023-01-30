/********************************************************************************
* stack.c: Contains function definitions for implementation of 1 kB stack.
********************************************************************************/
#include "stack.h"

/* Static variables: */
static uint8_t stack[STACK_ADDRESS_WIDTH]; /* 1 kB stack. */
static uint16_t sp;      /* Stack pointer, points to last added value. */
static bool stack_empty; /* Indicates if the stack is empty. */

/********************************************************************************
* stack_reset: Clears content on the entire stack and sets the stack pointer
*              to the top of the stack.
********************************************************************************/
void stack_reset(void)
{
   for (uint16_t i = 0; i < STACK_ADDRESS_WIDTH; ++i)
   {
      stack[i] = 0x00;
   }

   sp = STACK_ADDRESS_WIDTH - 1;
   stack_empty = true;
   return;
}

// stack_push(3);

/********************************************************************************
* stack_push: Pushes 8 bit value to the stack, unless the stack is full.
*             Success code 0 is returned after successful push, otherwise
*             error code 1 is returned if the stack is already full.
*
*             - value: 8 bit value to push to the stack.
********************************************************************************/
int stack_push(const uint8_t value)
{
   if (sp == 0)
   {
      return 1;
   }
   else
   {
      if (stack_empty)
      {
         stack[sp] = value;
         stack_empty = false;
      }
      else
      {
         stack[--sp] = value;
      }
      return 0;
   }
}

/********************************************************************************
* stack_pop: Returns 8 bit value popped from the stack. If the stack is empty,
*            the value 0x00 is returned.
********************************************************************************/
uint8_t stack_pop(void)
{
   if (stack_empty)
   {
      return 0x00;
   }
   else
   {
      if (sp < STACK_ADDRESS_WIDTH - 1)
      {
         return stack[sp++];
      }
      else
      {
         stack_empty = true;
         return stack[sp];
      }
   }
}

/********************************************************************************
* stack_pointer: Returns the 16 bit address of the stack pointer.
********************************************************************************/
uint16_t stack_pointer(void)
{
   return sp;
}

/********************************************************************************
* stack_last_added_value: Returns the last added value to the stack. If the
*                         stack is empty, the value 0x00 is returned.
********************************************************************************/
uint8_t stack_last_added_value(void)
{
   if (stack_empty)
   {
      return 0x00;
   }
   else
   {
      return stack[sp];
   }
}