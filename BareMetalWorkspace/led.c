/*
 * led.c
 *
 *  Created on: Jan 18, 2024
 *      Author: wyatt
 */

#include <stdint.h>
#include "led.h"


// Software based delay
void delay(uint32_t count){
	for(uint32_t i=0; i<count; i++);
}


void led_init_all_(void){


	// Reset and Clock Control is what Enables the Advanced High-Performance Bus 1
	// RCC Base Address: 0x4002 3800
	// RCC_AHB1ENR Register is Offset by 0x30 so
	// RCC_AHB1ENR Base Address is 0x4002 3830
	uint32_t *pRCC_AHB1ENR = (uint32_t*)0x40023830;

	// GPIO Port B Mode Register base Address: 0x4002 0400 with a 0x00 Offset
	uint32_t *pGpioBModeReg = (uint32_t*)0x40020400;

	// Set bit 1 High to enable GPIO Port B Clock
	*pRCC_AHB1ENR |= (1 << 1);

	// Configure Each Pin and there Mode Output is 0x01 for General Purpose Output Mode
	*pGpioBModeReg |= (1 << (2 * LED_GREEN1)); // PB_3
	*pGpioBModeReg |= (1 << (2 * LED_RED1)); // PB_5
	*pGpioBModeReg |= (1 << (2 * LED_GREEN2)); // PB_4
	*pGpioBModeReg |= (1 << (2 * LED_RED2)); // PB_10


	// Don't think I need this
	#if 0
		//configure the outputtype
		*pGpioOpTypeReg |= ( 1 << (2 * LED_GREEN1));
		*pGpioOpTypeReg |= ( 1 << (2 * LED_RED1));
		*pGpioOpTypeReg |= ( 1 << (2 * LED_GREEN2));
		*pGpioOpTypeReg |= ( 1 << (2 * LED_RED2));
	#endif

	led_off(LED_GREEN1);
	led_off(LED_RED1);
	led_off(LED_GREEN2);
	led_off(LED_RED2);

}


void led_on(uint8_t led_num){

	// Update the Output Data Register for GPIO Port A
	// GPIOB_ODR: 0x4002 0400 + 0x14 =  0x4002 0414
	uint32_t *pGPIOA_ODR = (uint32_t*)0x40020414;
	*pGPIOA_ODR |= (1 << led_num);
}


void led_off(uint8_t led_num){

	uint32_t *pGPIOA_ODR = (uint32_t*)0x40020414;
	*pGPIOA_ODR &= ~(1 << led_num);

}




