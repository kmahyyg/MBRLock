; This file is responsible for get input and Encrypt Data
; Location: FDD,0,0,2
; initial input:     decrypt 1 / encrypt 0
; initial input:     password (len<=8)  512/8=64
;     Note: if first method bit is input wrongly, MBR will encrypted twice.
;     Note: if the password is tested to be correct it should be fine.
; Test String 12345678 will be used for password check.
; MBR: Stored in 0,0,3,HDD1

encrypt:
    ; show hint string
    push bx
    mov ax,1301h
    mov bh,0
    mov bl,11110000b
    mov cx,LenNote1
    mov dx,0
    push cs
    pop es
    mov bp,Note1
    int 10h
    ; get input
    
    ; encrypt
    
    ; encrypt done
    push bx
    mov ax,1301h
    mov bh,0
    mov bl,11110000b
    mov cx,LenNote2
    mov dx,0
    push cs
    pop es
    mov bp,Note2
    int 10h
    jmp closepc

closepc:
    ; use APM interface to shutdown
    mov ax,5301h
    xor bx,bx
    int 15h

    mov ax,530eh
    xor bx,bx
    mov cx,0102h
    mov ax,5307h
    mov bx,1
    mov cx,3
    int 15h

; Data region
Note1: 
    db "Encrypt - Input Password: (<= 8 Bytes) "
LenNote1 equ ($-Note2)

Note2: 
    db "Encrypt - Done. Halt Now."
LenNote2 equ ($-Note4)

; End of Data Region

 times 510-($-$$) db 0    ; 1 Sector
 db 0x55,0xAA           ; bootable flag
