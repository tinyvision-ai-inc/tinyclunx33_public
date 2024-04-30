/**********************************************************************************************
 *
 * @file          otc_osal.h
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
#ifndef __OTC_OSAL_H__
#define __OTC_OSAL_H__


#include <stdint.h>
#include <string.h>

/**********************************************************************************************
 *                 MACROSs for OSAL APIs                                                      *
 *********************************************************************************************/
#define OS_TIMEOUT_BLOCKING     ((uint32_t) -1)
#define OS_SEMA_WAIT_FOREVER    OS_TIMEOUT_BLOCKING
#define OS_MUTEX_WAIT_FOREVER   OS_TIMEOUT_BLOCKING
#define OSAL_TRUE               1u
#define OSAL_FALSE              0u

#define INVALID_HANDLE          ((void *)0)
#define GET_MIN(__a__, __b__)   (((__a__) < (__b__)) ? (__a__) : (__b__))
#define GET_MAX(__a__, __b__)   (((__a__) > (__b__)) ? (__a__) : (__b__))

/* -------- Task PRIORITY Definitions -------- */
/*! @brief Priority setting for OS Tasks created through OSAL.
 * Lower the number, lower the priority
 * Range: 1 to 14, 1 being the lowest priority and 14 being the highest
 * Applications can use the following ENUM as is, OR can add/subtract a number
 * from the following enum. For example, a task can be created with priority
 * specified as (OS_TASK_PRIORITY_BELOW_NORMAL + 1u) or something like
 * (OS_TASK_PRIORITY_HIGH - 1u)
 */
typedef enum
{
    OS_TASK_PRIORITY_MIN            = 1,
    OS_TASK_PRIORITY_LOWEST         = OS_TASK_PRIORITY_MIN,
    OS_TASK_PRIORITY_BELOW_NORMAL   = 4,
    OS_TASK_PRIORITY_NORMAL         = 7,
    OS_TASK_PRIORITY_ABOVE_NORMAL   = 10,
    OS_TASK_PRIORITY_HIGH           = 12,
    OS_TASK_PRIORITY_REAL_TIME      = 14,
    OS_TASK_PRIORITY_MAX            = OS_TASK_PRIORITY_REAL_TIME,
    OS_TASK_PRIORITY_INVALID        = 0xFFFFFFFF,   /* To make the enum a 32-bit value */

} enumOsalTaskPriority;

/**********************************************************************************************
 *                 TYPEDEFs for OSAL APIs                                                     *
 *********************************************************************************************/
typedef void *          OS_SEMA_HANDLE_T;
typedef void *          OS_LOCK_HANDLE_T;
typedef void *          OS_QUEUE_HANDLE_T;
typedef void *          OS_TIMER_HANDLE_T;
typedef void *          OS_TASK_HANDLE_T;
typedef void *          HANDLE_T;
typedef void            (*TASK_FUNC)( void * );
typedef void            (*TIMER_CALLBACK)(OS_TIMER_HANDLE_T hTimer);

/**********************************************************************************************
 *                 FUNCTION MACROSs for OSAL APIs                                             *
 *********************************************************************************************/

#define os_enter_critical() {       \
    uint32_t __osa_current_sr__;    \
    os_enter_critical_section(&__osa_current_sr__);

#define os_leave_critical()     os_exit_critical_section(&__osa_current_sr__);  }

#define OS_SR_ALLOC()           uint32_t    __osa_current_sr__
#define OS_ENTER_CRITICAL()     os_enter_critical_section(&__osa_current_sr__)
#define OS_EXIT_CRITICAL()      os_exit_critical_section(&__osa_current_sr__);
/*********************************************************************************************/
/*!
 Function:      os_memcpy()
 Description:   Initializes the memory block with the specified value.
 @param:        pvDstMem    - PTR to destination memory block
                pvSrcMem    - PTR to source memory block
                uiSize      - Size of the memory block
 @return:       None
*********************************************************************************************/
static inline void os_memcpy(void *pvDstMem, void *pvSrcMem, unsigned int  uiSize)
{
    if ((NULL != pvDstMem) && (NULL != pvSrcMem) && (0U != uiSize))  {
        memcpy (pvDstMem, pvSrcMem, uiSize);
    }
}

