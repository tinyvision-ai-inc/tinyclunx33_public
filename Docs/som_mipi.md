# SoM MIPI

The differential pairs of the CrossLinkU-NX FPGA can be combined together into
various number of MIPI interfaces of various sizes, the combo is summarized
below.

Connectivity SoM Lanes and Clocks (14 pairs available):

| 1L + 1C | 2L + 1C | 4L + 1C | Total |
|:-------:|:-------:|:-------:|:-----:|
|         | 1x      | 2x      | 13    |
| 2x      |         | 2x      | 14    |
|         | 3x      | 1x      | 14    |
| 4x      |         | 1x      | 13    |
| 1x      | 2x      | 1x      | 13    |
| 1x      | 4x      |         | 14    |
| 7x      |         |         | 14    |

Compute SoM Lanes and Clocks (6 pairs available, others used by the RAM):

| 1L + 1C | 2L + 1C | 4L + 1C | Total |
|:-------:|:-------:|:-------:|:-----:|
|         |         | 1x      | 5     |
|         | 2x      |         | 6     |
| 1x      | 1x      |         | 5     |
| 3x      |         |         | 6     |

## Parts featured

- Lattice Semiconductor
  [LIFCL-33U-8CTG104CAS](https://www.latticesemi.com/Products/FPGAandCPLD/CrossLink-NX)
  FPGA (search for 33U in this page).
