#ifndef _SERIAL_H
#define _SERIAL_H

#include "stm32f10x.h"

#define RX_BUFFER_SIZE 128

//void USART1_IRQHandler(void);  
struct ring_buffer
{
  uint8_t buffer[RX_BUFFER_SIZE];
  uint16_t head;
  uint16_t tail;
  ring_buffer(void){
  	head = 0;
  	tail = 0;
  	buffer[RX_BUFFER_SIZE] = {0};
  }
};

class Serial{
private :
	ring_buffer rx_buffer;
public :
	Serial();
	void begin(long baud);
	void end(void);
	uint8_t read(void);
	int available(void);
  inline void write(char c){
  	while((USART1->SR & 0X40) == 0); 
  	USART1->DR = (uint8_t)c; 
  }
  inline void write(char *s){
    while(*s){
      write(*s++);
    }
  }
  void store_char(uint8_t c);

};
extern Serial serial;

#endif