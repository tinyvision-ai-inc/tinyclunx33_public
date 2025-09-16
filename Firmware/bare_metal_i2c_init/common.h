#ifndef __COMMON_H__
#define __COMMON_H__

// Utility macros
#define _countof(array) (sizeof(array) / sizeof(array[0]))

#define GET_WORD_MSB(x)  ((x >> 8) & 0xFF)
#define GET_WORD_LSB(x)  (       x & 0xFF)

// Error codes:

#define RET_SUCCESS 0
#define RET_CAM_NOT_FOUND 1

#endif
