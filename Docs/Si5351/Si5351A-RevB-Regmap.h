/*
 * Si5351A Rev B Regmap Header File
 *
 * This file describes the register map for a Skyworks
 * Si5351A Rev B. It defines the meta-data for each device setting, 
 * such as number of bits and location with the device address
 * space. It was created by a Skyworks ClockBuilder Pro
 * export tool.
 * 
 * Part:	   Si5351A Rev B
 * Created By: ClockBuilder Pro v4.10 [2023-07-31]
 * Timestamp:  2023-08-08 12:20:36 GMT-07:00
 *
 * A textual, report oriented version of the register map is 
 * included at the end of this header file.
 *
 */

#ifndef SI5351A_REVB_REGMAP_HEADER
#define SI5351A_REVB_REGMAP_HEADER

#define SI5351A_REVB_NUM_SETTINGS				162
#define SI5351A_REVB_MAX_NUM_REGS				3

#define SLAB_NVMT_NO  0
#define SLAB_NVMT_YES 1

#define CHAR	char
#define UINT8	unsigned char
#define UINT16	unsigned int

typedef struct
{
	CHAR*  name;								/* Setting/bitfield name                                           */ 
	UINT8  read_only;							/* 1 for read only setting/regs or 0 for read/write                */
	UINT8  self_clearing;						/* 1 for self-clearing setting/registers or 0 otherwise            */
	UINT8  nvm_type;							/* See above                                                       */
	UINT8  bit_length;							/* Number of bits in setting                                       */
	UINT8  start_bit;							/* Least significant bit of the setting                            */
	UINT8  reg_length;							/* Number of registers that the setting is stored in               */
	UINT16 addr[SI5351A_REVB_MAX_NUM_REGS];	/* Addresses the setting is contained in						   */
	UINT8  mask[SI5351A_REVB_MAX_NUM_REGS];	/* Bitmask for each register containing the setting				   */
} si5351a_revb_regmap_t;

/* 
 * Array of setting meta-data; use macros such as SI5351A_REVB_REVID defined after
 * this block to index into the array. 
 *
 * E.g. si5351a_revb_settings[SI5351A_REVB_REVID].bit_length
 *
 * You may need to change "const" keyword to "xdata" or "code" depending 
 * on CPU/compiler/memory constraints.
 */
