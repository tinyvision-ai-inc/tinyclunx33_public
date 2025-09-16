#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <console.h>
#include <generated/csr.h>
#include <generated/csr.h>
#include <irq.h>
#include <libbase/console.h>
#include <libbase/uart.h>
#include <uart.h>

int main(void)
{
#ifdef CONFIG_CPU_HAS_INTERRUPT
	irq_setmask(0);
	irq_setie(1);
#endif

	printf(".");
	uart_init();

	while (1) {
		printf(".");
		busy_wait(10);
	}

	return 0;
}
