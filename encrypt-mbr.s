; This file is responsible for get input and Encrypt Data
; Location: FDD 1,0,0,1
; initial input:     decrypt 1 / encrypt 0
; initial input:     password (len<=8)  512/8=64
;     Note: if first method bit is input wrongly, MBR will encrypted twice.
;     Note: if the password is tested to be correct it should be fine.
; Test String 12345678 will be used for password check.
; MBR: Stored in 0,0,3,HDD1

CPU 486
BITS 16

OffsetofRead equ 8100h
OffsetofWrite equ 8500h

start:
    ;load original MBR
    mov ax,0
    mov es,ax
    mov bx,OffsetofRead
    mov al,1
    mov ch,0
    mov cl,3
    mov dh,0
    mov dl,80
    mov ah,2
    int 13h
    ; show hint string
    xor bx,bx
    mov ax,1301h
    mov bh,0
    mov bl,11110000b
    mov cx,LenNote1
    mov dx,0
    push cs
    pop es
    mov bp,Note1
    int 10h
    cld   ; from left to right
    mov di, Useript
    push di
    xor cx,cx  ; clear cx
    xor bx,bx  ; clear bx
    mov si, OffsetofRead
    
getinput:
    ; thanks to sunny den
    ;   get keystroke
    xor ax,ax   ;ax=0
    int 16h
    ;   if 'enter' is pressed, then goto.
    cmp al,0x0d
    je encrypt
    ;   if max length is met, then goto.
    cmp cx,MaxPWDLen
    je encrypt
    ;   else, save input to es:di
    stosb
    inc cx
    push cx
    mov [PWDLen],cx
    jmp getinput
    
encrypt:
    ; encrypt
    ; param: es:di,encrypt keys
    ; param: readMBR into 0x8100
    ; param: encryptedMBR into 0x8400
    mov bx, cx   ; PWD length
    mov cx, MBRLen   ; MBR length
    ; Len == 512, > 8 Bits, Fuck
    ; ENHANCEMENT REQUIRED FOR FUTURE: Encrypt Alg.
    xor [si],di
    inc di
    inc si
    ; Judge and Write
    ; BX == CurrentPasswordLength, CX == MBR Length (512 Bytes - 0x200)
    dec cx
    cmp cx,1
    je preencryptTeststr
    dec bx
    cmp bx,0
    je resetPWDStat
    jmp encrypt

preencryptTeststr:
    ; the code above using dec and pwdlen to save the length
    ; however, it cost extra storage and stack storage used in getipt
    ; Now you just need to pop it out for magically save
    xor bx,bx
    xor di,di
    xor si,si
    mov bx,LenTestStr
    mov di, Useript
    mov si, TestStr
    cld
    call encryptTeststr

encryptTeststr:
    pop cx
    cmp cx,0
    je writeENCteststr
    xor si,di
    inc si
    inc di
    jmp encryptTeststr

resetPWDStat:
    mov cx,PWDLen
    ret
    
writeENCteststr:
    mov ax,0
    mov es,ax
    mov bx,TestStr
    mov al,1
    mov ch,0
    mov cl,1
    mov dh,0
    mov dl,0
    mov ah,4
    int 13h
    jmp writeFinalMBR
    
writeFinalMBR:
    mov ax,0
    mov es,ax
    mov bx,OffsetofRead
    mov al,1
    mov ch,0
    mov cl,3
    mov dh,0
    mov dl,80
    mov ah,3
    int 13h
    jmp finalfin
     
finalfin:
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
    db "Encrypt - Input Password: (<= 8 Bytes) ",10,13
LenNote1 equ ($-Note1)

Note2: 
    db "Encrypt - Done. Halt Now."
LenNote2 equ ($-Note2)
    
TestStr:
    db "12345678"   ; Test string should be write to FDD1,0,0,4
LenTestStr equ ($-TestStr)

Useript: times 9 db 0

PWDLen: db 0

MaxPWDLen: equ 8

MBRLen: equ 512

; End of Data Region

 times 510-($-$$) db 0    ; 1 Sector
 db 0x55,0xAA           ; bootable flag
