; New empty MBR for initialize Protect System
; This file is responsible for get input and test password, if Passed, Goto Decrypt.
; Location: MBR, HDD, 0,0,1
; 
;
; CAUTION: THE DATA WILL NOT BE RECOVEABLE, PLEASE USE IT AT YOUR OWN RISK.

org 7c00h

sTart:
    ; show notification
    push bx
    mov al,0
    mov bh,0
    mov bl,11110000b
    mov cx,LenNote1
    mov dx,0
    push cs
    pop es
    mov bp,offset Note1
    mov ah,13h
    int 10h
    jmp getnCheck

getnCheck:
    ; get user choice and compare

callEncrypter:
    ; load encrypter

callDecrypter:
    ; load decrypter

callDirectBoot:
    ; directboot only


Note1:
    db "MBR Protect System: 1.Encrypt 2.Decrypt 3.Direct Boot"
LenNote1 equ ($-Note1)

ChoiceSaver:
    db 0

times 440-($-$$) db 0
