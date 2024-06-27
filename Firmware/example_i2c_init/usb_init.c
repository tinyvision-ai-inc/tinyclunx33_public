
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common.h"


#include "usb_init.h"

static unsigned int reg_read(unsigned int addr) {
  return *((volatile unsigned int *)addr);
}

void usb_init(void) {
  reg_32b_write(0xb000c110, reg_read(0xb000c110) | 0x00000800);
  reg_32b_write(0xb000c2c0, reg_read(0xb000c2c0) | 0x80000000);
  reg_32b_write(0xb000c200, reg_read(0xb000c200) | 0x80000000);
  reg_32b_write(0xb000c2c0, reg_read(0xb000c2c0) & ~0x80000000);
  reg_32b_write(0xb000c200, reg_read(0xb000c200) & ~0x80000000);
  reg_32b_write(0xb000c110, reg_read(0xb000c110) & ~0x00000800);
  reg_32b_write(0xb0018004, reg_read(0xb0018004) | 0x01000000);
  reg_32b_write(0xb0018008, reg_read(0xb0018008) | 0x00000400);
  reg_32b_write(0xb001008c, reg_read(0xb001008c) | 0x00400000);
  reg_32b_write(0xb0010040, reg_read(0xb0010040) & ~0x00004000);
  reg_32b_write(0xb000c704, 0x40f00000);
  while ((reg_read(0xb000c704) & 0x40000000) != 0);
  reg_32b_write(0xb000c100, reg_read(0xb000c100) | 0x000000fe);
  reg_read(0xb000c120);
  reg_32b_write(0xb000c300, 0x00000600);
  reg_32b_write(0xb000c380, 0x00000600);
  reg_32b_write(0xb000c400, 0xb1000640);
  reg_32b_write(0xb000c404, 0x00000000);
  reg_32b_write(0xb000c408, 0x00000100);
  reg_32b_write(0xb000c40c, 0x00000000);
  reg_32b_write(0xb000c700, 0x00000800);
  reg_32b_write(0xb000c700, reg_read(0xb000c700) | 0x00000000);
  reg_32b_write(0xb000c700, (reg_read(0xb000c700) & ~0x003e0000) | 0x001e0000);
  reg_32b_write(0xb000c708, 0x00003e37);
  reg_32b_write(0xb000c80c, 0x00000409);
  reg_read(0xb000c80c);
  reg_32b_write(0xb000c81c, 0x00000409);
  reg_read(0xb000c81c);
  reg_32b_write(0xb000c808, 0x03c00018);
  reg_32b_write(0xb000c804, 0x00000300);
  reg_32b_write(0xb000c80c, 0x00000401);
  reg_read(0xb000c80c);
  reg_32b_write(0xb000c808, 0x00000001);
  reg_32b_write(0xb000c80c, 0x00000402);
  reg_read(0xb000c80c);
  reg_32b_write(0xb000c720, reg_read(0xb000c720) | 0x00000001);
  reg_32b_write(0xb000c818, 0x03c00018);
  reg_32b_write(0xb000c814, 0x02000300);
  reg_32b_write(0xb000c81c, 0x00000401);
  reg_read(0xb000c81c);
  reg_32b_write(0xb000c818, 0x00000001);
  reg_32b_write(0xb000c81c, 0x00000402);
  reg_read(0xb000c81c);
  reg_32b_write(0xb000c720, reg_read(0xb000c720) | 0x00000002);
  reg_32b_write(0xb000c704, (reg_read(0xb000c704) & ~0x000001e0) | 0x00000100);
  reg_32b_write(0xb000c808, 0x00000000);
  reg_32b_write(0xb000c804, 0xb1000620);
  reg_32b_write(0xb000c80c, 0x00000406);
  reg_read(0xb000c80c);
  reg_32b_write(0xb000c704, reg_read(0xb000c704) | 0x80000000);
}

#include "usb_device_descriptor_data.h"

#define DEBUG
#define SUSPEND_MODE_EN 0
#define SIM_EN 0
#define EXT_CLK_EN 0

// High  speed - 0x0
// Full  speed - 0x1
// Super speed - 0x4
#define USB_SPEED 0x0

/*-----------------------------------------------------------------------*/
/* USB Bringup                                                           */
/*-----------------------------------------------------------------------*/

static uint32_t evt_buffer[16];

