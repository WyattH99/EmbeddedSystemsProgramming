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

#if !defined(__SOFT_FP__) && defined(__ARM_FP)
  #warning "FPU is not initialized, but the project is compiling for an FPU. Please initialize the FPU before use."
#endif

// MACROS
#define USART3_IRQNO 39

int main(void)
{

	// 1. Manually pend the pending bit for the USART3 IRQ number in NVIC
	// 0XE000E200 is the Address of the first 32 bit register for the Interrupt Set-Pending Registers
	// Add 4 to go the the second register because the 39 bit is in the second register
	// 0XE000E204 is the correct register
	uint32_t *pISPR1 = (uint32_t*)0XE000E204;

	*pISPR1 |= (1 << (USART3_IRQNO % 32));


	// 2. Enable the USART3 IRQ number in NVIC
	// 0xE000E100 is the address first Interrupt Set-enable Registers
	// Add 4 to get to the next register
	uint32_t *pISER1 = (uint32_t*)0xE000E104;

	*pISER1 |= (1 << (USART3_IRQNO % 32));

    /* Loop forever */
	for(;;);
}


// Implement the ISR for USART3
void USART3_IRQHandler(void){
	printf("In USART3 ISR\n");
}