/*********************************************************************************************/
/*!
 Function:      os_memset()
 Description:   Initializes the memory block with the specified value.
 @param:        pvMem       - PTR to memory to be cleared.
                ucDataValue - DATA to be initialized in the memory block.
                uiSize      - Size of the memory block
 @return:       None
*********************************************************************************************/
static inline void os_memset(void *pvMem, unsigned char ucDataValue, unsigned int  uiSize)
{
    if ((NULL != pvMem) && (0U != uiSize))  {
        memset (pvMem, ucDataValue, (size_t)uiSize);
    }
    return;
}

/*********************************************************************************************/
/*!
 Function:      os_memclr()
 Description:   Initializes the memory block with all ZEROs.
 @param:        pvMem - PTR to memory to be cleared.
                uiSize- Size of the memory block
 @return:       None
*********************************************************************************************/
static inline void os_memclr(void *pvMem, unsigned int uiSize)
{
    if ((NULL != pvMem) && (0u != uiSize)) {
        memset (pvMem, 0x00u, uiSize);
    }
    return;
}

/*********************************************************************************************/
/*!
 Function:      os_init()
 Description:   OS Initialization function, normally called on boot up in main()
 @param:        None
 @return:       None
*********************************************************************************************/
void    os_init (void);

/*********************************************************************************************/
/*!
 Function:      os_start()
 Description:   OS start function, normally called on boot up in main()
                This maybe a non-returning function, depending on the OS
 @param:        None
 @return:       None
*********************************************************************************************/
void    os_start (void);

/*********************************************************************************************/
/*!
 Function:      os_msleep()
 Description:   Sleep function.
 @param:        uiSleepInMs: SLEEP TIME specified in milliseconds-unit
 @return:       None
*********************************************************************************************/
void   os_msleep (uint32_t uiSleepInMs);

/*********************************************************************************************/
/*!
 Function:      os_malloc()
 Description:   HEAP memory allocator function.
 @param:        uiSize- Size of the memory block to be allocated
 @return:       PTR to allocated Memory
*********************************************************************************************/
void    *os_malloc (unsigned int uiSize);

/*********************************************************************************************/
/*!
 Function:      os_malloc_aligned()
 Description:   HEAP memory allocator function for block aligned allocations.
 @param:        uiSize- Size of the memory block to be allocated
                uiByteAlignment - Alignment address
                    4 ==> 4-byte aligned, 16 ==> 16-byte aligned, etc
 @return:       PTR to aligned allocated Memory
*********************************************************************************************/
void    *os_malloc_aligned (uint32_t uiSize, uint32_t uiByteAlignment);

/*********************************************************************************************/
/*!
 Function:      os_calloc()
 Description:   HEAP memory allocator function.
 @param:        uiSize- Size of the memory block to be allocated
 @return:       PTR to allocated and cleared Memory
*********************************************************************************************/
void    *os_calloc (uint32_t uiSize, uint32_t uiByteAlignment);

/*********************************************************************************************/
/*!
 Function:      os_create_task()
 Description:   Function to create a task
 @param:        pcTaskName      - ASCIIZ string to name the task
                pfnTaskFunction - Thread function of type "void fn(void *)"
                pvTaskArg       - Thread argument
                uiTaskPriority  - LOWER the number HIGHER the priority
                pvStack         - PTR to thread stack
                uiStackSize     - PStack size in BYTEs

 @return:       if no error, Task-Handle
                else,  INVALID_HANDLE
*********************************************************************************************/
OS_TASK_HANDLE_T  os_create_task (const char *pcTaskName,
                                  TASK_FUNC   pfnTaskFunction,
                                  void       *pvTaskArg,
                                  int32_t     iTaskPriority,
                                  void       *pvStack,
                                  uint32_t    uiStackSize);

/*********************************************************************************************/
/*!
 Function:      os_suspend_task()
 Description:   Function to suspend a task
 @param:        hThread - HANDLE to the task to be suspended

 @return:       None
*********************************************************************************************/
void    os_suspend_task (OS_TASK_HANDLE_T hTask);

/*********************************************************************************************/
/*!
 Function:      os_resume_task()
 Description:   Function to resume a suspended task
 @param:        hTask   - Task Handle

 @return:       None
*/
/* ************************************************************************** */
void    os_resume_task (OS_TASK_HANDLE_T hTask);

/*********************************************************************************************/
/*!
 Function:      os_delete_task ()
 Description:   Function to delete a task
 @param:        hTask   - Task Handle

 @return:       None
*********************************************************************************************/
void    os_delete_task (OS_TASK_HANDLE_T hTask);

