#ifndef _LED_H
#define _LED_H
#include "stm32f10x.h"
class LED{
public :
	LED(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin);
	void init(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin);
	void ON();
	void OFF();
private :
	uint8_t state;
	uint16_t Pin;
	GPIO_TypeDef* GPIO;
};

#endif