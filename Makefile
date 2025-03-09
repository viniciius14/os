# Root Makefile
include misc/config.mk

# Define the path to config.mk
export CONFIG_PATH := $(PWD)/misc/config.mk

# Find all subdirectories in src/ that contain a Makefile
SUBDIRS := $(shell find $(SRC_DIR) -type f -name Makefile -exec dirname {} \;)

# Default target
all: $(SUBDIRS) boot_img

# Rule to iterate through each subdirectory and call its Makefile
$(SUBDIRS):
	mkdir -p $(BIN)
	mkdir -p $(OBJ)
	$(MAKE) -C $@

# Targets
FAT_12=$(BUILD)/GeckOS_FAT12.img
FAT_16=$(BUILD)/GeckOS_FAT16.img
FAT_32=$(BUILD)/GeckOS_FAT32.img

boot_img: FAT_12 FAT_16 FAT_32

FAT_12:
	@echo "\nFAT_12\n"
	dd if=/dev/zero 				of=$(FAT_12) 	bs=512 			count=2880
	mkfs.fat $(FAT_12) -F 12 -a -S 512 -s 1 -r 224 -R 1
	dd if=$(BIN)/boot_FAT12.bin		of=$(FAT_12) 	bs=512 	seek=0 	conv=notrunc
	mcopy -i $(FAT_12) $(BIN)/boot2.bin ::
	mcopy -i $(FAT_12) $(OS_FILES)/test.txt ::


FAT_16:
	@echo "\nFAT_16\n"
	dd if=/dev/zero 				of=$(FAT_16)	bs=512 			count=273042
	mkfs.fat $(FAT_16) -F 16 -a -S 512 -s 8 -r 512 -R 4
	cat $(BIN)/boot_FAT16.bin $(BIN)/boot2.bin > $(BIN)/bootloader_FAT16.bin
	dd if=$(BIN)/bootloader_FAT16.bin		of=$(FAT_16) 	bs=512 	seek=0 	conv=notrunc
	mcopy -i $(FAT_16) $(OS_FILES)/test.txt ::

FAT_32:
	@echo "\nFAT_32\n"
	dd if=/dev/zero 				of=$(FAT_32) 	bs=512 			count=273042
	mkfs.fat $(FAT_32) -F 32 -a -S 512 -s 4 -R 32
	dd if=$(BIN)/boot_FAT32.bin		of=$(FAT_32) 	bs=512	seek=0	conv=notrunc
# Add file system information structure
	dd if=$(BIN)/FSInfo_FAT32.bin 	of=$(FAT_32) 	bs=512 	seek=1	conv=notrunc
# Add copy of bootsector
	dd if=$(BIN)/boot_FAT32.bin		of=$(FAT_32) 	bs=512 	seek=6	conv=notrunc
# Add copy of system information structure
	dd if=$(BIN)/FSInfo_FAT32.bin 	of=$(FAT_32) 	bs=512 	seek=7	conv=notrunc
# Add stage 2 bootloader
	dd if=$(BIN)/boot2.bin 			of=$(FAT_32) 	bs=512 	seek=2	conv=notrunc
	mcopy -i $(FAT_32) $(OS_FILES)/test.txt ::


# Clean target to clean all subdirectories
clean:
	rm -rf  build/
	find . -type f -name "*.log" -delete

.PHONY: all $(SUBDIRS) boot_img
