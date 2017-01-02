#include "serial.h"

Serial::Serial(){
}

void Serial::begin(long baud){
	GPIO_InitTypeDef  GPIO_InitStruct;
    USART_InitTypeDef USART_InitStructure;
    NVIC_InitTypeDef NVIC_InitStructure;

    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);

    GPIO_InitStruct.GPIO_Pin   = GPIO_Pin_9;
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_InitStruct.GPIO_Mode  = GPIO_Mode_AF_PP;
    GPIO_Init(GPIOA, &GPIO_InitStruct);

    GPIO_InitStruct.GPIO_Pin  = GPIO_Pin_10;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IN_FLOATING;
    GPIO_Init(GPIOA, &GPIO_InitStruct);
     
  	NVIC_InitStructure.NVIC_IRQChannel 					 = USART1_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 3;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority 		 = 3;		
	NVIC_InitStructure.NVIC_IRQChannelCmd 				 = ENABLE;			
	NVIC_Init(&NVIC_InitStructure);	

    USART_DeInit(USART1);
    USART_InitStructure.USART_BaudRate            = baud;
    USART_InitStructure.USART_WordLength          = USART_WordLength_8b;
    USART_InitStructure.USART_StopBits            = USART_StopBits_1;
    USART_InitStructure.USART_Parity              = USART_Parity_No;
    USART_InitStructure.USART_Mode                = USART_Mode_Rx | USART_Mode_Tx;
    USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
    USART_Init(USART1, &USART_InitStructure);
    USART_ITConfig(USART1, USART_IT_RXNE, ENABLE);

    USART_Cmd(USART1, ENABLE);
}
int Serial::available(void){
  return (uint16_t)(RX_BUFFER_SIZE + rx_buffer.head - rx_buffer.tail) % RX_BUFFER_SIZE;
}

uint8_t Serial::read(void){
	if (rx_buffer.head == rx_buffer.tail) {
    	return 0;
  	} else {
    	uint8_t c = rx_buffer.buffer[rx_buffer.tail];
    	rx_buffer.tail = (uint16_t)(rx_buffer.tail + 1) % RX_BUFFER_SIZE;
    	return c;
  	}
}

void Serial::store_char(uint8_t c)
{
  uint16_t i = (uint16_t)(rx_buffer.head + 1) % RX_BUFFER_SIZE;

  if (i != rx_buffer.tail) {
    rx_buffer.buffer[rx_buffer.head] = c;
    rx_buffer.head = i;
  }
}

Serial serial;


extern "C" {
void USART1_IRQHandler(void)                	
{
	if(USART_GetITStatus(USART1, USART_IT_RXNE) != RESET){
		uint8_t res = USART_ReceiveData(USART1);	
		serial.store_char(res);		 
    } 
}
}
