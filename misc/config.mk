# Directories
PROJECT=/root/os
BUILD_DIR=$(PROJECT)/build
DOCS_DIR=$(PROJECT)/docs
MISC_DIR=$(PROJECT)/misc
SRC_DIR=$(PROJECT)/src

BOOT_DIR=$(SRC_DIR)/bootloader
KERNEL_DIR=$(SRC_DIR)/kernel

OS_FILES=$(MISC_DIR)/osfiles

BOOT_BIN=$(BUILD_DIR)/bootloader/bin
BOOT_OBJ=$(BUILD_DIR)/bootloader/obj

KERNEL_BIN=$(BUILD_DIR)/kernel/bin
KERNEL_OBJ=$(BUILD_DIR)/kernel/obj
KERNEL_LIB=$(BUILD_DIR)/kernel/lib

DEBUG_DIR=$(BUILD_DIR)/debug

ASM=nasm
ASM_FLAGS=-W+all -W+error -W+orphan-labels -W+macro-params -W+error
ASM_FORMAT=-f elf32

CC=i386-elf-gcc
CC_FLAGS=-m32 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mno-red-zone -fdata-sections -ffunction-sections -std=c11

LD=ld
LD_FLAGS=--gc-sections -m elf_i386
LD_FORMAT=-m elf_i386

OBJ_CPY=i386-elf-objcopy
OBJ_FLAGS=-O binary

EMULATOR=qemu-system-i386
EMUL_FLAGS=-m 128M -serial stdio -no-reboot -d out_asm,in_asm,int,exec,cpu -D $(DEBUG_DIR)/QEMU_log.txt

