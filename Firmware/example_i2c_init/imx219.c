#include "imx219.h"

#include "system.h"
#include <stdbool.h>
#include <libbase/uart.h>
#include <libbase/console.h>
//#include <libbase/i2c.h>

static bool i2c_write(uint8_t addr, uint8_t reg, uint8_t *data, int len, int stop) {
    // Dummy function for I2C write
    return true;
}

static bool i2c_read(uint8_t addr, uint8_t reg, uint8_t *data, int len) {
    // Dummy function for I2C read
    return true;
}
static bool sensor_i2c_write(uint16_t addr, uint8_t data) {
	uint8_t val = data;
	return i2c_write(IMX219_I2C_ADDR, addr, &val, 1, 2);
}

static bool sensor_i2c_read(uint16_t addr, uint8_t *data) {
//	return i2c_read (IMX219_I2C_ADDR, addr, data, 1, true, 2);
	return i2c_read (IMX219_I2C_ADDR, addr, data, 1);
}

imgsensor_mode_t *selected_img_mode;

static const imx219_reg_t mode_default[]={	//default register settings, Resolution and FPS specific settings will be over written
		 {REG_MODE_SEL,			0x00},
		 {0x30EB,				0x05},	//access sequence
		 {0x30EB,				0x0C},
		 {0x300A,				0xFF},
		 {0x300B,				0xFF},
		 {0x30EB,				0x05},
		 {0x30EB,				0x09},
		 {REG_CSI_LANE,			0x01},	//3-> 4Lane 1-> 2Lane
		 {REG_DPHY_CTRL,		0x00},	//DPHY timing 0-> auot 1-> manual
		 {REG_EXCK_FREQ_MSB,	0x18},	//external oscillator frequncy 0x18 -> 24Mhz
		 {REG_EXCK_FREQ_LSB,	0x00},
		 {REG_FRAME_LEN_MSB,	0x06},	//frame length , Raspberry pi sends this commands continously when recording video @60fps ,writes come at interval of 32ms , Data 355 for resolution 1280x720 command 162 also comes along with data 0DE7 also 15A with data 0200
		 {REG_FRAME_LEN_LSB,	0xE3},
		 {REG_LINE_LEN_MSB,		0x0d},	//does not directly affect how many bits on wire in one line does affect how many clock between lines
		 {REG_LINE_LEN_LSB,		0x78},	//appears to be having step in value, not every LSb change will reflect on fps
		 {REG_X_ADD_STA_MSB,	0x02},	//x start
		 {REG_X_ADD_STA_LSB,	0xA8},
		 {REG_X_ADD_END_MSB,	0x0A},	//x end
		 {REG_X_ADD_END_LSB,	0x27},
		 {REG_Y_ADD_STA_MSB,	0x02},	//y start
		 {REG_Y_ADD_STA_LSB,	0xB4},
		 {REG_Y_ADD_END_MSB,	0x06},	//y end
		 {REG_Y_ADD_END_LSB,	0xEB},
		 {REG_X_OUT_SIZE_MSB,	0x07},	//resolution 1280 -> 5 00 , 1920 -> 780 , 2048 -> 0x8 0x00
		 {REG_X_OUT_SIZE_LSB,	0x80},
		 {REG_Y_OUT_SIZE_MSB,	0x04},	// 720 -> 0x02D0 | 1080 -> 0x438  | this setting changes how many line over wire does not affect frame rate
		 {REG_Y_OUT_SIZE_LSB,	0x38},
		 {REG_X_ODD_INC,		0x01},	//increment
		 {REG_Y_ODD_INC,		0x01},	//increment
		 {REG_BINNING_H,		0x00},	//binning H 0 off 1 x2 2 x4 3 x2 analog
		 {REG_BINNING_V,		0x00},	//binning H 0 off 1 x2 2 x4 3 x2 analog
		 {REG_CSI_FORMAT_C,		0x0A},	//CSI Data format A-> 10bit
		 {REG_CSI_FORMAT_D,		0x0A},	//CSI Data format
		 {REG_VTPXCK_DIV,		0x05},	//vtpxclkd_div	5 301
		 {REG_VTSYCK_DIV,		0x01},	//vtsclk _div  1	303
		 {REG_PREPLLCK_VT_DIV,	0x03},	//external oscillator /3
		 {REG_PREPLLCK_OP_DIV,	0x03},	//external oscillator /3
		 {REG_PLL_VT_MPY_MSB,	0x00},	//PLL_VT multiplizer
		 {REG_PLL_VT_MPY_LSB,	0x52},	//Changes Frame rate with , integration register 0x15a
		 {REG_OPPXCK_DIV,		0x0A},	//oppxck_div
		 {REG_OPSYCK_DIV,		0x01},	//opsysck_div
		 {REG_PLL_OP_MPY_MSB,	0x00},	//PLL_OP
		 {REG_PLL_OP_MPY_LSB,	0x32}, 	// 8Mhz x 0x57 ->696Mhz -> 348Mhz |  0x32 -> 200Mhz | 0x40 -> 256Mhz
		 {0x455E,				0x00},	//magic?
		 {0x471E,				0x4B},
		 {0x4767,				0x0F},
		 {0x4750,				0x14},
		 {0x4540,				0x00},
		 {0x47B4,				0x14},
		 {0x4713,				0x30},
		 {0x478B,				0x10},
		 {0x478F,				0x10},
		 {0x4793,				0x10},
		 {0x4797,				0x0E},
		 {0x479B,				0x0E},
		 {REG_TP_RED_MSB,		0x00},
		 {REG_TP_RED_LSB,		0x00},
		 {REG_TP_GREEN_MSB, 	0x00},
		 {REG_TP_GREEN_LSB,		0x00},
		 {REG_TP_BLUE_MSB,		0x00},
		 {REG_TP_BLUE_LSB,		0x00},
		 {REG_TEST_PATTERN_MSB, 0x00},	//test pattern
		 {REG_TEST_PATTERN_LSB, 0x00},
		 {REG_TP_X_OFFSET_MSB,  0x00}, //tp offset x 0
		 {REG_TP_X_OFFSET_LSB,  0x00},
		 {REG_TP_Y_OFFSET_MSB,  0x00}, //tp offset y 0
		 {REG_TP_Y_OFFSET_LSB,  0x00},
		 {REG_TP_WIDTH_MSB,   	0x05}, //TP width 1920 ->780 1280->500
		 {REG_TP_WIDTH_LSB,   	0x00},
		 {REG_TP_HEIGHT_MSB,   	0x02}, //TP height 1080 -> 438 720->2D0
		 {REG_TP_HEIGHT_LSB,   	0xD0},
		 {REG_DIG_GAIN_GLOBAL_MSB, 	0x01},
		 {REG_DIG_GAIN_GLOBAL_LSB, 	0x00},
		 {REG_ANA_GAIN_GLOBAL, 		0x80}, //analog gain , raspberry pi constinouly changes this depending on scense
		 {REG_INTEGRATION_TIME_MSB, 0x03},	//integration time , really important for frame rate
		 {REG_INTEGRATION_TIME_LSB, 0x51},
		 {REG_IMG_ORIENT,       0x03}, // image_orientation (for both direction) bit[0]: hor bit[1]: vert
		 {REG_MODE_SEL,			0x01},

};


