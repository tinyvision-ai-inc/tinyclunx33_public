# SoM Pinout

The SoM communicates with the outside through twow Hirose DF40C 60-pins
connectors, each with two rows of 30-pins.

| Pin  | Signal  | Pin  | Signal  | Pin  | Signal       | Pin  | Signal      |
|------|---------|------|---------|------|--------------|------|-------------|
| Left connector (J2)          |||| Right connector (J3)                  ||||
| Left row      || Right row     || Left row           || Right row         ||
| 01   | **GND** | 02   | **GND** | 01   | **GND**      | 02   | **GND**     |
| 03.U | SS_RX_P | 04   | X       | 03.1 | TCK          | 04   | X           |
| 05.U | SS_RX_N | 06   | X       | 05.1 | JTAG_EN      | 06   | X           |
| 07   | **GND** | 08   | **GND** | 07.1 | TDO          | 08   | X           |
| 09.U | SS_TX_P | 10   | X       | 09.1 | TDI          | 10   | X           |
| 11.U | SS_TX_N | 12   | X       | 11.1 | TMS          | 12   | X           |
| 13   | **GND** | 14   | **GND** | 13.1 | DONE         | 14   | X           |
| 15.U | USB2_P  | 16   | X       | 15.1 | GPIO_A1_INTN | 16.0 | GPIO1V8_A3  |
| 17.U | USB2_N  | 18   | X       | 17.1 | GPIO_B1      | 18.0 | PROGN       |
| 19   | **GND** | 20   | **GND** | 19.1 | GPIO_F1      | 20   | X           |
| 21.3 | DIFF0_P | 22.3 | DIFF1_P | 21.1 | GPIO_G1      | 22   | X           |
| 23.3 | DIFF0_N | 24.3 | DIFF1_N | 23.0 | SDA          | 24   | X           |
| 25   | **GND** | 26   | **GND** | 25.0 | SCL          | 26   | X           |
| 27.3 | DIFF2_P | 28.3 | DIFF3_P | 27   | **GND**      | 28   | X           |
| 29.3 | DIFF2_N | 30.3 | DIFF3_N | 29   | X            | 30   | X           |
| 31   | **GND** | 32   | **GND** | 31   | X            | 32   | X           |
| 33.3 | DIFF4_P | 34.3 | DIFF5_P | 33   | X            | 34   | X           |
| 35.3 | DIFF4_N | 36.3 | DIFF5_N | 35   | X            | 36   | X           |
| 37   | **GND** | 38   | **GND** | 37   | X            | 38   | X           |
| 39   | X       | 40   | X       | 39   | X            | 40.0 | CLK2        |
| 41   | X       | 42   | X       | 41   | X            | 42.0 | GPIO_1V8_H8 |
| 43   | **GND** | 44   | **GND** | 43   | X            | 44   | **GND**     |
| 45   | X       | 46   | X       | 45   | X            | 46.P | P5V         |
| 47   | X       | 48   | X       | 47   | **GND**      | 48   | EN          |
| 49   | **GND** | 50   | **GND** | 49.0 | AON_OUT      | 50   | **GND**     |
| 51   | X       | 52   | X       | 51.0 | AON_INT      | 52.P | P5V         |
| 53   | X       | 54   | X       | 53   | T6           | 54.P | P5V         |
| 55   | **GND** | 56   | **GND** | 55.0 | P1V8D        | 56.P | P3V3_SOM    |
| 57   | X       | 58   | X       | 57.P | P3V3_SOM     | 58.P | P1V2D       |
| 59   | X       | 60   | X       | 59.P | P1V2D        | 60   | X           |

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

![](images/som_connector.png)
