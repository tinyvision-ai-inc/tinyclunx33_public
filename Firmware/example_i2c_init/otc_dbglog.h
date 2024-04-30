/**********************************************************************************************
 *
 * @file          otc_dbglog.h
 *
 **********************************************************************************************
 *                 (c) Copyright 2021; Obsidian Sensors Inc
 * All rights reserved.  Protected by international copyright laws. Knowledge of the source
 * code may not be used to write a similar product. This file may only be used in accordance
 * with a license and should not be redistributed in any way.
 *
 **********************************************************************************************
 *********************************************************************************************/

/**********************************************************************************************
 * Include files
 *********************************************************************************************/
#ifndef __OTC_DBGLOG_H__
#define __OTC_DBGLOG_H__

#include <stdint.h>
#include "otc_osal.h"

/**********************************************************************************************
 *                          FW VERSION DEFINITION
 *********************************************************************************************/
#define OBSIDIAN_FW_VERSION         "0.60"  /* Change the definition below when this changes */
#define OBSIDIAN_FW_VERSION_BCD     0x0060  /* Change the definition above when this changes */
    /* It is important to make the 2 definitions above to be in sync with each other.
     * OBSIDIAN_FW_VERSION_BCD is sent as bdcDevive, as part of the USB device descriptor.
     */

#define FAST_CODE  __attribute__((__section__(".ramfunc.$SRAM_ITC")))
/**********************************************************************************************
 * DEBUG-LOG-LEVEL DEFINITION; 0 ==> No logging enabled
 *********************************************************************************************/
#define LOG_KERN                1
#define LOG_TRACK               2
#define LOG_INFO                3
#define LOG_DEBUG               4

#ifndef DBGLOG_LEVEL
#define DBGLOG_LEVEL            LOG_DEBUG
#endif

#ifndef OBSIDIAN_ADD_TIMESTAMP
#define OBSIDIAN_ADD_TIMESTAMP  0u
#endif

/**********************************************************************************************
 * DEBUG MACROs needing OS-Functions
 *********************************************************************************************/
#define LOCK_DBGLOG()       os_enter_critical()
#define UNLOCK_DBGLOG()     os_leave_critical()
#define DEAD_LOOP(__val__)  \
do                          \
{                           \
    DLOG1("\r\n%d: DEAD at %d in %s !!\r\n", __val__, __LINE__, __FUNCTION__); \
    while (1) { os_msleep(5000u); }     \
} while (0)

/**********************************************************************************************
 * DEBUG MACROs needing TIMER-Functions
 *********************************************************************************************/
extern  uint32_t    otc_read_usec_timer(void);
#define READ_1USEC_COUNTER()    otc_read_usec_timer()

/**********************************************************************************************
 * Log levels that can be used a parameter to DLOG
 *********************************************************************************************/
#define DLOG(__loglevel__, ...) DLOG##__loglevel__(__VA_ARGS__)

/* -------- Example logging usage of the above MACRO definitions --------
    DLOG(LOG_KERN,  "example_var1=%d\r\n", example_var1);   ==> equivalent to DLOG1(...)
    DLOG(LOG_TRACK, "example_var2=%d\r\n", example_var2);   ==> equivalent to DLOG2(...)
    DLOG(LOG_INFO,  "example_var3=%d\r\n", example_var3);   ==> equivalent to DLOG3(...)
    DLOG(LOG_DEBUG, "example_var4=%d\r\n", example_var4);   ==> equivalent to DLOG4(...)
 *********************************************************************************************/

/**********************************************************************************************
 * Different log level definitions based on OBSIDIAN_ADD_TIMESTAMP #define
 *********************************************************************************************/
#if (DBGLOG_LEVEL > 0u)
#if (OBSIDIAN_ADD_TIMESTAMP > 0)
#define VPRSTR(...)         vPrStrTS(__VA_ARGS__)
#define VPRDBGLOG(...)      vPrDbglogTS(__VA_ARGS__)
#else
#define VPRSTR(...)         vWrDbglog(__VA_ARGS__)
#define VPRDBGLOG(...)      vPrDbglog(__VA_ARGS__)
#endif
#endif

/**********************************************************************************************
 * Different levels of DBGLOG_LEVEL definitions
 *********************************************************************************************/
#if (DBGLOG_LEVEL > 0u)
#define DLOG1(...)          VPRDBGLOG(__VA_ARGS__)
#define DSTR1(__str__)      VPRSTR((__str__), strlen((const char *)(__str__)))
#define FLOG(__str__)       vWrDbglog((__str__), strlen((const char *)(__str__)))
#define DLOGTS(...)         vPrDbglogTS(__VA_ARGS__)
#define DSTRTS(...)         vPrStrTS(__VA_ARGS__)

#if (DBGLOG_LEVEL > 1u)
#define DLOG2(...)          VPRDBGLOG(__VA_ARGS__)
#define DSTR2(__str__)      VPRSTR((__str__), strlen((const char *)(__str__)))
#else
#define DLOG2(...)
#define DSTR2(__str__)
#endif

#if (DBGLOG_LEVEL > 2u)
#define DLOG3(...)          VPRDBGLOG(__VA_ARGS__)
#define DSTR3(__str__)      VPRSTR((__str__), strlen((const char *)(__str__)))
#else
#define DLOG3(...)
#define DSTR3(__str__)
#endif

#if (DBGLOG_LEVEL > 3u)
#define DLOG4(...)          VPRDBGLOG(__VA_ARGS__)
#define DSTR4(__str__)      VPRSTR((__str__), strlen((const char *)(__str__)))
#else
#define DLOG4(...)
#define DSTR4(__str__)
#endif

/* -------- Exported Function Prototypes when DEBUG_LEVEL > 0 -------- */
void        vInitDbglog (void);
void        vPrDbglog (const char *fmt, ...);
void        vWrDbglog (char *pcInfo, uint32_t uiStrLen);
void        vPrDbglogTS (const char *fmt, ...);
void        vPrStrTS (char *pcInfo, uint32_t uiStrLen);
uint32_t    vRdDbglog (char **ppcTemp);

#else   /* -------- i.e., when DEBUG_LEVEL == 0 -------- */
#define DLOG1(...)
#define DLOG2(...)
#define DLOG3(...)
#define DLOG4(...)
#define DSTR1(...)
#define DSTR2(...)
#define DSTR3(...)
#define DSTR4(...)
#define FLOG(__str__)
#define vInitDbglog()
#define vRdDbglog(__ppctemp__)  0u
#endif

/*********************************************************************************************/
#endif /* __OTC_DBGLOG_H__ */
/**********************************************************************************************
 *************************************** END OF FILE *****************************************/

