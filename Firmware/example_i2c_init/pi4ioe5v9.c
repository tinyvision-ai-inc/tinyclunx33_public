#include "pi4ioe5v9.h"
#include <libbase/uart.h>
#include <libbase/console.h>
#include <libbase/i2c.h>

static bool i2c_expander_write(uint8_t addr, uint8_t data) {
    uint8_t val = data;
    return i2c_write(EXPANDER_I2C_ADDR, addr, &val, 1, 1);
}

static bool i2c_expander_read(uint8_t addr, uint8_t *data) {
    return i2c_read (EXPANDER_I2C_ADDR, addr, data, 1, true, 1);
}

void pi4ioe5v9_init(pi4ioe5v9_state_t *state) {
    i2c_expander_read(DEVICE_ID_CONTROL_REGISTER, &state->device_id_control);
    if (state->device_id_control != DEVICE_ID_RESET_STATE) {
        printf("GPIO expander not found. Exiting...\n\r");
        exit(1);
    }
    i2c_expander_read(IO_DIRECTION_REGISTER, &state->io_direction);
    i2c_expander_read(OUTPUT_PORT_REGISTER, &state->output_port);
    i2c_expander_read(OUTPUT_HIGH_IMPEDANCE_REGISTER, &state->output_high_impedance);
    i2c_expander_read(INPUT_DEFAULT_STATE_REGISTER, &state->input_default_state);
    i2c_expander_read(PULL_UP_DOWN_ENABLE_REGISTER, &state->pull_up_down_enable);
    i2c_expander_read(PULL_UP_DOWN_SELECT_REGISTER, &state->pull_up_down_select);
    i2c_expander_read(INPUT_STATUS_REGISTER, &state->input_status);
    i2c_expander_read(INTERRUPT_MASK_REGISTER, &state->interrupt_mask);
    i2c_expander_read(INTERRUPT_STATUS_REGISTER, &state->interrupt_status);
}

void pi4ioe5v9_set_direction(pi4ioe5v9_state_t *state, uint8_t bit, uint8_t direction) {
    uint8_t reg_val;
    i2c_expander_read(IO_DIRECTION_REGISTER, &reg_val);
    if (direction == DIRECTION_OUTPUT) {
        reg_val |= (1 << bit);
    } else {
        reg_val &= ~(1 << bit);
    }
    i2c_expander_write(IO_DIRECTION_REGISTER, reg_val);
    state->io_direction = reg_val;
}

void pi4ioe5v9_set_output(pi4ioe5v9_state_t *state, uint8_t bit, uint8_t level) {
    uint8_t reg_val;
    i2c_expander_read(IO_DIRECTION_REGISTER, &reg_val);
    if (!(reg_val & (1 << bit))) {
        pi4ioe5v9_set_direction(state, bit, DIRECTION_OUTPUT);
    }
    i2c_expander_read(OUTPUT_PORT_REGISTER, &reg_val);
    if (level == LEVEL_HIGH) {
        reg_val |= (1 << bit);
    } else {
        reg_val &= ~(1 << bit);
    }
    i2c_expander_write(OUTPUT_PORT_REGISTER, reg_val);
    state->output_port = reg_val;
}



