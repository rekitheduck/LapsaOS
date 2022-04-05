org 0x7C00
; Reset disk system
mov ah, 0
int 0x13 ; 0x13 ah=0 dl = drive number

; Read from hard drive and write to RAM
mov bx, 0x8000      ; bx = address to write kernel to
mov al, 1           ; al = amount of sectors to read
mov ch, 0           ; cylinder/track = 0
mov dh, 0           ; head = 0
mov cl, 2           ; sector = 2
mov ah, 2           ; ah = 2: read from drive
int 0x13

jmp 0x8000
times 510-($-$$) db 0
; Mandatory MBR signature
db 0x55
db 0xAA