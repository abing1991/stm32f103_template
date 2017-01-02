#include "LED.h"

LED::LED(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin){
	init(GPIOx, GPIO_Pin);
}

void LED::init(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin){

	GPIO_InitTypeDef  GPIO_InitStructure;
  
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);   
     
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin;        
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;  
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz; 
    GPIO_Init(GPIOx, &GPIO_InitStructure);     
    //GPIO_SetBits(GPIOx,GPIO_Pin);  
    Pin = GPIO_Pin;
    GPIO = GPIOx;
    state = 0;
}

void LED::ON  (void){
	  GPIO->BSRR = Pin;
}
void LED::OFF (void){
	  GPIO->BRR = Pin;
}