/*********************************************************************************************/
/*!
 Function:      os_create_semaphore()
 Description:   Function to create a COUNTING semaphore
 @param:        pcSemaName     - ASCIIZ string to name the semaphore
                uiMaxCount     - MAX Count for the counting semaphore
                uiInitialCount - Initial count for the counting semaphore
 @return:       HANDLE to semaphore if no error
                else,  INVALID_HANDLE.
*********************************************************************************************/
OS_SEMA_HANDLE_T    os_create_semaphore (const char *pcSemaName,
                                         uint32_t    uiMaxCount,
                                         uint32_t    uiInitialCount);

/*********************************************************************************************/
/*!
 Function:      os_create_binary_semaphore()
 Description:   Function to create a BINARY semaphore
 @param:        pcSemaName - ASCIIZ string to name the semaphore
 @return:       HANDLE to semaphore if no error
                else,  INVALID_HANDLE.
*********************************************************************************************/
OS_SEMA_HANDLE_T    os_create_binary_semaphore (const char  *pcSemaName);

/*********************************************************************************************/
/*!
 Function:      os_get_semaphore ()
 Description:   Sema-Get function
 @param:        hSema           - HANDLE to the semaphore
                uiTimeoutInMs   - TIMEOUT value in millisecs
                                 == OS_SEMA_WAIT_FOREVER for blocking call

 @return:       TRUE (1) if semaphore obtained
                else FALSE (0)
*********************************************************************************************/
int32_t os_get_semaphore (OS_SEMA_HANDLE_T hSema, uint32_t uiTimeoutInMs);

/*********************************************************************************************/
/*!
 Function:      os_put_semaphore()
 Description:   Sema-Put function
 @param:        pvSema    - HANDLE_T to the semaphore
 @return:       None
*********************************************************************************************/
void    os_put_semaphore (OS_SEMA_HANDLE_T hSema);

/*********************************************************************************************/
/*!
 Function:      os_delete_semaphore()
 Description:   Sema-Delete function
 @param:        hSema    - HANDLE_T to the semaphore
 @return:       None
*********************************************************************************************/
void    os_delete_semaphore (OS_SEMA_HANDLE_T hSema);

/*********************************************************************************************/
/*!
 Function:      os_create_mutex()
 Description:   Function to create a MUTEX
 @param:        pcMutexName - ASCIIZ string to name the Mutex
 @return:       HANDLE to MUTEX object if no error
                else,  INVALID_HANDLE.
*********************************************************************************************/
OS_LOCK_HANDLE_T    os_create_mutex (const char *pcMutexName);

/*********************************************************************************************/
/*!
 Function:      os_lock_mutex ()
 Description:   Mutex-Lock function
 @param:        hMutex          - HANDLE to the Mutex

 @return:       TRUE (1) if lock obtained
                else FALSE (0)
*********************************************************************************************/
int32_t os_lock_mutex (OS_LOCK_HANDLE_T hMutex);

/*********************************************************************************************/
/*!
 Function:      os_unlock_mutex()
 Description:   Mutex-unlock function
 @param:        hMutex    - HANDLE_T to the Mutex
 @return:       None
*********************************************************************************************/
void    os_unlock_mutex (OS_LOCK_HANDLE_T hMutex);

/*********************************************************************************************/
/*!
 Function:      os_delete_mutex()
 Description:   Mutex-Delete function
 @param:        hMutex   - HANDLE_T to the mutex
 @return:       None
*********************************************************************************************/
void    os_delete_mutex (OS_LOCK_HANDLE_T hMutex);

/*********************************************************************************************/
/*!
 Function:      os_create_msgq()
 Description:   Function to create a specified message queue
 @param:        uiMsgQueueDepth - MAX message blocks to hold in the mailbox
 @param:        uiMsgUnitLength - Size of each message block

 @return:       HANDLE to message queue if successful,
                INVALID_HANDLE otherwise
*********************************************************************************************/
OS_QUEUE_HANDLE_T   os_create_msgq (uint32_t uiMsgQueueDepth,
                                    uint32_t uiMsgUnitLength);

/*********************************************************************************************/
/*!
 Function:      os_put_message()
 Description:   Message-Write function
 @param:        hMsgQueue   - HANDLE_T to the message queue
                puiMsgBlock - PTR to one message block from where the message is
                              copied at the end of the queue.
                              This shall be equal to uiMsgUnitLength used during create.
 @return:       TRUE (1) if no error
                FALSE otherwise
*********************************************************************************************/
int32_t os_put_message (OS_QUEUE_HANDLE_T hMsgQueue, void *pvMsgBlock);

