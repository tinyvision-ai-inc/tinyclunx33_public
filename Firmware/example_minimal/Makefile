BUILD_DIR = ../../RTL/litex/build/som

include $(BUILD_DIR)/software/include/generated/variables.mak
include $(SOC_DIRECTORY)/software/common.mak

OBJECTS = crt0.o main.o isr.o
CFLAGS += -DI2C_INIT -DI2C_INIT_CNT=1

all: firmware.bin

firmware.elf: $(OBJECTS)
	$(CC) $(LDFLAGS) -T linker.ld -N -o $@ $(OBJECTS) \
		$(PACKAGES:%=-L$(BUILD_DIR)/software/%) \
		$(LIBS:lib%=-l%)

-include $(OBJECTS:.o=.d)

crt0.o: $(CPU_DIRECTORY)/crt0.S
	$(assemble)

%.o: %.c
	$(compile)

%.o: %.S
	$(assemble)

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

clean:
	$(RM) *.o *.d *.elf *.bin *.map