#define RISCV_USB_CONFIGURATION_ADDRESS		0xb0000000
// RISC V Addresses
#define RISCV_EVENT_BUFFER_ADDRESS       evt_buffer //0x00200000
#define RISCV_TRB_BUFFER_ADDRESS         0x00300000
#define RISCV_REQUEST_BUFFER_ADDRESS     0x00400000
#define RISCV_DESCRIPTOR_BUFFER_ADDRESS  0x00500000

// USB23 Addresses
#define USB23_EVENT_ADDRESS       0x00000010
#define SETUP_PACKET_ADDRESS      0x0004ff00
#define USB23_TRB_ADDRESS         0x00001000
#define USB23_DESCRIPTOR_ADDRESS  0x00050000
#define USB23_BULK_ADDRESS        0x00060000
#define USB23_CONTROL_ADDRESS     0x00070000
#define USB23_INTERRUPT_ADDRESS   0x00080000

// Size of Bulk and Interrupt TRBs
#define SIZE_OF_INTERRUPT_IN_HS_DATA   0x400 //1024
#define SIZE_OF_INTERRUPT_IN_FS_DATA   0x40  //64
#define SIZE_OF_INTERRUPT_OUT_HS_DATA  0x400 //1024
#define SIZE_OF_INTERRUPT_OUT_FS_DATA  0x40  //64
#define SIZE_OF_BULK_IN_HS_DATA        0x200 //512
#define SIZE_OF_BULK_IN_FS_DATA        0x40  //64
#define SIZE_OF_BULK_OUT_HS_DATA       0x200 //512
#define SIZE_OF_BULK_OUT_FS_DATA       0x40  //64

#define USB23_EVENT_ADDRESS			0x00000010
#define USB23_TRB_ADDRESS			0x00001000


// Device Descriptor
unsigned int Device_data[] = { 0x02000112, 0x40FFFFFF, 0x20C82AC1, 0x02010600,0x00000103, 0x00000000 };
unsigned int Device_Data_Buffer_size = (sizeof(Device_data) / 4);
unsigned int Device_Descriptor_size = 0x12;

// Device Qualifier Descriptor
unsigned int Device_Qualifier_data[] = { 0x0200060A, 0x08000000, 0x00000001,0x00000000 };
unsigned int Device_Qualifier_Data_Buffer_size = (sizeof(Device_Qualifier_data) / 4);
unsigned int Device_Qualifier_Descriptor_size = 0xA;

// Configuration Descriptor (Bulk + Interrupt)
unsigned int Configuration_data[] = { 0x002e0209, 0xc0000101, 0x000000fa,0x00000000 };
unsigned int Configuration_Data_Buffer_size = (sizeof(Configuration_data) / 4);
unsigned int Configuration_Descriptor_size = 0x9;

// Configuration + Interface + Endpoint Descriptor (Bulk + Interrupt)
unsigned int Configuration_Interface_Endpoint_HS_data[] = { 0x002e0209, 0xc0000101, 0x000409fa, 0xffff0400, 0x050700ff, 0x02000281, 0x01050700, 0x00020002, 0x03850507, 0x07000400, 0x00030505, 0x00000004 };
unsigned int Configuration_Interface_Endpoint_FS_data[] = { 0x002e0209, 0xc0000101, 0x000409fa, 0xffff0400, 0x050700ff, 0x00400281, 0x01050700, 0x00004002, 0x03850507, 0x07000040, 0x40030505, 0x00000000 };
unsigned int Configuration_Interface_Endpoint_data_Buffer_size = (sizeof(Configuration_Interface_Endpoint_HS_data) / 4);
unsigned int Configuration_Interface_Endpoint_Descriptor_size = 0x2e;

// String Language Descriptor
unsigned int String_Language_data[] = { 0x04090304, 0x00000000 };
unsigned int String_Language_Data_Buffer_size = (sizeof(String_Language_data) / 4);
unsigned int String_Language_Descriptor_size = 0x4;

// String Index 1 Descriptor (Lattice Vendor Specific Device)
unsigned int String_Index1_data[] = { 0x004c033e, 0x00740061, 0x00690074, 0x00650063, 0x00560020, 0x006e0065, 0x006f0064, 0x00200072, 0x00700053, 0x00630065, 0x00660069, 0x00630069, 0x00440020, 0x00760065, 0x00630069, 0x00000065 };
unsigned int String_Index1_Data_Buffer_size = (sizeof(String_Index1_data) / 4);
unsigned int String_Index1_Descriptor_size = 0x3e;

