/**
 ******************************************************************************
 * @file           : main.c
 * @author         : Auto-generated by STM32CubeIDE
 * @brief          : Main program body
 ******************************************************************************
 * @attention
 *
 * Copyright (c) 2024 STMicroelectronics.
 * All rights reserved.
 *
 * This software is licensed under terms that can be found in the LICENSE file
 * in the root directory of this software component.
 * If no LICENSE file comes with this software, it is provided AS-IS.
 *
 ******************************************************************************
 */

#include <stdint.h>
#include <stdio.h>
#include "main.h"
#include "led.h"

#if !defined(__SOFT_FP__) && defined(__ARM_FP)
  #warning "FPU is not initialized, but the project is compiling for an FPU. Please initialize the FPU before use."
#endif

/*
 * Create 4 Tasks that are Scheduled in a Round Robin
 * Using the Systick handler / PendSV Handler as the Scheduler.
 * Using 2 Stack Pointers: PSP in Thread Mode for the Tasks, and MSP in Handler Mode for the Scheduler
 * The Scheduler and Each Task will have its own Private Stack on the SRAM
 * Remember that on ARM Cortex-M Processor the Stack utilizes the Full Descending Method
 *
 * During the Context Switches Triggered by the Systick Timer every 1ms:
 * 	The Processor already pushes Registers 0-3, 12, LR, PC, and PSR
 * 	We just have to:
 * 		push R4-R11 (for its context) and the Stack Pointer
 * 		Switch the Stack Pointer
 * 		Pop R4-R11 for the new context
 *
 * Systick Timer Count Value Calculations:
 * 	HSI Processor Clock of STM32F446RE = 16MHz
 * 	Systick timer count clock = 16MHz
 * 	1ms is 1KHz in Frequency Domain
 * 	Using a Divisor (Reload Value) of 16,000 gets us to 1KHz
 */



// Prototype of Task Handlers
void task1_handler(void);
void task2_handler(void);
void task3_handler(void);
void task4_handler(void);


void init_systick_timer(uint32_t tick_hz);
__attribute__((naked)) void init_scheduler_stack(uint32_t scheduler_top_of_stack);
void init_tasks_stack(void);

void enable_processor_faults(void);
__attribute__ ((naked)) void switch_sp_to_psp(void);

void save_psp_value(uint32_t current_psp_value);
void update_next_task(void);

void task_delay(uint32_t tick_count);
void update_global_tick_count(void);

// Global Variables
uint8_t current_task = 1; // 0 means Idle Task is running
uint32_t global_tick_count = 0;

// Task Control Block
typedef struct{
	uint32_t psp_value;
	uint32_t block_count;
	uint8_t current_state;
	void (*task_handler)(void);
}TCB_t;

TCB_t user_tasks[MAX_TASKS];


int main(void)
{

	enable_processor_faults();

	init_scheduler_stack(SCHEDULER_STACK_START);

	init_tasks_stack();

	led_init_all_();

	init_systick_timer(TICK_HZ);

	// Tasks Should use PSP
	switch_sp_to_psp();

	task1_handler();

	// Should never get here
    /* Loop forever */
	for(;;);
}


void idle_task(void){
	while(1){

	}
}

void task1_handler(void){

	while(1){
//		printf("Task1\n");
		led_on(LED_GREEN1);
		task_delay(1000);
		led_off(LED_GREEN1);
		task_delay(1000);
	}
}


void task2_handler(void){

	while(1){
//		printf("Task2\n");
		led_on(LED_RED1);
		task_delay(500);
		led_off(LED_RED1);
		task_delay(500);
	}
}


void task3_handler(void){

	while(1){
//		printf("Task3\n");
		led_on(LED_GREEN2);
		task_delay(250);
		led_off(LED_GREEN2);
		task_delay(250);
	}
}


void task4_handler(void){

	while(1){
//		printf("Task4\n");
		led_on(LED_RED2);
		task_delay(125);
		led_off(LED_RED2);
		task_delay(125);
	}
}



