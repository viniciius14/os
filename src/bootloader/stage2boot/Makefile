include $(CONFIG_PATH)

SRCS := $(filter-out stage2_16.S, $(wildcard *.S))
OBJS := $(patsubst %.S, $(OBJ)/%.o, $(SRCS))

STAGE2_16_SIZE = $(shell stat --format=%s $(BIN)/stage2_16.bin)
START_ADDRESS = 0x$(shell echo "obase=16; $(STAGE2_16_SIZE) + 32256" | bc)

default: echo extract


echo:
	@echo "\nStage 2 Bootloader\n"

extract: link
	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ)/stage2.elf $(BIN)/_stage2.bin
	cat $(BIN)/stage2_16.bin $(BIN)/_stage2.bin > $(BIN)/stage2.bin


link: 16bit $(OBJS) driver
	@echo "Computed START_ADDRESS: $(START_ADDRESS)"
	sed "s/START_ADDRESS/$(START_ADDRESS)/" _stage2.ld > stage2.ld
	$(LD) $(LD_FLAGS) -T stage2.ld $(OBJS) $(DRIVER_OBJS) -o $(OBJ)/stage2.elf


16bit:
	$(ASM) -f bin $(BOOT_INCLUDES) -D$(FS) -D$(BITS) stage2_16.S -o $(BIN)/stage2_16.bin


$(OBJ)/%.o: %.S
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) -D$(FS) -D$(BITS) $(BOOT_INCLUDES) $< -o $@


driver:
ifeq ($(FS), FAT12)
DRIVER_OBJS=$(KERNEL_OBJ)/fdc.o $(KERNEL_OBJ)/io.o $(KERNEL_OBJ)/memory.o
else
	@echo "\nWARNING: Unsupported FS: $(FS).\n"
DRIVER_OBJS=
endif

.PHONY: default