// String Index 2 Descriptor (Lattice Vendor Specific Device)
unsigned int String_Index2_data[] = { 0x004c033e, 0x00740061, 0x00690074, 0x00650063, 0x00560020, 0x006e0065, 0x006f0064, 0x00200072, 0x00700053, 0x00630065, 0x00660069, 0x00630069, 0x00440020, 0x00760065, 0x00630069, 0x00000065 };
unsigned int String_Index2_Data_Buffer_size = (sizeof(String_Index2_data) / 4);
unsigned int String_Index2_Descriptor_size = 0x3e;

// String Index 3 Descriptor (Lattice Vendor Specific Device)
unsigned int String_Index3_data[] = { 0x004c033e, 0x00740061, 0x00690074, 0x00650063, 0x00560020, 0x006e0065, 0x006f0064, 0x00200072, 0x00700053, 0x00630065, 0x00660069, 0x00630069, 0x00440020, 0x00760065, 0x00630069, 0x00000065 };
unsigned int String_Index3_Data_Buffer_size = (sizeof(String_Index3_data) / 4);
unsigned int String_Index3_Descriptor_size = 0x3e;

int Request_Buffer_interrupt_flag;
int Event_Buffer_interrupt_flag;


// -----------------------------------------------------------
// Device Physical Endpoint-Specific Command Structure
// -----------------------------------------------------------

// DEPSTARTCFG -- Device EndPoint Start Configuration -- 0x9 -- No Parameters are required
static void DEPSTARTCFG(unsigned int ep_number) {
	unsigned int data;
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number,0x00000409);
	// Poll for CmdAct
	reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number, &data);
	while ((data & (0x00000400)) != 0x00000000)
		reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number, &data);
}

// DEPSTRTXFER -- Device End Point Start Transfer Resource Configuration -- 0x6 -- 64 bit Parameter
static void DEPSTRTXFER(unsigned int ep_number, unsigned int parameter1, unsigned int parameter0) {
	unsigned int data;
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000C804 + 16 * ep_number, parameter1);
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000C808 + 16 * ep_number, parameter0);
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000C80C + 16 * ep_number, 0x00000406);
	// Poll for CmdAct
	reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000C80C + 16 * ep_number, &data);
	while ((data & (0x00000400)) != 0x00000000)
		reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000C80C + 16 * ep_number, &data);
}

// DEPENDXFER -- Device End Point End Transfer command
static void DEPENDXFER(void) {
	unsigned int data;
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000C80C, 0x00000D08);
	// Poll for CmdAct
	reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000C80C, &data);
	while ((data & (0x00000400)) != 0x00000000)
		reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x00000C80C, &data);
}

// DEPCFG -- Set EndPoint Configuration -- Device EndPoint Configuration -- 0x1 -- 64 or 96 bit Parameters
static void DEPCFG(unsigned int ep_number, unsigned int parameter2, unsigned int parameter1, unsigned int parameter0) {
	unsigned int data;
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c800 + 16 * ep_number, parameter2);
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c804 + 16 * ep_number, parameter1);
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c808 + 16 * ep_number, parameter0);
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number, 0x00000401);
	// Poll for CmdAct
	reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number, &data);
	while ((data & (0x00000400)) != 0x00000000)
		reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number, &data);
}

// DEPXFERCFG -- Device End Point Transfer Resource Configuration -- 0x2 -- 32 bit Parameter
static void DEPXFERCFG(unsigned int ep_number) {
	unsigned int data;
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c808 + 16 * ep_number, 0x00000001);
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number, 0x00000402);
	// Poll for CmdAct
	reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number, &data);
	while ((data & (0x00000400)) != 0x00000000)
		reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number, &data);
}

// DEPSSTALL -- Device End Point Stall
static void DEPSSTALL(unsigned int ep_number) {
	unsigned int data;
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number, 0x00000404);
	// Poll for CmdAct
	reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number, &data);
	while ((data & (0x00000400)) != 0x00000000)
		reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c80c + 16 * ep_number, &data);
}

// -----------------------------------------------------------
// Buffer Setting Commands
// -----------------------------------------------------------

// TRB Buffer
static void TRB_buffer_set(unsigned int address_low, unsigned int address_high, unsigned int buffer_size, unsigned int TRB_parameter) {
	reg_32b_write(RISCV_TRB_BUFFER_ADDRESS, address_low);
	reg_32b_write(RISCV_TRB_BUFFER_ADDRESS, address_high);
	reg_32b_write(RISCV_TRB_BUFFER_ADDRESS, buffer_size);
	reg_32b_write(RISCV_TRB_BUFFER_ADDRESS, TRB_parameter);
}

