// This file is Copyright (c) 2020 Florent Kermarrec <florent@enjoy-digital.fr>
// License: BSD

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <uart.h>
#include <console.h>
#include <generated/csr.h>

#include <irq.h>
#include <libbase/uart.h>
#include <libbase/console.h>
#include <generated/csr.h>

#include <libbase/i2c.h>
#include "i2c_init.h"
#include "imx219.h"
#include "common.h"

#define WISHBONE_BASE_ADDR		0xb0000000

// An I2C MUX exists at either 0x70 or 0x71 depending on the slot used
#define I2C_MUX_ADDR 0x70

static void i2c_init(void) {
	uint8_t val = 0xff;
	i2c_write(PLL_I2C_ADDR, 0x3, &val, 1, 1); // Disable all clock outputs
	for (int i=16; i<=23; i++) { 
		val = 0x80;
		i2c_write(PLL_I2C_ADDR, i, &val, 1, 1); // Power down all output drivers
	}
	
	for (int i=0; i<SI5351A_REVB_REG_CONFIG_NUM_REGS; i++){
		val = si5351a_revb_registers[i].value;
		i2c_write(PLL_I2C_ADDR, si5351a_revb_registers[i].address, &val, 1, 1);
	}
	
	val = 0xAC;
	i2c_write(PLL_I2C_ADDR, 177, &val, 1, 1); // Apply PLLA/B reset
	val = 0x0;
	i2c_write(PLL_I2C_ADDR, 0x3, &val, 1, 1); // Enable all clock outputs
}

static void i2c_scan(void) {
	printf("Starting to poll I2C bus\n\r");
	printf("Found I2C slaves at: \n\r");
	for (unsigned char i=0; i<0x7f; i++) {
		if (i2c_poll(i)) {
			printf("\t0x%x", i);
		}
	}
	printf("\n\r");
}

static void sel_cam(uint8_t slot, uint8_t cam_id) {
	printf("Selecting camera %d\n\r", cam_id);
	uint8_t val = 0x4 + cam_id;
	i2c_write(I2C_MUX_ADDR + slot, 0, &val, 1, 1);
}

// Shared global variable to prevent a lot of debug messages printing out when polling.
static bool print_me = true;

static void reg_32b_read(unsigned int addr, unsigned int *val)
{
	*val = *((volatile unsigned int *)addr);
#ifdef DEBUG
	if(print_me)
		printf("reg_read 0x%08x = 0x%08x\n", addr, *val);
#endif
}

static void reg_32b_write(unsigned int addr, unsigned int val)
{
	*((volatile unsigned int *)addr) = val;
#ifdef DEBUG
	printf("reg_write 0x%08x = 0x%08x\n", addr, val);
#endif
}

static void reg_32b_poll(unsigned int addr, unsigned int flag)
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

