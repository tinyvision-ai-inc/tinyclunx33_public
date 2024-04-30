#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

// Shared global variable to prevent a lot of debug messages printing out when polling.
static bool print_me = true;

void reg_32b_read(unsigned int addr, unsigned int *val)
{
	*val = *((volatile unsigned int *)addr);
#ifdef DEBUG
	if(print_me)
		printf("reg_read 0x%08x = 0x%08x\n", addr, *val);
#endif
}

void reg_32b_write(unsigned int addr, unsigned int val)
{
	*((volatile unsigned int *)addr) = val;
#ifdef DEBUG
	printf("reg_write 0x%08x = 0x%08x\n", addr, val);
#endif
}

void reg_32b_poll(unsigned int addr, unsigned int flag)
{
#ifdef DEBUG
	printf("reg_poll 0x%08x flag = 0x%08x, ", addr, flag);
#endif
	unsigned int reg;
	print_me = false;
	do {
		reg_32b_read(addr, &reg);
	} while (reg & flag);
	print_me = true;
#ifdef DEBUG
	printf("got: 0x%08x\n", reg);
#endif

}