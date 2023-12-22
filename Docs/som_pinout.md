# SoM Pinout

The SoM communicates with the outside through twow Hirose DF40C 60-pins
connectors, each with two rows of 30-pins.

| Pin  | Signal       | Pin  | Signal        | Pin  | Signal       | Pin  | Signal          |
|------|--------------|------|---------------|------|--------------|------|-----------------|
| Left connector (J1)                     |||| Right connector (J2)                      ||||
| Left row           || Right row           || Left row           || Right row             ||
| 01   | **GND**      | 02   | **GND**       | 01   | **GND**      | 02   | **GND**         |
| 03.U | SS_RX_P      | 04   | X             | 03.1 | TCK          | 04   | FLASH_SCK       |
| 05.U | SS_RX_N      | 06   | X             | 05.1 | JTAG_EN      | 06   | FLASH_SIO0      |
| 07   | **GND**      | 08   | **GND**       | 07.1 | TDO          | 08   | FLASH_SIO1      |
| 09.U | SS_TX_P      | 10   | X             | 09.1 | TDI          | 10   | FLASH_SIO2      |
| 11.U | SS_TX_N      | 12   | X             | 11.1 | TMS          | 12   | FLASH_SIO3      |
| 13   | **GND**      | 14   | **GND**       | 13.1 | DONE         | 14   | FLASH_SSN       |
| 15.U | USB2_P       | 16   | REFCLK_P      | 15.1 | GPIO_A1_INTN | 16.0 | GPIO1V8_A3      |
| 17.U | USB2_N       | 18   | REFCLK_N      | 17.1 | GPIO_B1      | 18.0 | PROGN           |
| 19   | **GND**      | 20   | **GND**       | 19.1 | GPIO_F1      | 20   | X               |
| 21.3 | DIFF0_P      | 22.3 | DIFF1_PCLK_P  | 21.1 | GPIO_G1      | 22   | X               |
| 23.3 | DIFF0_N      | 24.3 | DIFF1_PCLK_N  | 23.0 | SDA          | 24   | X               |
| 25   | **GND**      | 26   | **GND**       | 25.0 | SCL          | 26   | X               |
| 27.3 | DIFF2_P      | 28.3 | DIFF3_PCLK_P  | 27   | **GND**      | 28   | X               |
| 29.3 | DIFF2_N      | 30.3 | DIFF3_PCLK_N  | 29   | X            | 30   | X               |
| 31   | **GND**      | 32   | **GND**       | 31   | X            | 32   | X               |
| 33.3 | DIFF4_PCLK_P | 34.3 | DIFF5_PCLK_P  | 33   | X            | 34   | X               |
| 35.3 | DIFF4_PCLK_N | 36.3 | DIFF5_PCLK_N  | 35   | X            | 36   | X               |
| 37   | **GND**      | 38   | **GND**       | 37   | X            | 38   | X               |
| 39   | X            | 40   | X             | 39   | X            | 40.0 | CLK2            |
| 41   | X            | 42   | X             | 41   | X            | 42.0 | GPIO1V8_H8_PCLK |
| 43   | **GND**      | 44   | **GND**       | 43   | X            | 44   | **GND**         |
| 45   | X            | 46   | X             | 45   | X            | 46.P | VBUS            |
| 47   | X            | 48   | X             | 47   | **GND**      | 48   | EN              |
| 49   | **GND**      | 50   | **GND**       | 49.0 | AON_OUT      | 50   | **GND**         |
| 51   | X            | 52   | X             | 51.0 | AON_INT      | 52.P | P5V             |
| 53   | X            | 54   | X             | 53   | P1V_AON      | 54.P | P5V             |
| 55   | **GND**      | 56   | **GND**       | 55.0 | P1V8D        | 56.P | P3V3D           |
| 57   | X            | 58   | X             | 57.P | PVDD_1       | 58.P | PVDD_2          |
| 59   | X            | 60   | X             | 59.P | PVDD_3       | 60   | PVDD_4          |

The meaning of the labels in the "Pin" column is:

- `.P` - Voltage rail providing power
- `.U` - VBUS I/O voltage level
- `.0` - Bank 0 I/O voltage level at 1.8 V
- `.1` - Bank 1 I/O voltage level selectable between 1.2 V and 3.3 V
- `.2` - Bank 2 I/O voltage level selectable between 1.2 V and 1.8 V
- `.3` - Bank 3 I/O voltage level selectable between 1.2 V and 1.8 V

TODO: Document the connectivity variant

## Parts used

- Hirose [DF40C-60](https://www.hirose.com/en/product/document?clcode=&productname=&series=DF40&documenttype=Guideline&lang=en&documentid=D80_en)
  60 pin connectors (x2)

![](images/som_connectors.png)
