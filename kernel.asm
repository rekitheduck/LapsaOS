org 0x8000
bits 16

; set cursor to top left first
mov ah, 0x02
mov bh, 0x00 ; page number
mov dh, 0x00 ; cursor row
mov dl, 0x00 ; cursor column
int 0x10;

; clear screen from top left
mov al, 0x00 ; clear value
mov cx, 0x00 ; count
; assume 80x25 screen
.clear_loop:
    call printCharacter
    inc cx
    cmp cx, 0x7D0 ; 2000 (80x25)
    jne .clear_loop

; set cursor back to top left
mov ah, 0x02
mov bh, 0x00 ; page number
mov dh, 0x00 ; cursor row
mov dl, 0x00 ; cursor column
int 0x10;

; write message
mov si, msg
call printNullTerminatedString

jmp $   ; this freezes the system, best for testing
hlt     ; this makes a real system halt
ret     ; this makes qemu halt

; AL = character to print
printCharacter:
    mov bh, 0x00    ; page to write to, page 0 is displayed by default
    mov bl, 0x00    ; color attribute
    mov ah, 0x0E    ; print character BIOS function
    int 0x10
    ret

; SI = start of a null terminated message
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