imgsensor_mode_t *sensor_config;

static imgsensor_mode_t sensor_config_2LANE[] = {
	{  //200Mhz 2Lane
		.pix_clk_mul = 0x2E,
		.pix_clk_div = 0x4, //only 4 or 5 or 8 or 10
		.integration = 258 - 4,	//must be < (linelength- 4) to maintain frame rate by framelength or integration time will slow frame rate
		.gain = 0x70,
		.gain_max = 0xFF,
		.linelength = 3448, 	//Warning! This value need to be either 0xD78 or 0xDE7 regardless of frame size and FPS, other values will result undefined and ununderstanable issues in image
		.framelength = 258,  //decided how long is frame, basically frame rate with pix clock, it has second priority to integration time. absolute minimum is 255 for imx219
		.startx = 1000,
		.starty = 750,
		.endx = 2280,
		.endy = 1715,		//this has to odd or bayer oder will change
		.width = 640,
		.height = 480,	//each frame will have two extra line to compensate for debayer crop
		.binning = 2,
		.fps = 200,
		.test_pattern = 0
	},



    { //200Mhz mipi 2 lane
		.pix_clk_mul = 0x2E,
		.pix_clk_div = 0x4,
		.integration = 862 - 4,
		.gain = 0x80,
		.gain_max = 0xFF,
		.linelength = 0xD78,
		.framelength = 862,
		.startx = 0x2A8,
		.starty = 0x2B4,
		.endx = 0xA27,
		.endy = 0x6EB,
		.width = 1280,
		.height = 720,
		.binning = 0,
		.fps = 60,
		.test_pattern = 0
	},

    {		//200Mhz 2Lane
		.pix_clk_mul = 0x20,
		.pix_clk_div = 0x4,
		.integration = 1200 - 4,
		.gain = 0x80,
		.gain_max = 0xFF,
		.linelength = 0xD78,
		.framelength = 1200,
		.startx = 0x2A8,
		.starty = 0x2B4,
		.endx = 0xA27,
		.endy = 0x6EB,
		.width = 1920,
		.height = 1080,
		.binning = 0,
		.fps = 30,
		.test_pattern = 0
	},


	{	//200Mhz 2Lane
		.pix_clk_mul = 0x2D,
		.pix_clk_div = 0x4,
		.integration = 56 - 4,
		.gain = 200,
		.gain_max = 0xFF,
		.linelength = 0xD78,
		.framelength = 56,
		.startx = 1320,
		.starty = 990,
		.endx = 2600,
		.endy = 1561,
		.width = 640,
		.height = 80,
		.binning = 2,
		.fps = 900,
		.test_pattern = 0
	},

	{	//200Mhz 2 Lane
		.pix_clk_mul = 0x12,
		.pix_clk_div = 0x4,
		.integration = 2670 - 4,
		.gain = 200,
		.gain_max = 0xFF,
		.linelength = 0xD78, //3448
		.framelength = 2670,
		.startx = 0,
		.starty = 0,
		.endx = 3279,
		.endy = 2463,
		.width = 3280,
		.height = 2464,
		.binning = 0,
		.fps = 5,
		.test_pattern = 0
	},

	{	//200Mhz 2 Lane
		.pix_clk_mul = 0x12,
		.pix_clk_div = 0x4,
		.integration = 2670 - 4,
		.gain = 200,
		.gain_max = 0xFF,
		.linelength = 0xD78, //3448
		.framelength = 2670,
		.startx = 0,
		.starty = 0,
		.endx = 3279,
		.endy = 2463,
		.width = 3280,
		.height = 2464,
		.binning = 0,
		.fps = 7,
		.test_pattern = 0
	},

};