void init_systick_timer(uint32_t tick_hz){

	// Count Value Calculation
	uint32_t *pSRVR = (uint32_t*)0xE000E014; // SysTick Reload Value Register
	uint32_t count_value = (SYSTICK_TIMER_CLOCK / tick_hz) - 1;
	*pSRVR &= ~(0x00FFFFFFFF); // Clear the Register, only 24 bits are used
	*pSRVR |= count_value; // Load the Desired Reload Value

	// Configuration
	uint32_t *pSCSR = (uint32_t*)0xE000E010; // SysTick Control and Status Register
	*pSCSR |= (1 << 1); // Enable SysTick Exception Request
	*pSCSR |= (1 << 2); // Use Processor Clock as Source
	*pSCSR |= (1 << 0); // Enables the Counter
}


// To change the Stack Pointer it has to be done in Assembly
__attribute__((naked)) void init_scheduler_stack(uint32_t scheduler_top_of_stack){

	// Changes MSP to scheduler_top_of_stack
	__asm volatile("MSR MSP,%0":: "r"(scheduler_top_of_stack): );
	__asm volatile("BX LR"); // Returns back to main

}



// Initialize each Task with 2 Stack Frames and Dummy Variables
void init_tasks_stack(void){

	// Initialize all tasks to start off running
	for(int i=0; i<MAX_TASKS; i++){
		user_tasks[i].current_state = TASK_READY_STATE;
	}

	user_tasks[0].psp_value = IDLE_STACK_START;
	user_tasks[1].psp_value = T1_STACK_START;
	user_tasks[2].psp_value = T2_STACK_START;
	user_tasks[3].psp_value = T3_STACK_START;
	user_tasks[4].psp_value = T4_STACK_START;

	user_tasks[0].task_handler = idle_task;
	user_tasks[1].task_handler = task1_handler;
	user_tasks[2].task_handler = task2_handler;
	user_tasks[3].task_handler = task3_handler;
	user_tasks[4].task_handler = task4_handler;



	uint32_t *pPSP; // Pointer used to access the Stack

	for(int i=0; i<MAX_TASKS; i++){
		pPSP = (uint32_t*) user_tasks[i].psp_value;

		// Stack is Full Descending
		pPSP--; // Store XPSR
		*pPSP = DUMMY_XPSR; // Should be 0x01000000
		pPSP--; // Store PC
		*pPSP = (uint32_t) user_tasks[i].task_handler;
		pPSP--; // Store LR
		*pPSP = 0xFFFFFFFD;
		// Store 0 in each of the Registers
		for(int j=0; j<13; j++){
			pPSP--;
			*pPSP = 0;
		}

		user_tasks[i].psp_value = (uint32_t)pPSP;

	}

}


void enable_processor_faults(void){
	// Enable all configurable exceptions like Usage, Memory Management, and Bus Faults

	uint32_t *pSHCSR = (uint32_t*)0xE000ED24; // Address for System Handler Control and State Register
	*pSHCSR |= (1 << 18); // Enable Usage Fault bit 18
	*pSHCSR |= (1 << 17); // Enable Bus Fault bit 17
	*pSHCSR |= (1 << 16); // Enable Memory Management Fault bit 16
}


uint32_t get_psp_value(void){
	return user_tasks[current_task].psp_value;
}


// CONTROL is a Special register so have to use MSR and naked attribute
__attribute__ ((naked)) void switch_sp_to_psp(void){

	// 1. Initialize the PSP with TASK1 stack start address
	__asm volatile("PUSH {LR}"); // Save LR so we can return to main() after the BL
	__asm volatile("BL get_psp_value"); // Use BL so it returns to this function afterwards and Returns value in R0
	__asm volatile("MSR PSP,R0");
	__asm volatile("POP {LR}"); // So we can return back to main()

	// 2. change SP to PSP using CONTROL register
	// Set SPSEL (the second bit) of the control register to 1 to select PSP
	__asm volatile("MOV R0,#0x02");
	__asm volatile("MSR CONTROL,R0");

	__asm volatile("BX LR"); // Branch back to main

}


