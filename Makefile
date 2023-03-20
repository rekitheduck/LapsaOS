all:
    nasm -fbin kernel.asm -o kernel.bin
    nasm -fbin bootloader.asm -o bootloader.bin
    cat bootloader.bin kernel.bin > disk.bin
    qemu-system-i386 disk.bin

clean:
    rm -fv bootloader.bin kernel.bin disk.bin