uint8_t camera_stream_on (uint8_t on)
{
   return sensor_i2c_write(REG_MODE_SEL , on);
}

void SensorReset (void)
{
    sensor_i2c_write(REG_SW_RESET , 0x01);
    /* Wait for some time to allow proper reset. */
	busy_wait_us(10);
    /* Delay the allow the sensor to power up. */
    sensor_i2c_write(REG_SW_RESET , 0x00);
	busy_wait_us(100);
    return;
}



static void sensor_configure_mode(imgsensor_mode_t * mode)
{
	//set_mirror_flip(mode->mirror);
	camera_stream_on(false);
	sensor_i2c_write(REG_PLL_VT_MPY_MSB, GET_WORD_MSB(mode->pix_clk_mul));
	sensor_i2c_write(REG_PLL_VT_MPY_LSB, GET_WORD_LSB(mode->pix_clk_mul));

	sensor_i2c_write(REG_VTPXCK_DIV, GET_WORD_LSB(mode->pix_clk_div));

	sensor_i2c_write(REG_INTEGRATION_TIME_MSB, GET_WORD_MSB(mode->integration));
	sensor_i2c_write(REG_INTEGRATION_TIME_LSB, GET_WORD_LSB(mode->integration));

	sensor_i2c_write(REG_ANALOG_GAIN, 	GET_WORD_LSB(mode->gain));
	sensor_i2c_write(REG_LINE_LEN_MSB, 	GET_WORD_MSB(mode->linelength));
	sensor_i2c_write(REG_LINE_LEN_LSB, 	GET_WORD_LSB(mode->linelength));

	sensor_i2c_write(REG_FRAME_LEN_MSB, GET_WORD_MSB(mode->framelength));
	sensor_i2c_write(REG_FRAME_LEN_LSB, GET_WORD_LSB(mode->framelength));

	sensor_i2c_write(REG_X_ADD_STA_MSB, GET_WORD_MSB(mode->startx));
	sensor_i2c_write(REG_X_ADD_STA_LSB, GET_WORD_LSB(mode->startx));

	sensor_i2c_write(REG_Y_ADD_STA_MSB, GET_WORD_MSB(mode->starty));
	sensor_i2c_write(REG_Y_ADD_STA_LSB, GET_WORD_LSB(mode->starty));

	sensor_i2c_write(REG_X_ADD_END_MSB, GET_WORD_MSB(mode->endx));
	sensor_i2c_write(REG_X_ADD_END_LSB, GET_WORD_LSB(mode->endx));

	sensor_i2c_write(REG_Y_ADD_END_MSB, GET_WORD_MSB(mode->endy));
	sensor_i2c_write(REG_Y_ADD_END_LSB, GET_WORD_LSB(mode->endy));

	sensor_i2c_write(REG_X_OUT_SIZE_MSB, GET_WORD_MSB(mode->width));
	sensor_i2c_write(REG_X_OUT_SIZE_LSB, GET_WORD_LSB(mode->width));

	sensor_i2c_write(REG_Y_OUT_SIZE_MSB, GET_WORD_MSB(mode->height));
	sensor_i2c_write(REG_Y_OUT_SIZE_LSB, GET_WORD_LSB(mode->height));

	sensor_i2c_write(REG_TEST_PATTERN_LSB, (mode->test_pattern < 8)? mode->test_pattern : 0);

	sensor_i2c_write(REG_TP_WIDTH_MSB, GET_WORD_MSB(mode->width));
	sensor_i2c_write(REG_TP_WIDTH_LSB, GET_WORD_LSB(mode->width));
	sensor_i2c_write(REG_TP_HEIGHT_MSB, GET_WORD_MSB(mode->height));
	sensor_i2c_write(REG_TP_HEIGHT_LSB, GET_WORD_LSB(mode->height));

	if ( mode->binning == 2)
	{
	sensor_i2c_write(REG_BINNING_H, 0x03);
	sensor_i2c_write(REG_BINNING_V, 0x03);
	}
	else
	{
		sensor_i2c_write(REG_BINNING_H, 0x00);
		sensor_i2c_write(REG_BINNING_V, 0x00);
	}
	camera_stream_on(1);
}

