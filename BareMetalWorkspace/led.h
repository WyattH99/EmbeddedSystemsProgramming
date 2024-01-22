/*
 * led.h
 *
 *  Created on: Jan 18, 2024
 *      Author: wyatt
 */

#ifndef LED_H_
#define LED_H_

// Ports
#define LED_GREEN1	10
#define LED_RED1	6
#define LED_GREEN2	9
#define LED_RED2	8

// Delays - 1250 is
#define DELAY_COUNT_1MS			1250U
#define DELAY_COUNT_1S			(1000U * DELAY_COUNT_1MS)
#define DELAY_COUNT_500MS		(500U * DELAY_COUNT_1MS)
#define DELAY_COUNT_250MS		(250U * DELAY_COUNT_1MS)
#define DELAY_COUNT_125MS		(125U * DELAY_COUNT_1MS)

// Prototypes
void led_init_all_(void);
void led_on(uint8_t led_no);
void led_off(uint8_t led_off);
void delay(uint32_t count);


#endif /* LED_H_ */
