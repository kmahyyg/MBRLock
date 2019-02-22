; This file is responsible for get input and Decrypt Data.
; Location: FDD 1,0,0,2

CPU 486
BITS 16

OffsetofTeststr equ 8100h
OffsetofEncrypted equ 8500h
MaxPWDLen equ 8
MBRLen equ 512

start:
    ; load teststr
    mov ax,0
    mov es,ax
    mov bx,OffsetofTeststr
    mov al,1
    mov ch,0
    mov dh,0
    mov cl,4
    mov dh,0
    mov dl,0
    mov ah,2
    int 13h
    ; show hint
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
    cld
    mov di, Useript
    push di
    mov di, Useript
    xor cx,cx  ; clear cx
    xor bx,bx  ; clear bx
    mov si, OffsetofTeststr
    jmp getinput
    
getinput:
    ; thanks to sunny den
    ;   get keystroke
    xor ax,ax   ;ax=0
    int 16h
    ;   if 'enter' is pressed, then goto.
    cmp al,0x0d
    je verifyPWD
    ;   if max length is met, then goto.
    cmp cx,MaxPWDLen
    je verifyPWD
    ;   else, save input to es:di
    stosb
    inc cx
    mov [PWDLen],cx
    jmp getinput
    
verifyPWD:
    ; xor with test str
    mov cx,LenTestStr
    mov si,OffsetofTeststr
    mov ax,TestStr
    cmp cx,0
    je loadOnce
    xor [si],di
    cmp si,ax
    dec cx
    je verifyPWD
    jne onFailverify
    
loadOnce:
    mov ax,0
    mov es,ax
    mov bx,OffsetofEncrypted
    mov al,1
    mov ch,0
    mov dh,0
    mov cl,3
    mov dh,0
    mov dl,80
    mov ah,2
    int 13h
    mov bx,PWDLen
    mov di,Useript
    mov cx, MBRLen   ; MBR length
    jmp onsuccessVerify

onSuccessVerify:
    ; call decrypt whole sector
    ; param: es:di,encrypt keys
    ; param: readMBR into 0x8100
    ; param: encryptedMBR into 0x8400
    ; Len == 512, > 8 Bits, Fuck
    ; ENHANCEMENT REQUIRED FOR FUTURE: Encrypt Alg.
    xor [si],di
    inc di
    inc si
    ; Judge and Write
    ; BX == CurrentPasswordLength, CX == MBR Length (512 Bytes - 0x200)
    dec cx
    cmp cx,1
    je onSuccessDecrypt
    dec bx
    cmp bx,0
    je resetPWDStat
    jmp onSuccessVerify
    
resetPWDStat:
    mov cx,PWDLen
    ret
    
onSuccessDecrypt:
    int 19h ; for reboot
    
onFailverify:
    mov ax,1301h
    mov bh,0
    mov bl,11110000b
    mov cx,LenNote3
    mov dx,0
    push cs
    pop es
    mov bp,Note3
    int 10h
    
Note2: 
    db "Input Password: ",10,13
LenNote2 equ ($-Note2)

Note3: 
    db "Incorrect.",10,13
LenNote3 equ ($-Note3)

Note4: 
    db "Decrypt Done. Reboot Now."
LenNote4 equ ($-Note4)

TestStr:
    db "12345678"   ; Test string should be write to FDD1,0,0,4
LenTestStr equ ($-TestStr)

Useript:
    times 9 db 0
PWDLen:
    db 0
    
;Padding with 0
times 512-($-$$) db 0 

