#ifndef __PI4IOE5V9_H__
#define __PI4IOE5V9_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include <uart.h>
#include <libbase/uart.h>

#define EXPANDER_I2C_ADDR 0x43

#define DEVICE_ID_CONTROL_REGISTER 0x01
#define IO_DIRECTION_REGISTER 0x03
#define OUTPUT_PORT_REGISTER 0x05
#define OUTPUT_HIGH_IMPEDANCE_REGISTER 0x07
#define INPUT_DEFAULT_STATE_REGISTER 0x09
#define PULL_UP_DOWN_ENABLE_REGISTER 0x0B
#define PULL_UP_DOWN_SELECT_REGISTER 0x0D
#define INPUT_STATUS_REGISTER 0x0F
#define INTERRUPT_MASK_REGISTER 0x11
#define INTERRUPT_STATUS_REGISTER 0x13

#define DEVICE_ID_RESET_STATE 0xA0


#define DIRECTION_INPUT 0
#define DIRECTION_OUTPUT 1
#define LEVEL_HIGH 1
#define LEVEL_LOW 0


typedef struct {
    uint8_t device_id_control;
    uint8_t io_direction;
    uint8_t output_port;
    uint8_t output_high_impedance;
    uint8_t input_default_state;
    uint8_t pull_up_down_enable;
    uint8_t pull_up_down_select;
    uint8_t input_status;
    uint8_t interrupt_mask;
    uint8_t interrupt_status;
} pi4ioe5v9_state_t;

void pi4ioe5v9_init(pi4ioe5v9_state_t *pi4ioe5v9_ptr);
void pi4ioe5v9_set_direction(pi4ioe5v9_state_t *state, uint8_t bit, uint8_t direction);
void pi4ioe5v9_set_output(pi4ioe5v9_state_t *state, uint8_t bit, uint8_t level);




#endif