// Descriptor Buffer
static void Descriptor_buffer_set(unsigned int size, unsigned int data[]) {
	int i;
	for (i = 0; i < size; i = i + 1) {
		reg_32b_write(RISCV_DESCRIPTOR_BUFFER_ADDRESS, data[i]);
	}
}

// -----------------------------------------------------------
// TRB's for Different Packets
// -----------------------------------------------------------

// Control Setup
static void TRB_Control_setup(void) {
	TRB_buffer_set(SETUP_PACKET_ADDRESS, 0x00000000, 0x00000008, 0x00000823);
	DEPSTRTXFER(0x0, USB23_TRB_ADDRESS, 0x00000000);
}

// Control Data
static void TRB_Control_Data(unsigned int Size_of_descriptor, unsigned int data_buffer_size, unsigned int descriptor_data[]) {
	TRB_buffer_set(USB23_DESCRIPTOR_ADDRESS, 0x00000000, Size_of_descriptor, 0x00000853);
	Descriptor_buffer_set(data_buffer_size, descriptor_data);
	DEPSTRTXFER(0x1, USB23_TRB_ADDRESS, 0x00000000);
}

// Control Status 2
static void TRB_Control_Status2(void) {
	TRB_buffer_set(USB23_TRB_ADDRESS, 0x00000000, 0x00000000, 0x00000833);
	DEPSTRTXFER(0x1, USB23_TRB_ADDRESS, 0x00000000);
}

// Control Status 3
static void TRB_Control_Status3(unsigned int direction) {
	TRB_buffer_set(USB23_TRB_ADDRESS, 0x00000000, 0x00000000, 0x00000843);
	DEPSTRTXFER(0x0 + direction, USB23_TRB_ADDRESS, 0x00000000);
}

// -----------------------------------------------------------
// Others
// -----------------------------------------------------------

// Event Buffer Monitoring
static void event_while(unsigned int event) {
	unsigned int data_lower;
	unsigned int data_higher;

	reg_32b_read(RISCV_EVENT_BUFFER_ADDRESS, &data_lower);
	reg_32b_read(RISCV_EVENT_BUFFER_ADDRESS, &data_higher);
	while (((data_lower & (0x00000FFF)) != (event)) & ((data_higher & (0x00000FFF)) != (event))) {
		reg_32b_read(RISCV_EVENT_BUFFER_ADDRESS, &data_lower);
		reg_32b_read(RISCV_EVENT_BUFFER_ADDRESS, &data_higher);
	}
}


static void device_initiated_disconnect(void) {
	unsigned int data;

	// Set DCTL.RunStop to ‘0’ to disconnect from the host
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c704, 0x40000000 | 0x00f00000); // 31c1
	reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c70c, &data);
	//poll until DSTS.DevCtrlHlt is '1'
	while ((data & (0x00400000)) != 0x00000000)
		reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c70c, &data);
}



// -----------------------------------------------------------
// USB Sequences
// -----------------------------------------------------------

// 1. USB Reset Sequence
void usb_reset_seq(void) {

	// UTMI PHY Soft Reset -- Causes the usb2phy_reset signal to be asserted to reset a UTMI PHY
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c200, 0x80000000 | 0x00102400); //3080

	// USB3 PHY Soft Reset -- After setting this bit to '1', the software needs to clear this bit.
	if(SUSPEND_MODE_EN)
	   reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c2c0, 0x80000000 | 0x010c0002|0x00020000); //30b0
	else
	   reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c2c0, 0x80000000 | 0x010c0002); //30b0

	// USB 2.0 PHY Internal CSR Configuration
	// Default Value = 300
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x00018008, 0x00000700);    // 6002

	if (EXT_CLK_EN)
		// External Clock
		reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x00018004, 0x00000100); // 6001
	else
		// Internal Clock
		reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x00018004, 0x01000100);    // 6001

	// USB 3.0 PHY Internal CSR Configuration
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x00014010, 0x00060000); // 5004

	// USB 3.0 PHY External CSR Configuration
	// USB3 PHY 0xc8 to 0xcb
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x000100C8, 0x00000040); // 4032
	// USB3 PHY 0x8c to 0x8f
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0001008C, 0x90940001); // 4023
	// USB3 PHY 0x90 to 0x93
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x00010090, 0x3f7a03d0); // 4024
	// USB3 PHY 0x94 to 0x97
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x00010094, 0x03d09000); // 4025
	// USB3 PHY 0x40 to 0x43 // Added by Pavan
	if (EXT_CLK_EN)
		// External Clock
		reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x00010040, 0x7FE78032);  // 4010
	else
		// Internal Clock : All Default Values : Not Required
		reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x00010040, 0x7FE7C032); // 4010

	// UTMI PHY Soft Reset -- Causes the usb2phy_reset signal to be asserted to reset a UTMI PHY
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c200, 0x00102400); // 3080

	// USB3 PHY Soft Reset -- After setting this bit to '1', the software needs to clear this bit.
	if(SUSPEND_MODE_EN)
     	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c2c0, 0x010c0002|0x00020000); // 30b0
	else
     	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c2c0, 0x010c0002); // 30b0
}

