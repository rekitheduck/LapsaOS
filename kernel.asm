org 0x8000
bits 16
; write message
mov si, msg
call printNullTerminatedString

jmp $   ; this freezes the system, best for testing
hlt     ; this makes a real system halt
ret     ; this makes qemu halt

printCharacter:
    mov bh, 0x00    ; page to write to, page 0 is displayed by default
    mov bl, 0x00    ; color attribute
    mov ah, 0x0E    ; print character BIOS function
    int 0x10
    ret

printNullTerminatedString:
    pusha ; save all register to be able to call this from everywhere
    .loop:
        lodsb ; loads byte from si into al and increases si
        test al, al ;tests if al is 0, which would mean it's reached the end
        jz .end
        call printCharacter ; prints character in AL
    jmp .loop ; print next character
    .end:
    popa ; restore registers to original state
    ret

msg db "Hello World!"
times 512-($-$$) db 0 ; kernel must have size multiple of 512 so pad it out