uint8_t	SensorI2cBusTest (void)
{
	uint8_t model_lsb;
	uint8_t model_msb;
	//bool i2c_read(unsigned char slave_addr, unsigned int addr, unsigned char *data, unsigned int len, bool send_stop, unsigned int addr_size)

	sensor_i2c_read (REG_MODEL_ID_MSB, &model_msb);
	sensor_i2c_read (REG_MODEL_ID_LSB, &model_lsb);

	if (((((uint16_t)model_msb & 0x0F) << 8) | model_lsb) == CAMERA_ID )
	{
		printf("I2C Sensor id: 0x%x\n", (((uint16_t)model_msb & 0x0F) << 8) | model_lsb);
		return RET_SUCCESS;
	}

	return RET_CAM_NOT_FOUND;
}

uint8_t SensorInit (void)
{

    if (SensorI2cBusTest() != RET_SUCCESS)        /* Verify that the sensor is connected. */
    {
        printf ("Error: Reading Sensor ID failed!\r\n");
        return RET_CAM_NOT_FOUND;
    }

	for (uint16_t i = 0; i < _countof(mode_default); i++)
	{
		sensor_i2c_write((mode_default + i)->address, (mode_default + i)->val);
	}
	sensor_config = sensor_config_2LANE;
	sensor_configure_mode(&sensor_config_2LANE[2]);
	return RET_SUCCESS;
}

uint8_t SensorGetBrightness (void)
{
    return selected_img_mode->gain;
}

uint16_t getMaxBrightness(void)
{
	return selected_img_mode->gain_max;
}

void SensorSetBrightness (uint8_t input)
{
	selected_img_mode->gain = input;
	sensor_i2c_write (REG_ANALOG_GAIN, input);
}

uint16_t sensor_get_min_exposure (void)
{
	return 0;
}

uint16_t sensor_get_max_exposure (void)
{
	return selected_img_mode->integration;
}

uint16_t sensor_get_def_exposure (void)
{
	return selected_img_mode->integration;
}

uint16_t sensor_get_exposure (void)
{
	return selected_img_mode->integration;
}

void sensor_set_exposure (uint16_t integration)
{
	if (integration > selected_img_mode->integration)
	{
		integration = selected_img_mode->integration;
	}
	sensor_i2c_write (REG_INTEGRATION_TIME_MSB, (integration >> 8) & 0xFF);
	sensor_i2c_write (REG_INTEGRATION_TIME_LSB, integration & 0xFF);
}


uint8_t sensor_get_test_pattern (void)
{
	return selected_img_mode->test_pattern;
}

void sensor_set_test_pattern (uint8_t test_pattern)
{
	if (test_pattern > 8)
	{
		test_pattern = 0;
	}
	selected_img_mode->test_pattern = test_pattern;
	sensor_i2c_write (REG_TEST_PATTERN_LSB, test_pattern);
}