si5351a_revb_regmap_t const si5351a_revb_settings[SI5351A_REVB_NUM_SETTINGS] =
{

	/* REVID */
	{
		"REVID",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0000, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* XO_LOS */
	{
		"XO_LOS",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0000, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* CLK_LOS */
	{
		"CLK_LOS",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0000, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* LOL_A */
	{
		"LOL_A",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0000, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* LOL_B */
	{
		"LOL_B",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0000, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* SYS_INIT */
	{
		"SYS_INIT",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0000, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* XO_LOS_STKY */
	{
		"XO_LOS_STKY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0001, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* CLK_LOS_STKY */
	{
		"CLK_LOS_STKY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0001, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* LOL_A_STKY */
	{
		"LOL_A_STKY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0001, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* LOL_B_STKY */
	{
		"LOL_B_STKY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0001, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* SYS_INIT_STKY */
	{
		"SYS_INIT_STKY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0001, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* XO_LOS_MASK */
	{
		"XO_LOS_MASK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0002, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* CLK_LOS_MASK */
	{
		"CLK_LOS_MASK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0002, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* LOL_A_MASK */
	{
		"LOL_A_MASK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0002, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* LOL_B_MASK */
	{
		"LOL_B_MASK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0002, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* SYS_INIT_MASK */
	{
		"SYS_INIT_MASK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0002, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* CLK_OEB */
	{
		"CLK_OEB",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0003, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* STOPCLK_LOLA */
	{
		"STOPCLK_LOLA",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0004, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* STOPCLK_LOLB */
	{
		"STOPCLK_LOLB",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0004, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* DIS_RESET_LOLA */
	{
		"DIS_RESET_LOLA",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0004, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* DIS_RESET_LOLB */
	{
		"DIS_RESET_LOLB",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0004, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* AUTO_INSELA */
	{
		"AUTO_INSELA",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0004, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* AUTO_INSELB */
	{
		"AUTO_INSELB",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0004, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* I2C_ADDR_CTRL */
	{
		"I2C_ADDR_CTRL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0007, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* OEB_MASK0 */
	{
		"OEB_MASK0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0009, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OEB_MASK1 */
	{
		"OEB_MASK1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000A, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OEB_MASK2 */
	{
		"OEB_MASK2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000B, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* RST0_CTRL */
	{
		"RST0_CTRL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000E, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* RST1_CTRL */
	{
		"RST1_CTRL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000E, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* INSEL0_CTRL */
	{
		"INSEL0_CTRL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000E, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* INSEL1_CTRL */
	{
		"INSEL1_CTRL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000E, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* PLLA_SRC */
	{
		"PLLA_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000F, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* PLLB_SRC */
	{
		"PLLB_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000F, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* PLLA_INSELB */
	{
		"PLLA_INSELB",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000F, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* PLLB_INSELB */
	{
		"PLLB_INSELB",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000F, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* CLKIN_DIV */
	{
		"CLKIN_DIV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000F, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* CLK0_IDRV */
	{
		"CLK0_IDRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0010, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* CLK0_SRC */
	{
		"CLK0_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0010, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* CLK0_INV */
	{
		"CLK0_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0010, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* MS0_SRC */
	{
		"MS0_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0010, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* MS0_INT */
	{
		"MS0_INT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0010, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* CLK0_PDN */
	{
		"CLK0_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0010, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* CLK1_IDRV */
	{
		"CLK1_IDRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0011, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* CLK1_SRC */
	{
		"CLK1_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0011, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* CLK1_INV */
	{
		"CLK1_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0011, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* MS1_SRC */
	{
		"MS1_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0011, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* MS1_INT */
	{
		"MS1_INT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0011, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* CLK1_PDN */
	{
		"CLK1_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0011, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* CLK2_IDRV */
	{
		"CLK2_IDRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0012, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* CLK2_SRC */
	{
		"CLK2_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0012, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* CLK2_INV */
	{
		"CLK2_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0012, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* MS2_SRC */
	{
		"MS2_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0012, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* MS2_INT */
	{
		"MS2_INT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0012, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* CLK2_PDN */
	{
		"CLK2_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0012, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* CLK3_IDRV */
	{
		"CLK3_IDRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0013, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* CLK3_SRC */
	{
		"CLK3_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0013, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* CLK3_INV */
	{
		"CLK3_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0013, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* MS3_SRC */
	{
		"MS3_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0013, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* MS3_INT */
	{
		"MS3_INT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0013, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* CLK3_PDN */
	{
		"CLK3_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0013, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* CLK4_IDRV */
	{
		"CLK4_IDRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0014, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* CLK4_SRC */
	{
		"CLK4_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0014, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* CLK4_INV */
	{
		"CLK4_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0014, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* MS4_SRC */
	{
		"MS4_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0014, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* MS4_INT */
	{
		"MS4_INT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0014, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* CLK4_PDN */
	{
		"CLK4_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0014, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* CLK5_IDRV */
	{
		"CLK5_IDRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0015, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* CLK5_SRC */
	{
		"CLK5_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0015, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* CLK5_INV */
	{
		"CLK5_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0015, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* MS5_SRC */
	{
		"MS5_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0015, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* MS5_INT */
	{
		"MS5_INT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0015, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* CLK5_PDN */
	{
		"CLK5_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0015, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* CLK6_IDRV */
	{
		"CLK6_IDRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0016, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* CLK6_SRC */
	{
		"CLK6_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0016, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* CLK6_INV */
	{
		"CLK6_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0016, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* MS6_SRC */
	{
		"MS6_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0016, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* FBA_INT */
	{
		"FBA_INT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0016, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* CLK6_PDN */
	{
		"CLK6_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0016, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* CLK7_IDRV */
	{
		"CLK7_IDRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0017, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* CLK7_SRC */
	{
		"CLK7_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0017, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* CLK7_INV */
	{
		"CLK7_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0017, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* MS7_SRC */
	{
		"MS7_SRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0017, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* FBB_INT */
	{
		"FBB_INT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0017, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* CLK7_PDN */
	{
		"CLK7_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0017, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* CLK0_DIS_STATE */
	{
		"CLK0_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0018, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* CLK1_DIS_STATE */
	{
		"CLK1_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0018, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* CLK2_DIS_STATE */
	{
		"CLK2_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0018, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* CLK3_DIS_STATE */
	{
		"CLK3_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0018, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* CLK4_DIS_STATE */
	{
		"CLK4_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0019, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* CLK5_DIS_STATE */
	{
		"CLK5_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0019, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* CLK6_DIS_STATE */
	{
		"CLK6_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0019, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* CLK7_DIS_STATE */
	{
		"CLK7_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0019, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* MSNA_P3 */
	{
		"MSNA_P3",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		4, /* setting starts at b4 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x001F, /* Register address 0 b7:0 */
			0x001A, /* Register address 1 b7:0 */
			0x001B, /* Register address 2 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* FBA_INT_OVRD */
	{
		"FBA_INT_OVRD",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x001C, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* FBA_PI_OVRD */
	{
		"FBA_PI_OVRD",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x001C, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* MSNA_P1 */
	{
		"MSNA_P1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		18, /* 18 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x001C, /* Register address 0 b7:0 */
			0x001D, /* Register address 1 b7:0 */
			0x001E, /* Register address 2 b7:0 */

		},
		{
			0x03, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MSNA_P2 */
	{
		"MSNA_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x001F, /* Register address 0 b7:0 */
			0x0020, /* Register address 1 b7:0 */
			0x0021, /* Register address 2 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MSNB_P3 */
	{
		"MSNB_P3",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		4, /* setting starts at b4 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0027, /* Register address 0 b7:0 */
			0x0022, /* Register address 1 b7:0 */
			0x0023, /* Register address 2 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* FBB_INT_OVRD */
	{
		"FBB_INT_OVRD",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0024, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* FBB_PI_OVRD */
	{
		"FBB_PI_OVRD",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0024, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* MSNB_P1 */
	{
		"MSNB_P1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		18, /* 18 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0024, /* Register address 0 b7:0 */
			0x0025, /* Register address 1 b7:0 */
			0x0026, /* Register address 2 b7:0 */

		},
		{
			0x03, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MSNB_P2 */
	{
		"MSNB_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0027, /* Register address 0 b7:0 */
			0x0028, /* Register address 1 b7:0 */
			0x0029, /* Register address 2 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS0_P4 */
	{
		"MS0_P4",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		4, /* setting starts at b4 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x002F, /* Register address 0 b7:0 */
			0x002A, /* Register address 1 b7:0 */
			0x002B, /* Register address 2 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS0_DIVBY4_0 */
	{
		"MS0_DIVBY4_0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x002C, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* MS0_DIVBY4_1 */
	{
		"MS0_DIVBY4_1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x002C, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* R0_DIV */
	{
		"R0_DIV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x002C, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* MS0_P1 */
	{
		"MS0_P1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		18, /* 18 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x002C, /* Register address 0 b7:0 */
			0x002D, /* Register address 1 b7:0 */
			0x002E, /* Register address 2 b7:0 */

		},
		{
			0x03, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS0_P2 */
	{
		"MS0_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x002F, /* Register address 0 b7:0 */
			0x0030, /* Register address 1 b7:0 */
			0x0031, /* Register address 2 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS1_P4 */
	{
		"MS1_P4",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		4, /* setting starts at b4 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0037, /* Register address 0 b7:0 */
			0x0032, /* Register address 1 b7:0 */
			0x0033, /* Register address 2 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS1_DIVBY4_0 */
	{
		"MS1_DIVBY4_0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0034, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* MS1_DIVBY4_1 */
	{
		"MS1_DIVBY4_1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0034, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* R1_DIV */
	{
		"R1_DIV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0034, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* MS1_P1 */
	{
		"MS1_P1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		18, /* 18 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0034, /* Register address 0 b7:0 */
			0x0035, /* Register address 1 b7:0 */
			0x0036, /* Register address 2 b7:0 */

		},
		{
			0x03, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS1_P2 */
	{
		"MS1_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0037, /* Register address 0 b7:0 */
			0x0038, /* Register address 1 b7:0 */
			0x0039, /* Register address 2 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS2_P4 */
	{
		"MS2_P4",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		4, /* setting starts at b4 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x003F, /* Register address 0 b7:0 */
			0x003A, /* Register address 1 b7:0 */
			0x003B, /* Register address 2 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS2_DIVBY4_0 */
	{
		"MS2_DIVBY4_0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x003C, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* MS2_DIVBY4_1 */
	{
		"MS2_DIVBY4_1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x003C, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* R2_DIV */
	{
		"R2_DIV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x003C, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* MS2_P1 */
	{
		"MS2_P1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		18, /* 18 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x003C, /* Register address 0 b7:0 */
			0x003D, /* Register address 1 b7:0 */
			0x003E, /* Register address 2 b7:0 */

		},
		{
			0x03, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS2_P2 */
	{
		"MS2_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x003F, /* Register address 0 b7:0 */
			0x0040, /* Register address 1 b7:0 */
			0x0041, /* Register address 2 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS3_P4 */
	{
		"MS3_P4",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		4, /* setting starts at b4 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0047, /* Register address 0 b7:0 */
			0x0042, /* Register address 1 b7:0 */
			0x0043, /* Register address 2 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS3_DIVBY4_0 */
	{
		"MS3_DIVBY4_0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0044, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* MS3_DIVBY4_1 */
	{
		"MS3_DIVBY4_1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0044, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* R3_DIV */
	{
		"R3_DIV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0044, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* MS3_P1 */
	{
		"MS3_P1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		18, /* 18 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0044, /* Register address 0 b7:0 */
			0x0045, /* Register address 1 b7:0 */
			0x0046, /* Register address 2 b7:0 */

		},
		{
			0x03, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS3_P2 */
	{
		"MS3_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0047, /* Register address 0 b7:0 */
			0x0048, /* Register address 1 b7:0 */
			0x0049, /* Register address 2 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS4_P4 */
	{
		"MS4_P4",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		4, /* setting starts at b4 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x004F, /* Register address 0 b7:0 */
			0x004A, /* Register address 1 b7:0 */
			0x004B, /* Register address 2 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS4_DIVBY4_0 */
	{
		"MS4_DIVBY4_0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x004C, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* MS4_DIVBY4_1 */
	{
		"MS4_DIVBY4_1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x004C, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* R4_DIV */
	{
		"R4_DIV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x004C, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* MS4_P1 */
	{
		"MS4_P1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		18, /* 18 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x004C, /* Register address 0 b7:0 */
			0x004D, /* Register address 1 b7:0 */
			0x004E, /* Register address 2 b7:0 */

		},
		{
			0x03, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS4_P2 */
	{
		"MS4_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x004F, /* Register address 0 b7:0 */
			0x0050, /* Register address 1 b7:0 */
			0x0051, /* Register address 2 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS5_P4 */
	{
		"MS5_P4",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		4, /* setting starts at b4 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0057, /* Register address 0 b7:0 */
			0x0052, /* Register address 1 b7:0 */
			0x0053, /* Register address 2 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS5_DIVBY4_0 */
	{
		"MS5_DIVBY4_0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0054, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* MS5_DIVBY4_1 */
	{
		"MS5_DIVBY4_1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0054, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* R5_DIV */
	{
		"R5_DIV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0054, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* MS5_P1 */
	{
		"MS5_P1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		18, /* 18 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0054, /* Register address 0 b7:0 */
			0x0055, /* Register address 1 b7:0 */
			0x0056, /* Register address 2 b7:0 */

		},
		{
			0x03, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS5_P2 */
	{
		"MS5_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		20, /* 20 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0057, /* Register address 0 b7:0 */
			0x0058, /* Register address 1 b7:0 */
			0x0059, /* Register address 2 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* MS6_P2 */
	{
		"MS6_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x005A, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* MS7_P2 */
	{
		"MS7_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x005B, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* R6_DIV */
	{
		"R6_DIV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x005C, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* R7_DIV */
	{
		"R7_DIV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x005C, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* SSC_EN */
	{
		"SSC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0095, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* SSDN_P2 */
	{
		"SSDN_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		15, /* 15 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0095, /* Register address 0 b7:0 */
			0x0096, /* Register address 1 b7:0 */

		},
		{
			0x7F, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* SSC_MODE */
	{
		"SSC_MODE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0097, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* SSDN_P3 */
	{
		"SSDN_P3",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		15, /* 15 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0097, /* Register address 0 b7:0 */
			0x0098, /* Register address 1 b7:0 */

		},
		{
			0x7F, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* SSDN_P1 */
	{
		"SSDN_P1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		12, /* 12 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0099, /* Register address 0 b7:0 */
			0x009A, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0x0F, /* Register mask 1 */

		}
	},

	/* SSUDP */
	{
		"SSUDP",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		12, /* 12 bits in this setting */
		4, /* setting starts at b4 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x009A, /* Register address 0 b7:0 */
			0x009B, /* Register address 1 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* SSUP_P2 */
	{
		"SSUP_P2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		15, /* 15 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x009C, /* Register address 0 b7:0 */
			0x009D, /* Register address 1 b7:0 */

		},
		{
			0x7F, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* SSUP_P3 */
	{
		"SSUP_P3",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		15, /* 15 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x009E, /* Register address 0 b7:0 */
			0x009F, /* Register address 1 b7:0 */

		},
		{
			0x7F, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* SSUP_P1 */
	{
		"SSUP_P1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		12, /* 12 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x00A0, /* Register address 0 b7:0 */
			0x00A1, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0x0F, /* Register mask 1 */

		}
	},

	/* SS_NCLK */
	{
		"SS_NCLK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00A1, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* VCXO_PARAM */
	{
		"VCXO_PARAM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		22, /* 22 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x00A2, /* Register address 0 b7:0 */
			0x00A3, /* Register address 1 b7:0 */
			0x00A4, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0x3F, /* Register mask 2 */

		}
	},

	/* CLK0_PHOFF */
	{
		"CLK0_PHOFF",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00A5, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* CLK1_PHOFF */
	{
		"CLK1_PHOFF",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00A6, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* CLK2_PHOFF */
	{
		"CLK2_PHOFF",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00A7, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* CLK3_PHOFF */
	{
		"CLK3_PHOFF",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00A8, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* CLK4_PHOFF */
	{
		"CLK4_PHOFF",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00A9, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* CLK5_PHOFF */
	{
		"CLK5_PHOFF",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00AA, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* PLLA_RST */
	{
		"PLLA_RST",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00B1, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* PLLB_RST */
	{
		"PLLB_RST",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NO, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00B1, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* XTAL_CL */
	{
		"XTAL_CL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_YES, /* Stored in NVM */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00B7, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

};

/* Setting indexes into si5351a_revb_settings array */
#define             SI5351A_REVB_REVID 0
#define            SI5351A_REVB_XO_LOS 1
#define           SI5351A_REVB_CLK_LOS 2
#define             SI5351A_REVB_LOL_A 3
#define             SI5351A_REVB_LOL_B 4
#define          SI5351A_REVB_SYS_INIT 5
#define       SI5351A_REVB_XO_LOS_STKY 6
#define      SI5351A_REVB_CLK_LOS_STKY 7
#define        SI5351A_REVB_LOL_A_STKY 8
#define        SI5351A_REVB_LOL_B_STKY 9
#define     SI5351A_REVB_SYS_INIT_STKY 10
#define       SI5351A_REVB_XO_LOS_MASK 11
#define      SI5351A_REVB_CLK_LOS_MASK 12
#define        SI5351A_REVB_LOL_A_MASK 13
#define        SI5351A_REVB_LOL_B_MASK 14
#define     SI5351A_REVB_SYS_INIT_MASK 15
#define           SI5351A_REVB_CLK_OEB 16
#define      SI5351A_REVB_STOPCLK_LOLA 17
#define      SI5351A_REVB_STOPCLK_LOLB 18
#define    SI5351A_REVB_DIS_RESET_LOLA 19
#define    SI5351A_REVB_DIS_RESET_LOLB 20
#define       SI5351A_REVB_AUTO_INSELA 21
#define       SI5351A_REVB_AUTO_INSELB 22
#define     SI5351A_REVB_I2C_ADDR_CTRL 23
#define         SI5351A_REVB_OEB_MASK0 24
#define         SI5351A_REVB_OEB_MASK1 25
#define         SI5351A_REVB_OEB_MASK2 26
#define         SI5351A_REVB_RST0_CTRL 27
#define         SI5351A_REVB_RST1_CTRL 28
#define       SI5351A_REVB_INSEL0_CTRL 29
#define       SI5351A_REVB_INSEL1_CTRL 30
#define          SI5351A_REVB_PLLA_SRC 31
#define          SI5351A_REVB_PLLB_SRC 32
#define       SI5351A_REVB_PLLA_INSELB 33
#define       SI5351A_REVB_PLLB_INSELB 34
#define         SI5351A_REVB_CLKIN_DIV 35
#define         SI5351A_REVB_CLK0_IDRV 36
#define          SI5351A_REVB_CLK0_SRC 37
#define          SI5351A_REVB_CLK0_INV 38
#define           SI5351A_REVB_MS0_SRC 39
#define           SI5351A_REVB_MS0_INT 40
#define          SI5351A_REVB_CLK0_PDN 41
#define         SI5351A_REVB_CLK1_IDRV 42
#define          SI5351A_REVB_CLK1_SRC 43
#define          SI5351A_REVB_CLK1_INV 44
#define           SI5351A_REVB_MS1_SRC 45
#define           SI5351A_REVB_MS1_INT 46
#define          SI5351A_REVB_CLK1_PDN 47
#define         SI5351A_REVB_CLK2_IDRV 48
#define          SI5351A_REVB_CLK2_SRC 49
#define          SI5351A_REVB_CLK2_INV 50
#define           SI5351A_REVB_MS2_SRC 51
#define           SI5351A_REVB_MS2_INT 52
#define          SI5351A_REVB_CLK2_PDN 53
#define         SI5351A_REVB_CLK3_IDRV 54
#define          SI5351A_REVB_CLK3_SRC 55
#define          SI5351A_REVB_CLK3_INV 56
#define           SI5351A_REVB_MS3_SRC 57
#define           SI5351A_REVB_MS3_INT 58
#define          SI5351A_REVB_CLK3_PDN 59
#define         SI5351A_REVB_CLK4_IDRV 60
#define          SI5351A_REVB_CLK4_SRC 61
#define          SI5351A_REVB_CLK4_INV 62
#define           SI5351A_REVB_MS4_SRC 63
#define           SI5351A_REVB_MS4_INT 64
#define          SI5351A_REVB_CLK4_PDN 65
#define         SI5351A_REVB_CLK5_IDRV 66
#define          SI5351A_REVB_CLK5_SRC 67
#define          SI5351A_REVB_CLK5_INV 68
#define           SI5351A_REVB_MS5_SRC 69
#define           SI5351A_REVB_MS5_INT 70
#define          SI5351A_REVB_CLK5_PDN 71
#define         SI5351A_REVB_CLK6_IDRV 72
#define          SI5351A_REVB_CLK6_SRC 73
#define          SI5351A_REVB_CLK6_INV 74
#define           SI5351A_REVB_MS6_SRC 75
#define           SI5351A_REVB_FBA_INT 76
#define          SI5351A_REVB_CLK6_PDN 77
#define         SI5351A_REVB_CLK7_IDRV 78
#define          SI5351A_REVB_CLK7_SRC 79
#define          SI5351A_REVB_CLK7_INV 80
#define           SI5351A_REVB_MS7_SRC 81
#define           SI5351A_REVB_FBB_INT 82
#define          SI5351A_REVB_CLK7_PDN 83
#define    SI5351A_REVB_CLK0_DIS_STATE 84
#define    SI5351A_REVB_CLK1_DIS_STATE 85
#define    SI5351A_REVB_CLK2_DIS_STATE 86
#define    SI5351A_REVB_CLK3_DIS_STATE 87
#define    SI5351A_REVB_CLK4_DIS_STATE 88
#define    SI5351A_REVB_CLK5_DIS_STATE 89
#define    SI5351A_REVB_CLK6_DIS_STATE 90
#define    SI5351A_REVB_CLK7_DIS_STATE 91
#define           SI5351A_REVB_MSNA_P3 92
#define      SI5351A_REVB_FBA_INT_OVRD 93
#define       SI5351A_REVB_FBA_PI_OVRD 94
#define           SI5351A_REVB_MSNA_P1 95
#define           SI5351A_REVB_MSNA_P2 96
#define           SI5351A_REVB_MSNB_P3 97
#define      SI5351A_REVB_FBB_INT_OVRD 98
#define       SI5351A_REVB_FBB_PI_OVRD 99
#define           SI5351A_REVB_MSNB_P1 100
#define           SI5351A_REVB_MSNB_P2 101
#define            SI5351A_REVB_MS0_P4 102
#define      SI5351A_REVB_MS0_DIVBY4_0 103
#define      SI5351A_REVB_MS0_DIVBY4_1 104
#define            SI5351A_REVB_R0_DIV 105
#define            SI5351A_REVB_MS0_P1 106
#define            SI5351A_REVB_MS0_P2 107
#define            SI5351A_REVB_MS1_P4 108
#define      SI5351A_REVB_MS1_DIVBY4_0 109
#define      SI5351A_REVB_MS1_DIVBY4_1 110
#define            SI5351A_REVB_R1_DIV 111
#define            SI5351A_REVB_MS1_P1 112
#define            SI5351A_REVB_MS1_P2 113
#define            SI5351A_REVB_MS2_P4 114
#define      SI5351A_REVB_MS2_DIVBY4_0 115
#define      SI5351A_REVB_MS2_DIVBY4_1 116
#define            SI5351A_REVB_R2_DIV 117
#define            SI5351A_REVB_MS2_P1 118
#define            SI5351A_REVB_MS2_P2 119
#define            SI5351A_REVB_MS3_P4 120
#define      SI5351A_REVB_MS3_DIVBY4_0 121
#define      SI5351A_REVB_MS3_DIVBY4_1 122
#define            SI5351A_REVB_R3_DIV 123
#define            SI5351A_REVB_MS3_P1 124
#define            SI5351A_REVB_MS3_P2 125
#define            SI5351A_REVB_MS4_P4 126
#define      SI5351A_REVB_MS4_DIVBY4_0 127
#define      SI5351A_REVB_MS4_DIVBY4_1 128
#define            SI5351A_REVB_R4_DIV 129
#define            SI5351A_REVB_MS4_P1 130
#define            SI5351A_REVB_MS4_P2 131
#define            SI5351A_REVB_MS5_P4 132
#define      SI5351A_REVB_MS5_DIVBY4_0 133
#define      SI5351A_REVB_MS5_DIVBY4_1 134
#define            SI5351A_REVB_R5_DIV 135
#define            SI5351A_REVB_MS5_P1 136
#define            SI5351A_REVB_MS5_P2 137
#define            SI5351A_REVB_MS6_P2 138
#define            SI5351A_REVB_MS7_P2 139
#define            SI5351A_REVB_R6_DIV 140
#define            SI5351A_REVB_R7_DIV 141
#define            SI5351A_REVB_SSC_EN 142
#define           SI5351A_REVB_SSDN_P2 143
#define          SI5351A_REVB_SSC_MODE 144
#define           SI5351A_REVB_SSDN_P3 145
#define           SI5351A_REVB_SSDN_P1 146
#define             SI5351A_REVB_SSUDP 147
#define           SI5351A_REVB_SSUP_P2 148
#define           SI5351A_REVB_SSUP_P3 149
#define           SI5351A_REVB_SSUP_P1 150
#define           SI5351A_REVB_SS_NCLK 151
#define        SI5351A_REVB_VCXO_PARAM 152
#define        SI5351A_REVB_CLK0_PHOFF 153
#define        SI5351A_REVB_CLK1_PHOFF 154
#define        SI5351A_REVB_CLK2_PHOFF 155
#define        SI5351A_REVB_CLK3_PHOFF 156
#define        SI5351A_REVB_CLK4_PHOFF 157
#define        SI5351A_REVB_CLK5_PHOFF 158
#define          SI5351A_REVB_PLLA_RST 159
#define          SI5351A_REVB_PLLB_RST 160
#define           SI5351A_REVB_XTAL_CL 161
/*
 * Regmap Report Corresponding to Above
 *
 * Setting Name    Location      Start Address  Start Bit  Num Bits  NVM  Type
 * --------------  ------------  -------------  ---------  --------  ---  ----
 * SYS_INIT        0x0000[7]     0x0000         7          1         No   R/O 
 * LOL_B           0x0000[6]     0x0000         6          1         No   R/O 
 * LOL_A           0x0000[5]     0x0000         5          1         No   R/O 
 * CLK_LOS         0x0000[4]     0x0000         4          1         No   R/O 
 * XO_LOS          0x0000[3]     0x0000         3          1         No   R/O 
 * REVID           0x0000[1:0]   0x0000         0          2         No   R/O 
 * SYS_INIT_STKY   0x0001[7]     0x0001         7          1         No   R/W 
 * LOL_B_STKY      0x0001[6]     0x0001         6          1         No   R/W 
 * LOL_A_STKY      0x0001[5]     0x0001         5          1         No   R/W 
 * CLK_LOS_STKY    0x0001[4]     0x0001         4          1         No   R/W 
 * XO_LOS_STKY     0x0001[3]     0x0001         3          1         No   R/W 
 * SYS_INIT_MASK   0x0002[7]     0x0002         7          1         Yes  R/W 
 * LOL_B_MASK      0x0002[6]     0x0002         6          1         Yes  R/W 
 * LOL_A_MASK      0x0002[5]     0x0002         5          1         Yes  R/W 
 * CLK_LOS_MASK    0x0002[4]     0x0002         4          1         Yes  R/W 
 * XO_LOS_MASK     0x0002[3]     0x0002         3          1         Yes  R/W 
 * CLK_OEB         0x0003[7:0]   0x0003         0          8         No   R/W 
 * AUTO_INSELB     0x0004[7]     0x0004         7          1         No   R/W 
 * AUTO_INSELA     0x0004[6]     0x0004         6          1         No   R/W 
 * DIS_RESET_LOLB  0x0004[5]     0x0004         5          1         No   R/W 
 * DIS_RESET_LOLA  0x0004[4]     0x0004         4          1         No   R/W 
 * STOPCLK_LOLB    0x0004[1]     0x0004         1          1         No   R/W 
 * STOPCLK_LOLA    0x0004[0]     0x0004         0          1         No   R/W 
 * I2C_ADDR_CTRL   0x0007[7:4]   0x0007         4          4         Yes  R/W 
 * OEB_MASK0       0x0009[7:0]   0x0009         0          8         Yes  R/W 
 * OEB_MASK1       0x000A[7:0]   0x000A         0          8         Yes  R/W 
 * OEB_MASK2       0x000B[7:0]   0x000B         0          8         No   R/W 
 * INSEL1_CTRL     0x000E[7:6]   0x000E         6          2         No   R/W 
 * INSEL0_CTRL     0x000E[5:4]   0x000E         4          2         No   R/W 
 * RST1_CTRL       0x000E[3:2]   0x000E         2          2         No   R/W 
 * RST0_CTRL       0x000E[1:0]   0x000E         0          2         No   R/W 
 * CLKIN_DIV       0x000F[7:6]   0x000F         6          2         Yes  R/W 
 * PLLB_INSELB     0x000F[5]     0x000F         5          1         Yes  R/W 
 * PLLA_INSELB     0x000F[4]     0x000F         4          1         Yes  R/W 
 * PLLB_SRC        0x000F[3]     0x000F         3          1         Yes  R/W 
 * PLLA_SRC        0x000F[2]     0x000F         2          1         Yes  R/W 
 * CLK0_PDN        0x0010[7]     0x0010         7          1         Yes  R/W 
 * MS0_INT         0x0010[6]     0x0010         6          1         Yes  R/W 
 * MS0_SRC         0x0010[5]     0x0010         5          1         Yes  R/W 
 * CLK0_INV        0x0010[4]     0x0010         4          1         Yes  R/W 
 * CLK0_SRC        0x0010[3:2]   0x0010         2          2         Yes  R/W 
 * CLK0_IDRV       0x0010[1:0]   0x0010         0          2         Yes  R/W 
 * CLK1_PDN        0x0011[7]     0x0011         7          1         Yes  R/W 
 * MS1_INT         0x0011[6]     0x0011         6          1         Yes  R/W 
 * MS1_SRC         0x0011[5]     0x0011         5          1         Yes  R/W 
 * CLK1_INV        0x0011[4]     0x0011         4          1         Yes  R/W 
 * CLK1_SRC        0x0011[3:2]   0x0011         2          2         Yes  R/W 
 * CLK1_IDRV       0x0011[1:0]   0x0011         0          2         Yes  R/W 
 * CLK2_PDN        0x0012[7]     0x0012         7          1         Yes  R/W 
 * MS2_INT         0x0012[6]     0x0012         6          1         Yes  R/W 
 * MS2_SRC         0x0012[5]     0x0012         5          1         Yes  R/W 
 * CLK2_INV        0x0012[4]     0x0012         4          1         Yes  R/W 
 * CLK2_SRC        0x0012[3:2]   0x0012         2          2         Yes  R/W 
 * CLK2_IDRV       0x0012[1:0]   0x0012         0          2         Yes  R/W 
 * CLK3_PDN        0x0013[7]     0x0013         7          1         Yes  R/W 
 * MS3_INT         0x0013[6]     0x0013         6          1         Yes  R/W 
 * MS3_SRC         0x0013[5]     0x0013         5          1         Yes  R/W 
 * CLK3_INV        0x0013[4]     0x0013         4          1         Yes  R/W 
 * CLK3_SRC        0x0013[3:2]   0x0013         2          2         Yes  R/W 
 * CLK3_IDRV       0x0013[1:0]   0x0013         0          2         Yes  R/W 
 * CLK4_PDN        0x0014[7]     0x0014         7          1         Yes  R/W 
 * MS4_INT         0x0014[6]     0x0014         6          1         Yes  R/W 
 * MS4_SRC         0x0014[5]     0x0014         5          1         Yes  R/W 
 * CLK4_INV        0x0014[4]     0x0014         4          1         Yes  R/W 
 * CLK4_SRC        0x0014[3:2]   0x0014         2          2         Yes  R/W 
 * CLK4_IDRV       0x0014[1:0]   0x0014         0          2         Yes  R/W 
 * CLK5_PDN        0x0015[7]     0x0015         7          1         Yes  R/W 
 * MS5_INT         0x0015[6]     0x0015         6          1         Yes  R/W 
 * MS5_SRC         0x0015[5]     0x0015         5          1         Yes  R/W 
 * CLK5_INV        0x0015[4]     0x0015         4          1         Yes  R/W 
 * CLK5_SRC        0x0015[3:2]   0x0015         2          2         Yes  R/W 
 * CLK5_IDRV       0x0015[1:0]   0x0015         0          2         Yes  R/W 
 * CLK6_PDN        0x0016[7]     0x0016         7          1         Yes  R/W 
 * FBA_INT         0x0016[6]     0x0016         6          1         Yes  R/W 
 * MS6_SRC         0x0016[5]     0x0016         5          1         Yes  R/W 
 * CLK6_INV        0x0016[4]     0x0016         4          1         Yes  R/W 
 * CLK6_SRC        0x0016[3:2]   0x0016         2          2         Yes  R/W 
 * CLK6_IDRV       0x0016[1:0]   0x0016         0          2         Yes  R/W 
 * CLK7_PDN        0x0017[7]     0x0017         7          1         Yes  R/W 
 * FBB_INT         0x0017[6]     0x0017         6          1         Yes  R/W 
 * MS7_SRC         0x0017[5]     0x0017         5          1         Yes  R/W 
 * CLK7_INV        0x0017[4]     0x0017         4          1         Yes  R/W 
 * CLK7_SRC        0x0017[3:2]   0x0017         2          2         Yes  R/W 
 * CLK7_IDRV       0x0017[1:0]   0x0017         0          2         Yes  R/W 
 * CLK3_DIS_STATE  0x0018[7:6]   0x0018         6          2         No   R/W 
 * CLK2_DIS_STATE  0x0018[5:4]   0x0018         4          2         No   R/W 
 * CLK1_DIS_STATE  0x0018[3:2]   0x0018         2          2         No   R/W 
 * CLK0_DIS_STATE  0x0018[1:0]   0x0018         0          2         No   R/W 
 * CLK7_DIS_STATE  0x0019[7:6]   0x0019         6          2         No   R/W 
 * CLK6_DIS_STATE  0x0019[5:4]   0x0019         4          2         No   R/W 
 * CLK5_DIS_STATE  0x0019[3:2]   0x0019         2          2         No   R/W 
 * CLK4_DIS_STATE  0x0019[1:0]   0x0019         0          2         No   R/W 
 * FBA_PI_OVRD     0x001C[3]     0x001C         3          1         No   R/W 
 * FBA_INT_OVRD    0x001C[2]     0x001C         2          1         No   R/W 
 * MSNA_P1         0x001C[17:0]  0x001C         0          18        No   R/W 
 * MSNA_P3         0x001F[23:4]  0x001F         4          20        No   R/W 
 * MSNA_P2         0x001F[19:0]  0x001F         0          20        No   R/W 
 * FBB_PI_OVRD     0x0024[3]     0x0024         3          1         No   R/W 
 * FBB_INT_OVRD    0x0024[2]     0x0024         2          1         No   R/W 
 * MSNB_P1         0x0024[17:0]  0x0024         0          18        No   R/W 
 * MSNB_P3         0x0027[23:4]  0x0027         4          20        No   R/W 
 * MSNB_P2         0x0027[19:0]  0x0027         0          20        No   R/W 
 * R0_DIV          0x002C[6:4]   0x002C         4          3         No   R/W 
 * MS0_DIVBY4_1    0x002C[3]     0x002C         3          1         No   R/W 
 * MS0_DIVBY4_0    0x002C[2]     0x002C         2          1         No   R/W 
 * MS0_P1          0x002C[17:0]  0x002C         0          18        No   R/W 
 * MS0_P4          0x002F[23:4]  0x002F         4          20        No   R/W 
 * MS0_P2          0x002F[19:0]  0x002F         0          20        No   R/W 
 * R1_DIV          0x0034[6:4]   0x0034         4          3         No   R/W 
 * MS1_DIVBY4_1    0x0034[3]     0x0034         3          1         No   R/W 
 * MS1_DIVBY4_0    0x0034[2]     0x0034         2          1         No   R/W 
 * MS1_P1          0x0034[17:0]  0x0034         0          18        No   R/W 
 * MS1_P4          0x0037[23:4]  0x0037         4          20        No   R/W 
 * MS1_P2          0x0037[19:0]  0x0037         0          20        No   R/W 
 * R2_DIV          0x003C[6:4]   0x003C         4          3         No   R/W 
 * MS2_DIVBY4_1    0x003C[3]     0x003C         3          1         No   R/W 
 * MS2_DIVBY4_0    0x003C[2]     0x003C         2          1         No   R/W 
 * MS2_P1          0x003C[17:0]  0x003C         0          18        No   R/W 
 * MS2_P4          0x003F[23:4]  0x003F         4          20        No   R/W 
 * MS2_P2          0x003F[19:0]  0x003F         0          20        No   R/W 
 * R3_DIV          0x0044[6:4]   0x0044         4          3         No   R/W 
 * MS3_DIVBY4_1    0x0044[3]     0x0044         3          1         No   R/W 
 * MS3_DIVBY4_0    0x0044[2]     0x0044         2          1         No   R/W 
 * MS3_P1          0x0044[17:0]  0x0044         0          18        No   R/W 
 * MS3_P4          0x0047[23:4]  0x0047         4          20        No   R/W 
 * MS3_P2          0x0047[19:0]  0x0047         0          20        No   R/W 
 * R4_DIV          0x004C[6:4]   0x004C         4          3         No   R/W 
 * MS4_DIVBY4_1    0x004C[3]     0x004C         3          1         No   R/W 
 * MS4_DIVBY4_0    0x004C[2]     0x004C         2          1         No   R/W 
 * MS4_P1          0x004C[17:0]  0x004C         0          18        No   R/W 
 * MS4_P4          0x004F[23:4]  0x004F         4          20        No   R/W 
 * MS4_P2          0x004F[19:0]  0x004F         0          20        No   R/W 
 * R5_DIV          0x0054[6:4]   0x0054         4          3         No   R/W 
 * MS5_DIVBY4_1    0x0054[3]     0x0054         3          1         No   R/W 
 * MS5_DIVBY4_0    0x0054[2]     0x0054         2          1         No   R/W 
 * MS5_P1          0x0054[17:0]  0x0054         0          18        No   R/W 
 * MS5_P4          0x0057[23:4]  0x0057         4          20        No   R/W 
 * MS5_P2          0x0057[19:0]  0x0057         0          20        No   R/W 
 * MS6_P2          0x005A[7:0]   0x005A         0          8         Yes  R/W 
 * MS7_P2          0x005B[7:0]   0x005B         0          8         Yes  R/W 
 * R7_DIV          0x005C[6:4]   0x005C         4          3         No   R/W 
 * R6_DIV          0x005C[2:0]   0x005C         0          3         No   R/W 
 * SSC_EN          0x0095[7]     0x0095         7          1         Yes  R/W 
 * SSDN_P2         0x0095[14:0]  0x0095         0          15        Yes  R/W 
 * SSC_MODE        0x0097[7]     0x0097         7          1         Yes  R/W 
 * SSDN_P3         0x0097[14:0]  0x0097         0          15        Yes  R/W 
 * SSDN_P1         0x0099[11:0]  0x0099         0          12        Yes  R/W 
 * SSUDP           0x009A[15:4]  0x009A         4          12        Yes  R/W 
 * SSUP_P2         0x009C[14:0]  0x009C         0          15        No   R/W 
 * SSUP_P3         0x009E[14:0]  0x009E         0          15        No   R/W 
 * SSUP_P1         0x00A0[11:0]  0x00A0         0          12        No   R/W 
 * SS_NCLK         0x00A1[7:4]   0x00A1         4          4         No   R/W 
 * VCXO_PARAM      0x00A2[21:0]  0x00A2         0          22        Yes  R/W 
 * CLK0_PHOFF      0x00A5[7:0]   0x00A5         0          8         No   R/W 
 * CLK1_PHOFF      0x00A6[7:0]   0x00A6         0          8         No   R/W 
 * CLK2_PHOFF      0x00A7[7:0]   0x00A7         0          8         No   R/W 
 * CLK3_PHOFF      0x00A8[7:0]   0x00A8         0          8         No   R/W 
 * CLK4_PHOFF      0x00A9[7:0]   0x00A9         0          8         No   R/W 
 * CLK5_PHOFF      0x00AA[7:0]   0x00AA         0          8         No   R/W 
 * PLLB_RST        0x00B1[7]     0x00B1         7          1         No   R/W 
 * PLLA_RST        0x00B1[5]     0x00B1         5          1         No   R/W 
 * XTAL_CL         0x00B7[7:6]   0x00B7         6          2         Yes  R/W 
 * 
 *
 */

#endif