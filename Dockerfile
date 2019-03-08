FROM ubuntu:latest

# Working directory for the build assistant is /builder
COPY . /builder
WORKDIR /builder

# Here we install the necessary utilities from the Ubuntu packages.
# We won't install build-essentials to try and reduce the size of this image.
# This causes us a few problems because we need a few tools. We grab make and
# we make use of the cross compiler's copy of objdump. This is because I usually
# have build-essential installed on my dev computers so I can use the general
# tools available even though they are not the proper tools to be used with the
# special architecture.

# Utilities needed :
#   git  - Used to grab the project sources
#   make - Used to run the build process.
#   nasm - Intel Assembler for processing assembly .asm files
#   qemu - System emulator, it runs the OS on an x86 system
#   grub - GRUB boot loader used to setup the disk
#   tar  - TAR file extractor, used to decompress the Cross-Compiler
#   curl - Used to download the Cross-Compiler files
#
# Afterwards, cleanup by removing APT cache files
RUN apt update && apt install git make nasm qemu-system-x86 grub-pc-bin tar curl -y && rm -rf /var/lib/apt/lists/*

# Set runnable the couple of scripts we have here
RUN chmod +x *.sh

# The install script downloads the Cross-Compiler and extracts it to the
# ~/opt/cross directory.
RUN ./install_compiler.sh

# Since we don't install build-essentials, we need to link the Cross-Compiler
# copy of objdump in the bin directory to be able to use it as 'objdump' later
# on
RUN ln -s /root/opt/cross/bin/i686-elf-objdump /usr/bin/objdump

CMD /builder/run_os.sh