void save_psp_value(uint32_t current_psp_value){
	user_tasks[current_task].psp_value = current_psp_value;
}

void update_next_task(void){
	// Round Robin

	int state = TASK_BLOCKED_STATE;

	for(int i=0; i<MAX_TASKS; i++){
		current_task++;
		current_task %= MAX_TASKS;
		state = user_tasks[current_task].current_state;
		if( (state == TASK_READY_STATE) && (current_task != 0) ){
			break;
		}
	}

	// If all tasks are blocked
	if(state != TASK_READY_STATE){
		current_task = 0;
	}

}


void schedule(void){
	uint32_t *pICSR = (uint32_t*)0xE000ED04; // Interrupt Control and State Register
	*pICSR |= (1 << 28); // Pend the PendSV Exception
}


void task_delay(uint32_t tick_count){

	// Disable Interrupt so there is no race condition on user_tasks between Thread mode and Handler modes
	INTERRUPT_DISABLE();

	// Only block the User Tasks
	if(current_task){
		user_tasks[current_task].block_count = global_tick_count + tick_count;
		user_tasks[current_task].current_state = TASK_BLOCKED_STATE;
		schedule();
	}

	INTERRUPT_ENABLE();

}


// Used to do Context Switches
__attribute__((naked)) void PendSV_Handler(void){

	/* Save the Context of Current Task */

	// 1. Get current running task's PSP value
	__asm volatile("MRS R0,PSP");

	// 2. using that PSP value store SF2 (R4-R11)
	// Can't use PUSH here since PUSH uses MSP and we are using PSP
	// STMDB: Store Multiple Registers, Decrement Before
	// ! updates R0 with the last value stored
	__asm volatile("STMDB R0!,{R4-R11}");

	// 3. Save the current value of PSP (R0)
	// Update the value for the appropriate psp_of_tasks
	__asm volatile("PUSH {LR}"); // Save LR Value
	__asm volatile("BL save_psp_value");


	/* Retrieve the Context of Next Task */


	// 1. Decide Next Task to Run
	__asm volatile("BL update_next_task");

	// 2. Get its past PSP value
	__asm volatile("BL get_psp_value");

	// 3. Using that PSP value Retrieve SF2 (R4-R11)
	// Load from Memory to Registers
	__asm volatile("LDMIA R0!,{R4-R11}"); // Load Multiple Registers, Increment After

	// 4. Update PSP and Exit
	__asm volatile("MSR PSP,R0");
	__asm volatile("POP {LR}");
	__asm volatile("BX LR");

}


void update_global_tick_count(){
	global_tick_count++;
}


void unblock_tasks(void){
	// This function checks each task and conditionally unblocks if its tick count is hit
	for(int i=1; i<MAX_TASKS; i++){
		if(user_tasks[i].current_state != TASK_READY_STATE){
			if(user_tasks[i].block_count == global_tick_count){
				user_tasks[i].current_state = TASK_READY_STATE;
			}
		}
	}

}


void SysTick_Handler(void){

	uint32_t *pICSR = (uint32_t*)0xE000ED04; // Interrupt Control and State Register

	update_global_tick_count();
	unblock_tasks();
	// pend the PendSV Exception
	*pICSR |= (1 << 28);

}


void HardFault_Handler(void){
	printf("Exception: HardFault\n");
	while(1);
}


void UsageFault_Handler_(void){

	printf("Exception: UsageFault\n");

	// Check the Usage Fault State Register
	uint32_t *pUSFR = (uint32_t*)0xE000ED2A;
	printf("UFSR: %lx\n", (*pUSFR) & 0xFFFF); // The USFR is 16bits wide

	while(1);
}


void MemManage_Handler(void){
	printf("Exception: MemMangeFault\n");
	while(1);
}


void BusFault_Handler(void){
	printf("Exception: BusFault\n");
	while(1);
}



