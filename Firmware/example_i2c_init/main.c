// This file is Copyright (c) 2020 Florent Kermarrec <florent@enjoy-digital.fr>
// Added to by Copyright (c) 2024 Venkat Rangan  <venkat@tinyvision.ai>
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

#include "common.h"
#include "i2c_init.h"
#include "usb_init.h"
#include "imx219.h"
#include "pi4ioe5v9.h"
pi4ioe5v9_state_t pi4ioe5v9_obj;
static pi4ioe5v9_state_t *pi4ioe5v9_ptr = &pi4ioe5v9_obj;

#include "common.h"

#define ENABLE_PRINTF 0

#if ENABLE_PRINTF
#define PRINTF(...) printf(__VA_ARGS__)
#else
#define PRINTF(...)
#endif


#define WISHBONE_BASE_ADDR		0xb0000000

// An I2C MUX exists at either 0x70 or 0x71 depending on the slot used
#define I2C_MUX_ADDR 0x70


static void i2c_init(void) {
	//printf("Starting to initialize the PLL at 0x%x\n\r", PLL_I2C_ADDR);
	for (int i=0; i<NUM_PLL_INIT; i+=2) {
		//printf("Reg: 0x%lx = 0x%lx\n\r", pll_init_table[i], pll_init_table[i+1]);
		uint8_t val = pll_init_table[i+1];
		i2c_write(PLL_I2C_ADDR, pll_init_table[i], &val, 1, 1);
	}

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

static void RegTest(void) {
	unsigned int val, adr;

	// USB
	adr = WISHBONE_BASE_ADDR + 0xc120;
	reg_32b_read(adr, &val);
	PRINTF("Read back 0x%x from 0x%x\n\r", val, adr);

	// Scratch RAM
	adr = WISHBONE_BASE_ADDR + 0x01000000;
	reg_32b_write(adr, 0xdeadfeed);
	reg_32b_read(adr, &val);
	PRINTF("Read back 0x%x from 0x%x\n\r", val, adr);

	adr += 4;
	reg_32b_write(adr, 0xc001d00d);
	reg_32b_read(adr, &val);
	PRINTF("Read back 0x%x from 0x%x\n\r", val, adr);

	// TPG
	/*
	adr = WISHBONE_BASE_ADDR + 0x01100000;
	reg_32b_write(adr, 0xdeadfeed);
	reg_32b_read(adr, &val);
	printf("Read back 0x%x from 0x%x\n\r", val, adr);
	*/

	// CSR
	adr = WISHBONE_BASE_ADDR+0x02000000;
	reg_32b_write(adr, 0xdeadb10d);

	// Scratch RAM
	adr = WISHBONE_BASE_ADDR + 0x01000000;
	reg_32b_read(adr, &val);
	PRINTF("Read back 0x%x from 0x%x\n\r", val, adr);

	// CSR
	adr = WISHBONE_BASE_ADDR+0x02000000;
	reg_32b_read(adr, &val);
	PRINTF("Read back 0x%x from 0x%x\n\r", val, adr);

	val = *(volatile uint32_t *)0xb000c110;  // GCTL
	PRINTF("Read back 0x%x\n\r", val);

	val = *(volatile uint32_t *)0xb000c704;  // DCTL
	PRINTF("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb000c700;  // DCFG
	PRINTF("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb000c720;  // DALEPENA
	PRINTF("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb000c120;  // GCOREID
	PRINTF("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb0018004;
	PRINTF("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb0018008;
	PRINTF("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb00100c8;
	PRINTF("Read back 0x%x\n\r", val);
	val = *(volatile uint32_t *)0xb0014010;
	PRINTF("Read back 0x%x\n\r", val);
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
	puts("cam_[00,01,10,11]  - Selects Slot 0|1 Camera 0|1");
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
	else if(strcmp(token, "cam_10") == 0)
		sel_cam(1, 0);
	else if(strcmp(token, "cam_11") == 0)
		sel_cam(1, 1);
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
	RegTest();
	usb_reset_seq();
	device_poweron_soft_reset();
	usb_depcfg();

	//usb_init();
	//CsrRegTest();

	uart_init();

	// Initialize the PLL
	i2c_init();
	busy_wait(200); // Wait for the PLL to lock and switch clocks

	// Bump up Flash clock speed
	//spiflash_phy_clk_divisor_write(0);

	//printf("\n\rINFO: Initializing the camera sensor on expansion port 0, sensor 0\n\r");
	//sel_cam(0, 0);
	//SensorInit();

/*
	pi4ioe5v9_init(pi4ioe5v9_ptr);
	
	// Enable the 60MHz clock
	pi4ioe5v9_set_output(pi4ioe5v9_ptr, 0x80, LEVEL_HIGH);

	// Enable the camera power for all 4 cameras on GPIO 0, 1, 3, 4:
	pi4ioe5v9_set_output(pi4ioe5v9_ptr, 0x1, LEVEL_HIGH);
	pi4ioe5v9_set_output(pi4ioe5v9_ptr, 0x2, LEVEL_HIGH);
	pi4ioe5v9_set_output(pi4ioe5v9_ptr, 0x8, LEVEL_HIGH);
	pi4ioe5v9_set_output(pi4ioe5v9_ptr, 0x10, LEVEL_HIGH);
*/

	help();
	prompt();

	while(1) {
		console_service();
	}

	return 0;
}