// 2. Power On / Soft Reset
void device_poweron_soft_reset(void) {
	unsigned int data;

	// Set the CSftRst field to ‘1’ and wait for a read to return ‘0’. This resets the device controller
	// Default Value = 32'h00f00000
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c704, 0x40000000 | 0x00f00000); // 31c1
	// Wait until it reads out 00f00000
	reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c704, &data); // 31c1
	while ((data & (0x40000000)) != 0x00000000)
		reg_32b_read(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c704, &data); // 31c1

	// Global Event Buffer Address (Low) Register
	// Holds the lower 32 bits of start address of the external memory for the Event Buffer. During operation, hardware does not update this address.
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c400, USB23_EVENT_ADDRESS); // 3100
	// Global Event Buffer Address (High) Register
	// Holds the higher 32 bits of start address of the external memory for the Event Buffer. During operation, hardware does not update this address.
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c404, 0x00000000); // 3101
	// Event Buffer Size in bytes (EVNTSiz) Holds the size of the Event Buffer in bytes; must be a multiple of four. This is programmed by software once during initialization. The minimum size of the event buffer is 32 bytes
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c408, 0x00000400); //3102
	// This register holds the number of valid bytes in the Event Buffer
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c40c, 0x00000000); //3103

	// Simulation Speed Up Factor. Program this register to override scaledown
	if (SIM_EN)
		reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c110,0x30c12004 | 0x00000010); //3044
	else
		reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c110,0x30c12004 | 0x00000000); //3044

	// Program device speed [2:0] bits and periodic frame interval
	// DCFG.DEVSPD=3'b000: High-speed
	// DCFG.DEVSPD=3'b001: Full-speed
	// DCFG.DEVSPD=3'b100: Super-speed
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c700, 0x00080800 | USB_SPEED); // 31c0

	// At a minimum, enable USB Reset, Connection Done, and USB/Link State Change events.
    reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c708, 0x0000000f); // 31c2
}

// 3. USB Reset Event Sequence
void Initialization_on_USB_Reset() {

	event_while(0x00000101);

	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c700, 0x00080800 | USB_SPEED); // 31c0
}

// 4. Connect Done Event Sequence
void Initialization_on_Connect_Done() {

	event_while(0x00000201);

	DEPCFG(0x0, 0x00000000, 0x00000500, 0x80000200);
	DEPCFG(0x1, 0x00000000, 0x02000500, 0x80000200);

	if (SIM_EN)
		// With Simulation
		reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c110,(0x30c12004 | 0x00000010));
	else
		// Without Simulation
		reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c110,(0x30c12004 | 0x00000000));
}

void usb_depcfg(void){
	DEPSTARTCFG(0x0);
	DEPCFG(0x0, 0x00000000, 0x00000500, 0x00000200);
	DEPCFG(0x1, 0x00000000, 0x02000500, 0x00000200);
	DEPXFERCFG(0x0);
	DEPXFERCFG(0x1);

	// Prepare a buffer for a setup packet, initialize a setup TRB
	TRB_Control_setup();

	// Enable physical endpoints 0 & 1 by writing 0x3 to this register
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c720, 0x00000003); // 31c8

	// Set DCTL.RunStop to ‘1’ to allow the device to attach to the host
	reg_32b_write(RISCV_USB_CONFIGURATION_ADDRESS | 0x0000c704, 0x80000000 | 0x00f00000); // 31c1
}