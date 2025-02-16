# Use a base image with the necessary tools
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    nasm \
    gcc-multilib \
    qemu-system-x86 \
    dosfstools \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /GeckOS

# Copy your source code into the container
COPY . .

# Compile the 32-bit operating system
RUN make -s

# Run the OS using QEMU
# CMD ["qemu-system-i386", "-kernel", "build/GeckOS_FAT32.bin"]
CMD ["bash"]