static void RegTest(void) {
	unsigned int val, adr;

	// USB
	adr = WISHBONE_BASE_ADDR + 0xc120;
	reg_32b_read(adr, &val);
	printf("Read back 0x%x from 0x%x\n\r", val, adr);

	// Scratch RAM
	adr = WISHBONE_BASE_ADDR + 0x01000000;
	reg_32b_write(adr, 0xdeadfeed);
	reg_32b_read(adr, &val);
	printf("Read back 0x%x from 0x%x\n\r", val, adr);

	// TPG
	adr = WISHBONE_BASE_ADDR + 0x01100000;
	reg_32b_write(adr, 0xdeadfeed);
	reg_32b_read(adr, &val);
	printf("Read back 0x%x from 0x%x\n\r", val, adr);

	// CSR
	adr = WISHBONE_BASE_ADDR+0x02000000;
	reg_32b_write(adr, 0xdeadb10d);

	// Scratch RAM
	adr = WISHBONE_BASE_ADDR + 0x01000000;
	reg_32b_read(adr, &val);
	printf("Read back 0x%x from 0x%x\n\r", val, adr);

	// CSR
	adr = WISHBONE_BASE_ADDR+0x02000000;
	reg_32b_read(adr, &val);
	printf("Read back 0x%x from 0x%x\n\r", val, adr);

	val = *(volatile uint32_t *)0xb000c110;  // GCTL
	printf("Read back 0x%x\n\r", val);

	val = *(volatile uint32_t *)0xb000c704;  // DCTL
	printf("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb000c700;  // DCFG
	printf("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb000c720;  // DALEPENA
	printf("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb000c120;  // GCOREID
	printf("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb0018004;
	printf("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb0018008;
	printf("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb00100c8;
	printf("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb0014010;
	printf("Read back 0x%x\n\r", val);
}

static void CsrRegTest(void) {
	unsigned int val, adr;

	// Read back a bunch of registers from the CSR
	adr = WISHBONE_BASE_ADDR + 0x02000000;
	for (int i = 0; i<=10; i++) {
		reg_32b_read(adr, &val);
		printf("0x%x = 0x%x\n\r", adr, val);
		adr += 4;
	}
}

/*-----------------------------------------------------------------------*/
/* Uart                                                                  */
/*-----------------------------------------------------------------------*/

static char *readstr(void)
{
	char c[2];
	static char s[64];
	static int ptr = 0;

	if(readchar_nonblock()) {
		c[0] = getchar();
		c[1] = 0;
		switch(c[0]) {
			case 0x7f:
			case 0x08:
				if(ptr > 0) {
					ptr--;
					fputs("\x08 \x08", stdout);
				}
				break;
			case 0x07:
				break;
			case '\r':
			case '\n':
				s[ptr] = 0x00;
				fputs("\n", stdout);
				ptr = 0;
				return s;
			default:
				if(ptr >= (sizeof(s) - 1))
					break;
				fputs(c, stdout);
				s[ptr] = c[0];
				ptr++;
				break;
		}
	}

	return NULL;
}

static char *get_token(char **str)
{
	char *c, *d;

	c = (char *)strchr(*str, ' ');
	if(c == NULL) {
		d = *str;
		*str = *str+strlen(*str);
		return d;
	}
	*c = 0;
	d = *str;
	*str = c+1;
	return d;
}

static void prompt(void)
{
	printf("\e[92;1mtinyCLUNX33-demo\e[0m> ");
}

/*-----------------------------------------------------------------------*/
/* Help                                                                  */
/*-----------------------------------------------------------------------*/

static void help(void)
{
	puts("\ttinyCLUNX minimal demo app built "__DATE__" "__TIME__"\n");
	puts("Available commands:");
	puts("help               - Show this command");
	puts("reboot             - Reboot CPU");
#ifdef CSR_LEDS_BASE
	puts("led                - Led demo");
#endif
	puts("flash_div_0        - Set the flash clock divider to 0");
	puts("flash_div_1        - Set the flash clock divider to 1");
	puts("i2c_scan           - Scan for I2C devices");
	puts("cam_00             - Selects Slot 0 Camera 0");
	puts("cam_01             - Selects Slot 0 Camera 1");
	puts("cam_test           - Test for camera presence");
	puts("cam_init           - Initialize the camera");
	puts("reg_test           - Test register access");
	puts("csr_test           - Dump CSR registers");
}

/*-----------------------------------------------------------------------*/
/* Commands                                                              */
/*-----------------------------------------------------------------------*/

static void reboot_cmd(void)
{
	ctrl_reset_write(1);
}

#ifdef CSR_LEDS_BASE
static void led_cmd(void)
{
	int i;
	printf("Led demo...\n");

	printf("Counter mode...\n");
	for(i=0; i<32; i++) {
		leds_out_write(i);
		busy_wait(100);
	}

	printf("Shift mode...\n");
	for(i=0; i<4; i++) {
		leds_out_write(1<<i);
		busy_wait(200);
	}
	for(i=0; i<4; i++) {
		leds_out_write(1<<(3-i));
		busy_wait(200);
	}

	printf("Dance mode...\n");
	for(i=0; i<4; i++) {
		leds_out_write(0x55);
		busy_wait(200);
		leds_out_write(0xaa);
		busy_wait(200);
	}
}
#endif

/*-----------------------------------------------------------------------*/
/* Console service / Main                                                */
/*-----------------------------------------------------------------------*/

static void console_service(void)
{
	char *str;
	char *token;

	str = readstr();
	if(str == NULL) return;
	token = get_token(&str);
	if(strcmp(token, "help") == 0)
		help();
	else if(strcmp(token, "reboot") == 0)
		reboot_cmd();
#ifdef CSR_LEDS_BASE
	else if(strcmp(token, "led") == 0)
		led_cmd();
#endif
	else if(strcmp(token, "i2c_scan") == 0)
		i2c_scan();
	else if(strcmp(token, "flash_div_0") == 0)
		spiflash_phy_clk_divisor_write(0);
	else if(strcmp(token, "flash_div_1") == 0)
		spiflash_phy_clk_divisor_write(1);
	else if(strcmp(token, "cam_00") == 0)
		sel_cam(0, 0);
	else if(strcmp(token, "cam_01") == 0)
		sel_cam(0, 1);
	else if(strcmp(token, "cam_test") == 0)
		SensorI2cBusTest();
	else if(strcmp(token, "cam_init") == 0)
		SensorInit();
	else if(strcmp(token, "reg_test") == 0)
		RegTest();
	else if(strcmp(token, "csr_test") == 0)
		CsrRegTest();

	prompt();
}

int main(void)
{
#ifdef CONFIG_CPU_HAS_INTERRUPT
	irq_setmask(0);
	irq_setie(1);
#endif

	//CsrRegTest();

	uart_init();

	// Initialize the PLL
	i2c_init();
	busy_wait(200); // Wait for the PLL to lock and switch clocks

	// Bump up Flash clock speed
	//spiflash_phy_clk_divisor_write(0);

	printf("\n\rINFO: Initializing the camera sensor on expansion port 0, sensor 0\n\r");
	sel_cam(0, 0);
	SensorInit();

	help();
	prompt();

	while(1) {
		console_service();
	}

	return 0;
}
