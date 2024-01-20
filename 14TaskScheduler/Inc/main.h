/*
 * main.h
 *
 *  Created on: Jan 16, 2024
 *      Author: wyatt
 */

#ifndef MAIN_H_
#define MAIN_H_


// MACROS

// 4 User Tasks + 1 Idle Task
#define MAX_TASKS				5
#define DUMMY_XPSR				0x01000000U

// Stack Memory Calculations for 1kb each
#define SIZE_TASK_STACK			1024U
#define SIZE_SCHEDULER_STACK	1024U

#define SRAM_START				0x20000000U
#define SIZE_SRAM				((128) * (1024))
#define SRAM_END				((SRAM_START) + (SIZE_SRAM))

#define T1_STACK_START			SRAM_END
#define T2_STACK_START			((T1_STACK_START) - (SIZE_TASK_STACK))
#define T3_STACK_START			((T2_STACK_START) - (SIZE_TASK_STACK))
#define T4_STACK_START			((T3_STACK_START) - (SIZE_TASK_STACK))
#define IDLE_STACK_START		((T4_STACK_START) - (SIZE_TASK_STACK))
#define SCHEDULER_STACK_START	((IDLE_STACK_START) - (SIZE_SCHEDULER_STACK))

#define TICK_HZ					1000U
#define HSI_CLOCK				16000000U
#define SYSTICK_TIMER_CLOCK		HSI_CLOCK

#define TASK_READY_STATE 0x00
#define TASK_BLOCKED_STATE 0xFF

// Interrupt Disable using the Priority Mask Register
#define INTERRUPT_DISABLE() do{__asm volatile ("MOV R0,#0x01"); __asm volatile ("MSR PRIMASK,R0");}while(0)
#define INTERRUPT_ENABLE() do{__asm volatile ("MOV R0,#0x00"); __asm volatile ("MSR PRIMASK,R0");}while(0)




#endif /* MAIN_H_ */
