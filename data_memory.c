/********************************************************************************
* data_memory.c: Contains function definitions for implementation of a 
*                2 kB memory.
********************************************************************************/
#include "data_memory.h"

/********************************************************************************
* data: Data memory with storage capacity for 2000 bytes.
********************************************************************************/
static uint8_t data[DATA_MEMORY_ADDRESS_WIDTH]; 

/********************************************************************************
* data_memory_reset: Clears entire data memory.
********************************************************************************/
void data_memory_reset(void)
{
   for (uint16_t i = 0; i < DATA_MEMORY_ADDRESS_WIDTH; ++i)
   {
      data[i] = 0x00;
   }
   return;
}

/********************************************************************************
* data_memory_write: Writes an 8-bit value to specified address in data memory.
*                    The value 0 is returned after successful write. Otherwise
*                    if invalid address is specified, no write is done and
*                    error code 1 is returned.
*
*                    - address: Write location in data memory.
*                    - value  : The 8-bit value to write to data memory.
********************************************************************************/
int data_memory_write(const uint16_t address,
                      const uint8_t value)
{
   if (address < DATA_MEMORY_ADDRESS_WIDTH)
   {
      data[address] = value;
      return 0;
   }
   else
   {
      return 1;
   }
}

/********************************************************************************
* data_memory_read: Returns content from specified read location in data memory.
*                   If an invalid address is specified, the value 0 is returned.
*
*                   - address: Read location in data memory.
********************************************************************************/
uint8_t data_memory_read(const uint16_t address)
{
   if (address < DATA_MEMORY_ADDRESS_WIDTH)
   {
      return data[address];
   }
   else
   {
      return 0x00;
   }
}