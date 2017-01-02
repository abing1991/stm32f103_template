#include "serial.h"
#include "LED.h"

int main(void)
{          
    LED led1(GPIOB, GPIO_Pin_15);
    LED led2(GPIOB, GPIO_Pin_14);
	serial.begin(115200);
	serial.write("Hello World!\n");
    while (1)
    {
        led1.ON();
        led2.OFF();
    	//GPIO_SetBits(GPIOB, GPIO_Pin_15);
    	for (uint32_t i = 0; i < 0x1fffff; i++){}
        led1.OFF();
        led2.ON();
    	//GPIO_ResetBits(GPIOB, GPIO_Pin_15);
    	for (uint32_t i = 0; i < 0x1fffff; i++){}
		if(serial.available()){
			serial.write(serial.read());
		}
    }
}