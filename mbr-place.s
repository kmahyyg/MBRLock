; New empty MBR for initialize Protect System
; This file is responsible for get input and test password, if Passed, Goto Decrypt.
; Location: MBR, HDD 1, 0,0,1
; 
; CAUTION: THE DATA WILL NOT BE RECOVEABLE, PLEASE USE IT AT YOUR OWN RISK.

org 7c00h
OffsetOfNext equ 8100h 

sTart:
    ; show notification
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
    jmp getnCheck

getnCheck:
    mov ax,0
    int 16h
    cmp al,31h
    jz callEncrypter
    cmp al,32h
    jz callDecrypter
    cmp al,33h
    jz callDirectBoot
    jnz getnCheck

callEncrypter:
    mov ax,cs
    mov es,ax
    mov bx,OffsetOfNext
    mov ah,2  ; read disk
    mov al,1  ; read 1 sector
    mov dl,0   ; drive no.
    mov dh,0   ; head
    mov ch,0   ; cylinder
    mov cl,1   ; sector
    int 13h
    jmp OffsetOfNext

callDecrypter:
    mov ax,cs
    mov es,ax
    mov bx,OffsetOfNext
    mov ah,2  ; read disk
    mov al,1  ; read 1 sector
    mov dl,0   ; drive no.
    mov dh,0   ; cylinder
    mov ch,0   ; track
    mov cl,2   ; sector
    int 13h
    jmp OffsetOfNext

callDirectBoot:
    mov ax,cs
    mov es,ax
    mov bx,OffsetOfNext
    mov ah,2  ; read disk
    mov al,1  ; read 1 sector
    mov dl,80h   ; drive no.
    mov dh,0   ; cylinder
    mov ch,0   ; track
    mov cl,3   ; sector, DO NOT USE 1!
    int 13h
    jmp OffsetOfNext


Note1:
    db "MBR Protect System: 1.Encrypt 2.Decrypt 3.Direct Boot",10,13
LenNote1 equ ($-Note1)

times 440-($-$$) db 0
