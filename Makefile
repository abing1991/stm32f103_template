# Define the applications properties here:

APP_NAME = main
DEBUG = 1

CROSS_COMPILE = arm-none-eabi-

CPP       = $(CROSS_COMPILE)g++
CC        = $(CROSS_COMPILE)gcc
LD        = $(CROSS_COMPILE)gcc
OBJCOPY   = $(CROSS_COMPILE)objcopy
SIZE      = $(CROSS_COMPILE)size

SOURCE    = src

BIN  	  = bin

INCLUDEPATH += -I./inc
INCLUDEPATH += -I./Libraries/STM32F10x_StdPeriph_Driver/inc
INCLUDEPATH += -I./Libraries/CMSIS/CM3/CoreSupport
INCLUDEPATH += -I./Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x

COMMONFLAGS = -mcpu=cortex-m3 -mthumb -mlittle-endian
COMMONFLAGS += -msoft-float
CFLAGS    = $(COMMONFLAGS)
CFLAGS    += -ggdb3 $(INCLUDEPATH) -c
ifeq ($(DEBUG),1)
CFLAGS    += -O0
#CFLAGS    += -Og # optimized debugging
else
CFLAGS    += -Os 
endif
CFLAGS    += -Wall -Wextra
CFLAGS    += -finline-functions -fomit-frame-pointer
CFLAGS    += -fno-builtin -fno-exceptions
CLFAGS    += -nostdlib
CFLAGS    += -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -ffreestanding -fno-move-loop-invariants
ifeq ($(DEBUG),0)
CFLAGS    += -flto
endif
CFLAGS    += -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER -DHSE_VALUE=8000000UL -DSYSCLK_FREQ_72MHz=72000000
ifeq ($(DEBUG),1)
CFLAGS    += -D_DEBUG -DUSE_FULL_ASSERT
endif
CFLAGS_A  = $(CFLAGS) -D_ASSEMBLER_
CXXFLAGS  = $(CFLAGS)

#LIB_PATH  = ./lib
LDLIBS    = -lm

LDFLAGS   = $(COMMONFLAGS) -T ./stm32_flash.ld -Wl,--gc-sections
LDFLAGS   += -specs=nano.specs
#LDFLAGS   += -u _printf_float
#LDFLAGS   += -specs=nosys.specs
#LDFLAGS   += -L$(LIB_PATH)
LDFLAGS   += $(LDLIBS) 



# Find all source files

#SRC_CPP = $(foreach dir, $(SOURCE), $(wildcard $(dir)/*.cpp))
SRC_C   = $(foreach dir, $(SOURCE), $(wildcard $(dir)/*.c))
#SRC_S   = $(foreach dir, $(SOURCE), $(wildcard $(dir)/*.s))

SRC_C +=  ./Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/system_stm32f10x.c
SRC_C +=  ./Libraries/CMSIS/CM3/CoreSupport/core_cm3.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_sdio.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_i2c.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_wwdg.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_iwdg.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_crc.c
SRC_C +=  ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_rcc.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_exti.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_flash.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_fsmc.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_rtc.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_tim.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_dma.c
SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_usart.c
SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_gpio.c
SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/misc.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_dbgmcu.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_spi.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_can.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_cec.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_adc.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_pwr.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_dac.c
#SRC_C += ./Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_bkp.c
# SRC_C += ./src/stm32f10x_it.c
# SRC_C += ./src/main.c
# SRC_C += ./src/syscalls.c
SRC_S =  ./Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_md.s
OBJ_CPP = $(patsubst %.cpp, %.o, $(SRC_CPP))
OBJ_C   = $(patsubst %.c, %.o, $(SRC_C))
OBJ_S   = $(patsubst %.s, %.o, $(SRC_S))
OBJ     = $(OBJ_CPP) $(OBJ_C) $(OBJ_S)
DEP     = $(patsubst %.o, %.d, $(OBJ))
BMP     = $(foreach dir, $(SOURCE), $(wildcard $(dir)/gfx/*.bmp))
#TGA     = $(patsubst %.bmp, %.tga, $(BMP))

# Compile rules.

.PHONY : all

all : $(APP_NAME).elf


$(APP_NAME).elf : $(OBJ)
	$(LD) $(OBJ) $(LDFLAGS) -o $(BIN)/$(APP_NAME).elf
	$(OBJCOPY) -O ihex $(BIN)/$(APP_NAME).elf $(BIN)/$(APP_NAME).hex
	$(OBJCOPY) -O binary $(BIN)/$(APP_NAME).elf $(BIN)/$(APP_NAME).bin
	$(SIZE) $(BIN)/$@
	arm-none-eabi-readelf -a  $(BIN)/$(APP_NAME).elf >  $(BIN)/$(APP_NAME).info_elf
	arm-none-eabi-size -d -B -t  $(BIN)/$(APP_NAME).elf >  $(BIN)/$(APP_NAME).info_size
	arm-none-eabi-objdump -S  $(BIN)/$(APP_NAME).elf >  $(BIN)/$(APP_NAME).info_code
	arm-none-eabi-nm -t d -S --size-sort -s  $(BIN)/$(APP_NAME).elf >  $(BIN)/$(APP_NAME).info_symbol

#$(OBJ_CPP) : %.o : %.cpp
%.o : %.cpp
	$(CPP) $(CXXFLAGS) -o $@ $<
	$(CPP) -MM $(CXXFLAGS) $*.cpp > $*.d

#$(OBJ_C) : %.o : %.c
%.o : %.c
	$(CC) $(CFLAGS) -o $@ $<
	$(CC) -MM $(CFLAGS) $*.c > $*.d

#$(OBJ_S) : %.o : %.s
%.o : %.s
	$(CC) $(CFLAGS_A) -o $@ $<
	$(CC) -MM $(CFLAGS_A) $*.s > $*.d

$(TGA) : %.tga : %.bmp
	convert $< $@

.PHONY : flash

flash :
	st-link_cli -p $(BIN)/$(APP_NAME).hex

# Clean rules

.PHONY : clean

clean :
	rm -f $(OBJ) $(DEP) $(BIN)/*



.PHONY: tags
tags:
	ctags -R .

DIST_NAME = stm32f103c8_v100
DIR = stm32f103c8

.PHONY: dist predist postdist
dist:	predist $(DIST_NAME).tar.gz $(DIST_NAME).zip postdist

predist: $(APP_NAME).app $(TGA)
	mkdir $(DIR)/
	cp -r $(INSTALL_FILES) $(DIR)/

postdist:
	rm -rf $(DIR)/

$(DIST_NAME).tar.gz: $(DIR)/

$(DIST_NAME).zip: $(DIR)/

%.tar.gz:
	tar -cvzf $@ $^

%.zip:
	zip -r $@ $^