/*********************************************************************************************/
/*!
 Function:      os_get_message()
 Description:   Message-Read function
 @param:        hMsgQueue   - HANDLE_T to the message queue
                puiMsgBlock - PTR to one message block where the message available
                            at the top of the queue is copied.
                            This shall be equal to uiMsgUnitLength used during create.
 @return: if no error, psMailBox Message
*********************************************************************************************/
int32_t os_get_message (OS_QUEUE_HANDLE_T hMsgQueue, void *pvMsgBlock);

/*********************************************************************************************/
/*!
 Function:      os_delete_msgq()
 Description:   Message-Read function
 @param:        hMsgQueue - HANDLE_T to the message queue
 @return:       None
*********************************************************************************************/
void    os_delete_msgq (OS_QUEUE_HANDLE_T hMsgQueue);

/*********************************************************************************************/
/*!
 Function:      os_create_periodic_timer ()
 Description:   Function to create a PERIODIC Timer for the specified TIMEOUT
 @param:        pcTimerName   - Name given to the timer
                uiTimeoutInMs - TIMEOUT value in milliseconds for the periodic timer
                pfnCallback   - Callback function pointer
                pvCallbackArg - Callback function argument

 @return:       Timer-HANDLE if no error
*********************************************************************************************/
OS_TIMER_HANDLE_T   os_create_periodic_timer (const char    *pcTimerName,
                                              uint32_t       uiTimeoutInMs,
                                              TIMER_CALLBACK pfnCallback,
                                              void          *pvCallbackArg);

/*********************************************************************************************/
/*!
 Function:      os_create_oneshot_timer ()
 Description:   Function to create a ONESHOT Timer for the specified TIMEOUT
 @param:        pcTimerName   - Name given to the timer
                uiTimeoutInMs - TIMEOUT value in milliseconds for the periodic timer
                pfnCallback   - Callback function pointer
                pvCallbackArg - Callback function argument

 @return:       Timer-HANDLE if no error
*********************************************************************************************/
OS_TIMER_HANDLE_T   os_create_oneshot_timer (const char    *pcTimerName,
                                             uint32_t       uiTimeoutInMs,
                                             TIMER_CALLBACK pfnCallback,
                                             void          *pvCallbackArg);

/*********************************************************************************************/
/*!
 Function:      os_start_timer ()
 Description:   STARTs a specified timer.
 @param:        hTimer - HANDLE_T to the TIMER to be started

 @return:       TRUE (1) if successful
                FALSE (0) otherwise
*********************************************************************************************/
int32_t os_start_timer (OS_TIMER_HANDLE_T hTimer);

/*********************************************************************************************/
/*!
 Function:      os_stop_timer ()
 Description:   STOPs a specified timer.
 @param:        hTimer - HANDLE_T to the TIMER to be stopped

 @return:       TRUE (1) if successful
                FALSE (0) otherwise
*********************************************************************************************/
int32_t os_stop_timer (OS_TIMER_HANDLE_T hTimer);

/*********************************************************************************************/
/*!
 Function:      os_delete_timer ()
 Description:   DELETEs a specified timer.
 @param:        hTimer - HANDLE_T to the TIMER to be stopped

 @return:       TRUE (1) if successful
                FALSE (0) otherwise
*********************************************************************************************/
int32_t os_delete_timer (OS_TIMER_HANDLE_T hTimer);

/*********************************************************************************************/
/*!
 Function:      os_enter_critical_section()
 Description:   Gets the current MASK, disables interrupts and returns the
                Mask for saving by the caller.
 @param:        None
 @return:       Current INT Mask
*********************************************************************************************/
void    os_enter_critical_section (uint32_t *puiCurMask);

/*********************************************************************************************/
/*!
 Function:      os_exit_critical_section()
 Description:   Gets the saved MASK from the application and applies it.
 @param:        uint32_t uiSavedIntMask
 @return:       None
*********************************************************************************************/
void    os_exit_critical_section (uint32_t *puiCurMask);

/**********************************************************************************************
 *********************************************************************************************/
#endif  /* __OTC_OSAL_H__ */
/**********************************************************************************************
 *************************************** END OF FILE *****************************************/

